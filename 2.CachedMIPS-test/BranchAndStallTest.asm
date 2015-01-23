.text
.globl BranchAndStallTest

BranchAndStallTest:
  # $a0 = register 4, exists until $a3 = register 7
  addi $a0, $zero, 4      # PC=0x00000000  inst= 20040004
  addi $a1, $zero, 0      # PC=0x00000004  inst= 20050000
LOOP:
  lw $a2, 0($a0)          # PC=0x00000008  inst= 8c860000
  lw $a3, 4($a0)          # PC=0x0000000c  inst= 8c870004
  add $a1, $a2, $a3       # PC=0x00000010  inst= 00c72820
  addi $a2, $a1, 8        # PC=0x00000014  inst= 20a60008
  sw $a2, 4($a0)          # PC=0x00000018  inst= ac860004
  beq $a0, $zero, FINISH  # PC=0x0000001c  inst= 10800002
  addi $a0, $a0, -4       # PC=0x00000020  inst= 2084fffc
  # fix the assembler of this by hand, memory virtual things
  j LOOP                  # PC=0x00000024  inst= 08000002

FINISH:
  # noop all-zero opcode
  sll $zero, $zero, 0     # PC=0x00000028


######################################### approximation in 'C'
register int* p = 4;  
register int  j = 0;
LOOP:do {
    j = *p + *(p+1);
    register int k = j + 8;
    *(p+1) = k;
    if (p == 0)
        goto FINISH;
    p = p - 1;
    goto LOOP;
}
FINISH:
 return 0
#########################################
#########################################
#########################################  CachedMIPS :
-----------------CPI_loop = 18 cyles / 8 inst = 2.25 -----------------

                                           10  12  14  16  17  18
                    PC    1 2 3 4 5 6 7 8 9  11  13  15  18  19  20
addi R4, R0, 4      00    F F F F D E L C W                                  <- Miss IC
addi R5, R0, 0      04            F D E L C W                                <- Hit IC
------------------------------------------------------------------#LOOP
lw   R6, 0(R4)      08              F D E L L L L C W                        <- Hit IC, Miss DC, R4 comes from a forwarding path from L unit to E
lw   R7, 4(R4)      0c                F D E E E E L C W                      <- Hit IC, Hit DC, R4 comes from a forwarding path from C unit to E
add  R5, R6, R7     10                  F F F f f D E L C W                  <- Miss IC, Stall due true dependency R7 not ready, R7 comes from fwd C to E
addi R6, R5, 8      14                            F F F F D E L C W          <- R5 comes from a forwarding path from E unit to E
sw   R6, 4(R4)      18                                    F D E L L L L C W
beq  R4, R0, FINISH 1c                                      F D D D D E L C W            <- don't branch in M because it's not going to jump 
addi R4, R0, 4      20                                        F F F F D E L C W          <- Miss IC
j    LOOP           24                                                F D E L C W        <- Jump in EXE stage, put nops in IF,ID,ALU 
sll  R0, R0, 0      28                                                  F D - - -
-                   2C                                                    F - - - -
----------------------------------------------------------------------    
lw R6, O(R4)        08                              F D E M W           <- Jump resolved with a PC=0008
#########################################
#########################################
#########################################  PipelinedMIPS :
-----------------CPI_loop = 15 cyles / 8 inst = 1,875 -----------------

                                           10  12  14  16  17  18
                    PC    1 2 3 4 5 6 7 8 9  11  13  15  18  19  20
addi R4, R0, 4      00    F D E M W
addi R5, R0, 0      04      F D E M W
------------------------------------------------------------------#LOOP
lw   R6, 0(R4)      08        F D E M W                                 <- R4 comes from a forwarding path from M unit to E
lw   R7, 4(R4)      0c          F D E M W              
add  R5, R6, R7     10            F D D E M W                           <- Stall due true dependency R7 not ready
addi R6, R5, 8      14              F F D E M W                         <- R5 comes from a forwarding path from E unit to E                   
sw   R6, 4(R4)      18                  F D E M W
beq  R4, R0, FINISH 1c                    F D E M W                     <- don't branch in M because it's not going to jump 
addi R4, R0, 4      20                      F D E M W
j    LOOP           24                        F D E M W                 <- Jump in EXE stage, put nops in IF,ID,ALU 
sll  R0, R0, 0      28                          F D - - -
-                   2C                            F - - - -
----------------------------------------------------------------------    
lw R6, O(R4)        08                              F D E M W           <- Jump resolved with a PC=0008
etc...
#########################################
#########################################