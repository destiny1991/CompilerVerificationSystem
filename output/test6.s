	.file	"test6.c"

	.section .rodata
	.align 2                                         # 5.9_fc
.LC0:	                                            # 5.9_fc
	.string	"The add result is : %d\n"               # 5.9_fc
	.align 2                                         # 5.10_fc
.LC1:	                                            # 5.10_fc
	.string	"The sub result is : %d\n"               # 5.10_fc

	.section ".text"
	.align 2                                         # 5_fs
	.globl main                                      # 5_fs
	.type main, @function                            # 5_fs
main:	                                            # 5_fs
	stwu 1,-32(1)                                    # 5_fs
	mflr 0                                           # 5_fs
	stw 31,28(1)                                     # 5_fs
	stw 0,36(1)                                      # 5_fs
	mr 31,1                                          # 5_fs

	li 0,1                                           # 5.4_as
	stw 0,8(31)                                      # 5.4_as

	li 0,2                                           # 5.5_as
	stw 0,12(31)                                     # 5.5_as

	lwz 3,8(31)                                      # 5.6_fc
	li 4,3                                           # 5.6_fc
	bl add                                           # 5.6_fc

	stw 3,16(31)                                     # 5.6_as

	lwz 3,8(31)                                      # 5.7_fc
	lwz 4,16(31)                                     # 5.7_fc
	lwz 5,12(31)                                     # 5.7_fc
	bl sub                                           # 5.7_fc

	stw 3,20(31)                                     # 5.7_as

	li 3,4                                           # 5.8_fc
	bl inc                                           # 5.8_fc

	stw 3,24(31)                                     # 5.8_as

	lis 0,.LC0@ha                                    # 5.9_fc
	addic 0,0,.LC0@l                                 # 5.9_fc
	mr 3,0                                           # 5.9_fc
	lwz 4,16(31)                                     # 5.9_fc
	crxor 6,6,6                                      # 5.9_fc
	bl printf                                        # 5.9_fc

	lis 0,.LC1@ha                                    # 5.10_fc
	addic 0,0,.LC1@l                                 # 5.10_fc
	mr 3,0                                           # 5.10_fc
	lwz 4,20(31)                                     # 5.10_fc
	crxor 6,6,6                                      # 5.10_fc
	bl printf                                        # 5.10_fc

	li 0,0                                           # 5.11_re
	mr 3,0                                           # 5.11_re
	lwz 11,0(1)                                      # 5_fs
	lwz 0,4(11)                                      # 5_fs
	mtlr 0                                           # 5_fs
	lwz 31,-4(11)                                    # 5_fs
	mr 1,11                                          # 5_fs
	blr                                              # 5_fs
	.size main,.-main                                # 5_fs

	.section .rodata
	.align 2                                         # 7.3_fc
.LC2:	                                            # 7.3_fc
	.string	"add function %d\n"                      # 7.3_fc
	.align 2                                         # 7.4_fc
.LC3:	                                            # 7.4_fc
	.string	"add x %d, y %d\n"                       # 7.4_fc
	.align 2                                         # 7.5_fc
.LC4:	                                            # 7.5_fc
	.string	"addd addd\n"                            # 7.5_fc

	.section ".text"
	.align 2                                         # 7_fs
	.globl add                                       # 7_fs
	.type add, @function                             # 7_fs
add:	                                             # 7_fs
	stwu 1,-32(1)                                    # 7_fs
	stw 31,28(1)                                     # 7_fs
	mr 31,1                                          # 7_fs

	lwz 9,28(31)                                     # 7.2_ex
	lwz 0,32(31)                                     # 7.2_ex
	add 0,9,0                                        # 7.2_ex
	stw 0,40(31)                                     # 7.2_ex

	lwz 0,40(31)                                     # 7.2_as
	stw 0,36(31)                                     # 7.2_as

	lis 0,.LC2@ha                                    # 7.3_fc
	addic 0,0,.LC2@l                                 # 7.3_fc
	mr 3,0                                           # 7.3_fc
	lwz 4,36(31)                                     # 7.3_fc
	crxor 6,6,6                                      # 7.3_fc
	bl printf                                        # 7.3_fc

	lis 0,.LC3@ha                                    # 7.4_fc
	addic 0,0,.LC3@l                                 # 7.4_fc
	mr 3,0                                           # 7.4_fc
	lwz 4,28(31)                                     # 7.4_fc
	lwz 5,32(31)                                     # 7.4_fc
	crxor 6,6,6                                      # 7.4_fc
	bl printf                                        # 7.4_fc

	lis 0,.LC4@ha                                    # 7.5_fc
	addic 0,0,.LC4@l                                 # 7.5_fc
	mr 3,0                                           # 7.5_fc
	crxor 6,6,6                                      # 7.5_fc
	bl printf                                        # 7.5_fc

	lwz 0,36(31)                                     # 7.6_re
	mr 3,0                                           # 7.6_re
	lwz 11,0(1)                                      # 7_fs
	lwz 31,-4(11)                                    # 7_fs
	mr 1,11                                          # 7_fs
	blr                                              # 7_fs
	.size add,.-add                                  # 7_fs

	.section .rodata
	.align 2                                         # 9.3_fc
.LC5:	                                            # 9.3_fc
	.string	"sub function %d\n"                      # 9.3_fc

	.section ".text"
	.align 2                                         # 9_fs
	.globl sub                                       # 9_fs
	.type sub, @function                             # 9_fs
sub:	                                             # 9_fs
	stwu 1,-32(1)                                    # 9_fs
	stw 31,28(1)                                     # 9_fs
	mr 31,1                                          # 9_fs

	lwz 9,44(31)                                     # 9.2_ex
	lwz 0,48(31)                                     # 9.2_ex
	subf 0,9,0                                       # 9.2_ex
	stw 0,56(31)                                     # 9.2_ex

	lwz 9,40(31)                                     # 9.2_ex
	lwz 0,56(31)                                     # 9.2_ex
	subf 0,9,0                                       # 9.2_ex
	stw 0,60(31)                                     # 9.2_ex

	lwz 0,60(31)                                     # 9.2_as
	stw 0,52(31)                                     # 9.2_as

	lis 0,.LC5@ha                                    # 9.3_fc
	addic 0,0,.LC5@l                                 # 9.3_fc
	mr 3,0                                           # 9.3_fc
	lwz 4,52(31)                                     # 9.3_fc
	crxor 6,6,6                                      # 9.3_fc
	bl printf                                        # 9.3_fc

	lwz 0,52(31)                                     # 9.4_re
	mr 3,0                                           # 9.4_re
	lwz 11,0(1)                                      # 9_fs
	lwz 31,-4(11)                                    # 9_fs
	mr 1,11                                          # 9_fs
	blr                                              # 9_fs
	.size sub,.-sub                                  # 9_fs

	.section .rodata

	.section ".text"
	.align 2                                         # 11_fs
	.globl inc                                       # 11_fs
	.type inc, @function                             # 11_fs
inc:	                                             # 11_fs
	stwu 1,-32(1)                                    # 11_fs
	stw 31,28(1)                                     # 11_fs
	mr 31,1                                          # 11_fs

	lwz 9,56(31)                                     # 11.2_ex
	li 0,1                                           # 11.2_ex
	add 0,9,0                                        # 11.2_ex
	stw 0,64(31)                                     # 11.2_ex

	lwz 0,64(31)                                     # 11.2_as
	stw 0,60(31)                                     # 11.2_as

	lwz 0,60(31)                                     # 11.3_re
	mr 3,0                                           # 11.3_re
	lwz 11,0(1)                                      # 11_fs
	lwz 31,-4(11)                                    # 11_fs
	mr 1,11                                          # 11_fs
	blr                                              # 11_fs
	.size inc,.-inc                                  # 11_fs

	.ident	"powerpc-e500v2-linux-gnuspe-gcc"
