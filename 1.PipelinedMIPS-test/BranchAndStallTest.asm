.text
.globl BranchAndStallTest

BranchAndStallTest:
  # $a0 = register 4, exists until $a3 = register 7
  addi $a0, $zero, 4      # PC=0x00000000
  addi $a1, $zero, 0      # PC=0x00000004
LOOP:
  lw $a2, 0($a0)          # PC=0x00000008
  lw $a3, 4($a0)          # PC=0x0000000c
  add $a1, $a2, $a3       # PC=0x00000010
  addi $a2, $a1, 8        # PC=0x00000014
  sw $a2, 4($a0)          # PC=0x00000018
  beq $a0, $zero, FINISH  # PC=0x0000001c
  addi $a0, $a0, -4       # PC=0x00000020
  # fix the assembler of this by hand, memory virtual things
  j LOOP                  # PC=0x00000024

FINISH:
  # noop all-zero opcode
  sll $zero, $zero, 0     # PC=0x00000028


#########################################

00    F D E M W
04      F D E M W
08        F D E M W
0c          F D E M W
10            F D D E M W
14              F F D E M W
18                  F D E M W
1c                    F D E M W
20                      F F D E M W
24                          F D E M W
28                            F F -
08                                F D E M W
----------------------------------------------------
08    F D E M W
0c      F D E M W
10        F D D E M W
14          F F D E M W
18              F D E M W
1c                F D E M W
20                  F F -
28                      F
