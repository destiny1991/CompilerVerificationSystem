package cn.edu.buaa.prover;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import cn.edu.buaa.constant.CommonsDefine;
import cn.edu.buaa.constant.ProverDefine;
import cn.edu.buaa.pojo.Item;
import cn.edu.buaa.pojo.Proposition;
import cn.edu.buaa.recorder.Recorder;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;

public class Prover {

	// 专用公理集
	private Map<String, Proposition> axioms;
	// 所有语句的目标码模式
	private Map<String, List<String>> allObjectCodePatterns;
	// 所有的循环不变式语句
	private Map<String, List<Proposition>> loopInvariants;
	
	private Recorder recorder;
	
	private final Logger logger = LoggerFactory.getLogger(Prover.class);
	
	// 中间过程输出结果
	public BufferedWriter bufferedWriter;

	public Prover(Recorder recorder) {
		loadAxioms("src/main/resources/axiom/ppcAxiom.xls");
		// showAxioms();

		loadAllObjectCodePatterns("src/main/resources/statement/");
		// showAllObjectCodePatterns();
		
		loadPrecoditions("src/main/resources/precodition/");
		// showAllLoopInvariants();
		
		this.recorder = recorder;
	}
	
	public boolean runProver(String key) {		
		List<String> objectCodePatterns = getObjectCodePatterns(key);
		createOutputFile(key);
		return proveProcess(objectCodePatterns, key);
		
	}
	
	/**
	 * 对输入的目标码模式进行证明： 1) 目标码映射 2) 推理证明 3) 获得语义
	 * 
	 * @param objectCodePatterns
	 * @throws IOException
	 */
	public boolean proveProcess(List<String> objectCodePatterns, String name) {
		
		// 验证结果
		boolean isSame = false;
		
		recorder.insertLine("待证 : " + name);
		recorder.insertLine("==============目标码模式===============");
		showSingleObjectCodePatterns(objectCodePatterns);
		
		logger.info("待证 : " + name);
		
		if (bufferedWriter != null) {
			try {
				bufferedWriter.write("目标码模式 :\n");
				saveAllString(objectCodePatterns);
				bufferedWriter.flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		// 命题映射
		recorder.insertLine("==============目标码模式命题===============");
		logger.info("调用命题映射算法");
		List<Proposition> propositions = PropositionMappingAlgorithm.process(objectCodePatterns, axioms);
		showAllProposition(propositions);
				
		if (bufferedWriter != null) {
			try {
				bufferedWriter.write("目标码模式命题 :\n");
				ProverHelper.saveAllProposition(propositions, bufferedWriter);
				bufferedWriter.flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		if (!ProverDefine.LOOPS.contains(name)) {
			// 非循环命题推导
			recorder.insertLine("==============命题推理结果===============");
			logger.info("调用自动推理算法");
			List<Proposition> simplifiedPropositions = AutomaticDerivationAlgorithm.process(propositions);
			showAllProposition(simplifiedPropositions);
			if (bufferedWriter != null) {
				try {
					bufferedWriter.write("命题推理结果 :\n");
					ProverHelper.saveAllProposition(simplifiedPropositions, bufferedWriter);
					bufferedWriter.flush();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			
			// 获得语义
			recorder.insertLine("=============推理出的语义================");
			List<Proposition> semantemes = SemantemeObtainAlgorithm.obtainSemantemeFromProposition(simplifiedPropositions);
			showAllProposition(semantemes);	
			recorder.insertLine("σ-transfer :");
			List<Proposition> sigmaSemantemes = SemantemeObtainAlgorithm.standardSemantemes(semantemes);
			showAllProposition(sigmaSemantemes);
			
			if (bufferedWriter != null) {
				try {
					bufferedWriter.write("推理出的语义为 :\n");
					ProverHelper.saveAllProposition(semantemes, bufferedWriter);
					bufferedWriter.write("σ-transfer : \n\n");
					ProverHelper.saveAllProposition(sigmaSemantemes, bufferedWriter);
					bufferedWriter.flush();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			
			// 给定的目标语义
			recorder.insertLine("=============给定的目标语义================");
			List<Proposition> goals = loopInvariants.get(name);
			showAllProposition(goals);
			if (bufferedWriter != null) {
				try {
					bufferedWriter.write("给定的目标语义为 :\n");
					ProverHelper.saveAllProposition(goals, bufferedWriter);
					bufferedWriter.flush();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			
			// 判断语义是否一致
			recorder.insertLine("===============结论================");
			recorder.insertLine("给定的目标语义和推理出的语义是否一致 : ");
			isSame = LoopInteractiveProvingAlgorithm.judgeSemantemes(goals, sigmaSemantemes);
			recorder.insertLine(Boolean.toString(isSame));
			if (bufferedWriter != null) {
				try {
					bufferedWriter.write("给定的目标语义和推理出的语义是否一致 :\n");
					bufferedWriter.write(Boolean.toString(isSame));
					bufferedWriter.newLine();
					bufferedWriter.flush();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			
		} else {
			// 循环交互证明算法
			recorder.insertLine("=================循环交互证明算法===================");
			try {
				logger.info("调用循环交互证明算法");
				isSame = LoopInteractiveProvingAlgorithm.process(propositions, name, loopInvariants, bufferedWriter, recorder);
				recorder.insertLine("综上，给定的目标语义和推理出的语义是否一致 :");
				recorder.insertLine(Boolean.toString(isSame));
				
				if (bufferedWriter != null) {
					bufferedWriter.write("综上，给定的目标语义和推理出的语义是否一致 :\n");
					bufferedWriter.write(Boolean.toString(isSame));
					bufferedWriter.newLine();
					bufferedWriter.flush();
				}
				
			} catch (IOException e) {
				e.printStackTrace();
			}
			
		}
		
		return isSame;
	}

	public List<String> getObjectCodePatterns(String key) {
		return allObjectCodePatterns.get(key);
	}

	public void loadAxioms(String path) {
		axioms = new HashMap<>();

		Workbook readwb = null;
		try {
			readwb = Workbook.getWorkbook(new File(path));
			Sheet readsheet = readwb.getSheet(0);

			// 读取xls文档
			int rsRows = readsheet.getRows();
			int i = 1;
			while (i < rsRows) {
				String name = readsheet.getCell(0, i).getContents().trim();
				if (name == null || name.length() == 0)
					continue;

				List<Item> items = new ArrayList<Item>();
				Proposition proposition = new Proposition(items);
				while (i < rsRows) {
					String tmp = readsheet.getCell(0, i).getContents().trim();
					if (null == tmp || tmp.length() == 0 || tmp.equals(name)) {
						String premise = readsheet.getCell(1, i).getContents().trim();
						String left = readsheet.getCell(2, i).getContents().trim();
						String right = readsheet.getCell(3, i).getContents().trim();

						if (null == premise || premise.length() == 0)
							premise = null;
						if (null == left || left.length() == 0)
							left = null;
						if (null == right || right.length() == 0)
							right = null;

						if (null != premise || null != left || null != right) {
							Item item = new Item(premise, left, right);
							items.add(item);
						}

						i++;
					} else {
						break;
					}
				}

				axioms.put(name, proposition);
				name = null;
			}

		} catch (BiffException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void showAxioms() {
		for (String name : axioms.keySet()) {
			Proposition proposition = axioms.get(name);
			System.out.println(name + ":");
			System.out.println(proposition);
		}
	}

	public void loadPrecoditions(String dirName) {
		loopInvariants = new HashMap<>();

		File dir = new File(dirName);
		for (String fileName : dir.list()) {
			String path = dirName;
			if (!path.endsWith("/"))
				path += "/";
			path += fileName;

			List<Proposition> value = loadSingleLoopInvariants(path);
			String key = fileName.substring(0, fileName.indexOf('.'));
			loopInvariants.put(key, value);
		}
	}
	
	public List<Proposition> loadSingleLoopInvariants(String path) {
		
		List<Proposition> singleLoopInvariants = new ArrayList<>();
		BufferedReader in = null;
		try {
			in = new BufferedReader(new FileReader(path));
			String line = null;
			while ((line = in.readLine()) != null) {
				Proposition proposition = LoopInteractiveProvingAlgorithm.analyzeString(line);
				singleLoopInvariants.add(proposition);
			}
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		
		return singleLoopInvariants;
	}
	
	public void showAllLoopInvariants() {
		
		for (String key : loopInvariants.keySet()) {
			List<Proposition> values = loopInvariants.get(key);
			System.out.println(key + "::");
			for (Proposition proposition : values) {
				System.out.println(proposition);
			}
			System.out.println();
		}
		
	}

	public void loadAllObjectCodePatterns(String dirName) {
		allObjectCodePatterns = new HashMap<>();

		File dir = new File(dirName);
		for (String fileName : dir.list()) {
			String path = dirName;
			if (!path.endsWith("/"))
				path += "/";
			path += fileName;

			List<String> objectCodePatterns = loadSingleObjectCodePatterns(path);
			String key = fileName.substring(0, fileName.indexOf('.'));
			allObjectCodePatterns.put(key, objectCodePatterns);
		}
	}
	
	public List<String> loadSingleObjectCodePatterns(String path) {

		List<String> objectCodePatterns = new ArrayList<>();
		BufferedReader reader = null;
		try {
			reader = new BufferedReader(new FileReader(path));
			String line = null;
			while (null != (line = reader.readLine())) {
				line = line.trim();
				if (line.length() == 0)
					continue;
				objectCodePatterns.add(line);
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (reader != null) {
				try {
					reader.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

		return objectCodePatterns;
	}
	
	public void showAllObjectCodePatterns() {

		for (String key : allObjectCodePatterns.keySet()) {
			List<String> objectCodePatterns = allObjectCodePatterns.get(key);
			System.out.println(key + "::");
			showSingleObjectCodePatterns(objectCodePatterns);
		}

	}
	
	public void showSingleObjectCodePatterns(List<String> objectCodePatterns) {
		for (String line : objectCodePatterns) {
			recorder.insertLine(line);
		}
		recorder.insertLine(null);
		
	}
	
	public void showAllProposition(List<Proposition> propositions) {
		for (Proposition proposition : propositions) {
			recorder.insertLine(proposition.toString());
		}
	}

	public void createOutputFile(String key) {
		try {
			bufferedWriter = new BufferedWriter(new FileWriter(CommonsDefine.DEBUG_PATH + key + ".txt"));
			bufferedWriter.write("======================结果输出=======================\n");
			bufferedWriter.write("语句 : " + key + "\n");
			bufferedWriter.newLine();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	public void saveAllString(List<String> objectCodePatterns) throws IOException {
		for (String str : objectCodePatterns) {
			bufferedWriter.write(str);
			bufferedWriter.newLine();
		}
		bufferedWriter.newLine();
		bufferedWriter.flush();
	}

	public static void main(String[] args) {
		Recorder recorder = new Recorder();
		Prover prover = new Prover(recorder);
		prover.runProver("if");
	}
}
