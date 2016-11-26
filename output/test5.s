	.file	"test5.c"

	.section .rodata
	.align 2                                         # 6.3_fc
.LC0:	                                            # 6.3_fc
	.string	"%f %f %f %f"                            # 6.3_fc
	.align 2                                         # 6.4_fc
.LC1:	                                            # 6.4_fc
	.string	"%f %f %f %f"                            # 6.4_fc
	.align 3                                         # 6.5_as
.LC2:	                                            # 6.5_as
	4607182418800017408                              # 6.5_as
	4611686018427387904                              # 6.5_as
	.align 3                                         # 6.6_as
.LC3:	                                            # 6.6_as
	4607182418800017408                              # 6.6_as
	4613937818241073152                              # 6.6_as
	.align 3                                         # 6.8_ex
.LC4:	                                            # 6.8_ex
	1                                                # 6.8_ex
	0                                                # 6.8_ex

	.section ".text"
	.align 2                                         # 6_fs
	.globl main                                      # 6_fs
	.type main, @function                            # 6_fs
main:	                                            # 6_fs
	stwu 1,-32(1)                                    # 6_fs
	mflr 0                                           # 6_fs
	stw 31,28(1)                                     # 6_fs
	stw 0,36(1)                                      # 6_fs
	mr 31,1                                          # 6_fs

	lis 0,.LC0@ha                                    # 6.3_fc
	addic 0,0,.LC0@l                                 # 6.3_fc
	mr 3,0                                           # 6.3_fc
	lfs 4,8(31)                                      # 6.3_fc
	lfs 5,12(31)                                     # 6.3_fc
	lfs 6,16(31)                                     # 6.3_fc
	lfs 7,20(31)                                     # 6.3_fc
	crxor 6,6,6                                      # 6.3_fc
	bl __isoc99_scanf                                # 6.3_fc

	lis 0,.LC1@ha                                    # 6.4_fc
	addic 0,0,.LC1@l                                 # 6.4_fc
	mr 3,0                                           # 6.4_fc
	lfs 4,8(31)                                      # 6.4_fc
	lfs 5,12(31)                                     # 6.4_fc
	lfs 6,16(31)                                     # 6.4_fc
	lfs 7,20(31)                                     # 6.4_fc
	crxor 6,6,6                                      # 6.4_fc
	bl printf                                        # 6.4_fc

	lis 9,.LC2@ha                                    # 6.5_as
	lfs 0,.LC2@l(9)                                  # 6.5_as
	stfs 0,8(31)                                     # 6.5_as

	lis 9,.LC3@ha                                    # 6.6_as
	lfs 0,.LC3@l(9)                                  # 6.6_as
	stfs 0,12(31)                                    # 6.6_as

	lfs 13,8(31)                                     # 6.7_ex
	lfs 0,12(31)                                     # 6.7_ex
	fmuls 0,13,0                                     # 6.7_ex
	stfs 0,24(31)                                    # 6.7_ex

	lfs 13,24(31)                                    # 6.7_ex
	lfs 0,8(31)                                      # 6.7_ex
	fadds 0,13,0                                     # 6.7_ex
	stfs 0,28(31)                                    # 6.7_ex

	lfs 0,28(31)                                     # 6.7_as
	stfs 0,16(31)                                    # 6.7_as

	lfs 13,8(31)                                     # 6.8_ex
	lis 9,.LC4@ha                                    # 6.8_ex
	lfs 0,.LC4@l(9)                                  # 6.8_ex
	fcmpu 7,0,13                                     # 6.8_ex
	li 0,0                                           # 6.8_ex
	li 9,1                                           # 6.8_ex
	isel 0,9,0,29                                    # 6.8_ex
	stw 0,24(31)                                     # 6.8_ex

	li 0,0                                           # 6.9_re
	mr 3,0                                           # 6.9_re
	lwz 11,0(1)                                      # 6_fs
	lwz 0,4(11)                                      # 6_fs
	mtlr 0                                           # 6_fs
	lwz 31,-4(11)                                    # 6_fs
	mr 1,11                                          # 6_fs
	blr                                              # 6_fs
	.size main,.-main                                # 6_fs

	.section .rodata

	.section ".text"
	.align 2                                         # 8_fs
	.globl add                                       # 8_fs
	.type add, @function                             # 8_fs
add:	                                             # 8_fs
	stwu 1,-32(1)                                    # 8_fs
	stw 31,28(1)                                     # 8_fs
	mr 31,1                                          # 8_fs

	lwz 11,0(1)                                      # 8_fs
	lwz 31,-4(11)                                    # 8_fs
	mr 1,11                                          # 8_fs
	blr                                              # 8_fs
	.size add,.-add                                  # 8_fs

	.section .rodata

	.section ".text"
	.align 2                                         # 10_fs
	.globl sub                                       # 10_fs
	.type sub, @function                             # 10_fs
sub:	                                             # 10_fs
	stwu 1,-32(1)                                    # 10_fs
	stw 31,28(1)                                     # 10_fs
	mr 31,1                                          # 10_fs

	lwz 11,0(1)                                      # 10_fs
	lwz 31,-4(11)                                    # 10_fs
	mr 1,11                                          # 10_fs
	blr                                              # 10_fs
	.size sub,.-sub                                  # 10_fs

	.section .rodata

	.section ".text"
	.align 2                                         # 12_fs
	.globl mul                                       # 12_fs
	.type mul, @function                             # 12_fs
mul:	                                             # 12_fs
	stwu 1,-32(1)                                    # 12_fs
	stw 31,28(1)                                     # 12_fs
	mr 31,1                                          # 12_fs

	lwz 11,0(1)                                      # 12_fs
	lwz 31,-4(11)                                    # 12_fs
	mr 1,11                                          # 12_fs
	blr                                              # 12_fs
	.size mul,.-mul                                  # 12_fs

	.ident	"powerpc-e500v2-linux-gnuspe-gcc"
