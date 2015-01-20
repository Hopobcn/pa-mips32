library ieee;
use ieee.std_logic_1164.all;

entity control_inst_decode is
    port (-- buses
          opcode      :   in  std_logic_vector(5 downto 0);
          -- control logic
          RegWrite    :   out std_logic;
          Jump        :   out std_logic;
          Branch      :   out std_logic;
          MemRead     :   out std_logic;                              
          MemWrite    :   out std_logic;
          ByteAddress :   out std_logic;
          WordAddress :   out std_logic;
          MemtoReg    :   out std_logic;
          RegDst      :   out std_logic;  
          ALUOp       :   out std_logic_vector(2 downto 0);
          ALUSrc      :   out std_logic);
            
end control_inst_decode;

architecture Structure of control_inst_decode is

begin
    -- For me 'X' means I don't know and 'Z' means I don't mind whatever value 

    RegWrite <= '1' when opcode = "000000" else -- R-type inst (add,addu,and,div,divu,mult,multu,nor,or,..)
                    --Arithmetic Instructions                      (sll,sllv,sra,srav,srl,srlv,sub,subu,xor,slt,sltu,jalr,jr)
                    '1' when opcode = "001000" else -- addi
                    '1' when opcode = "001001" else -- addiu
                    '1' when opcode = "001100" else -- andi
                    '1' when opcode = "011100" else -- clo/clz/mul/madd/maddu/msub/msuub
                    '1' when opcode = "001101" else -- ori
                    '1' when opcode = "001110" else -- xori
                    --Constant Manipulating Instructions
                    '1' when opcode = "001111" else -- lui (Load upper immediate)
                    --Comparison Instructions
                    '1' when opcode = "001010" else -- slti (Set less than immediate)
                    '1' when opcode = "001011" else -- sltiu (Set less than immediate unsigned)
                    --Branch Instructions                   
                    '0' when opcode = "000100" else -- beq (Branch on equal)
                    '0' when opcode = "000101" else -- bne (Branch on not equal)
                    '0' when opcode = "000110" else -- blez (Branch on less than equal zero)
                    '0' when opcode = "000111" else -- bgtz (Branch on greather than zero)                  
                    '0' when opcode = "000001" else -- bgez/bgezal/bltzal/bltz (Branch on ... and link)
                    --Jump Instructions
                    '0' when opcode = "000010" else -- j (jump)
                    '1' when opcode = "000011" else -- jal (jump and link)
                    --Load Instructions
                    '1' when opcode = "100000" else -- lb (Load Byte)
                    '1' when opcode = "100001" else -- lh (Load Half word)
                    '1' when opcode = "100010" else -- lwl (Load word left)
                    '1' when opcode = "100011" else -- lw
                    '1' when opcode = "100100" else -- lbu (Load Byte unsigned)
                    '1' when opcode = "100101" else -- lhu (Load Half word unsigned)
                    '1' when opcode = "100110" else -- lwr (Load word right)
                    '1' when opcode = "110000" else -- ll (Load Link -- FOR MULTIPROCESSORS & Atomics)
                 --'1' when opcode = "110001" else -- lwc1 (Load word coprocessor 1 - for floating point)
                    --Store Instructions
                    '0' when opcode = "101000" else -- sb (Store Byte)
                    '0' when opcode = "101001" else -- sh (Store Half word)
                    '0' when opcode = "101010" else -- swl (Store word left)
                    '0' when opcode = "101011" else -- sw
                    '0' when opcode = "101110" else -- swr (Store word right)
                 --'0' when opcode = "110001" else -- swc1 (Store word coprocessor 1 - for floating point)
                    '1' when opcode = "111000" else -- sc (Store conditional - FOR MULTIPROCESSORS & Atomics) --writes in rt if fails
                 --'0' when opcode = "111101" else -- sdc1 (Store double-word coprocessor 1 - for floating point)
                    --Data Movement Instructions
                    --Floating-Point Instructions                   
                    '0';
                    
                    
    Jump        <=  '0' when opcode = "000000" else -- R-type inst (add,addu,and,div,divu,mult,multu,nor,or,..)
                    --Arithmetic Instructions                      (sll,sllv,sra,srav,srl,srlv,sub,subu,xor,slt,sltu,jalr,jr)
                    '0' when opcode = "001000" else -- addi
                    '0' when opcode = "001001" else -- addiu
                    '0' when opcode = "001100" else -- andi
                    '0' when opcode = "011100" else -- clo/clz/mul/madd/maddu/msub/msuub
                    '0' when opcode = "001101" else -- ori
                    '0' when opcode = "001110" else -- xori
                    --Constant Manipulating Instructions
                    '0' when opcode = "001111" else -- lui (Load upper immediate)
                    --Comparison Instructions
                    '0' when opcode = "001010" else -- slti (Set less than immediate)
                    '0' when opcode = "001011" else -- sltiu (Set less than immediate unsigned)
                    --Branch Instructions                   
                    '0' when opcode = "000100" else -- beq (Branch on equal)
                    '0' when opcode = "000101" else -- bne (Branch on not equal)
                    '0' when opcode = "000110" else -- blez (Branch on less than equal zero)
                    '0' when opcode = "000111" else -- bgtz (Branch on greather than zero)                  
                    '0' when opcode = "000001" else -- bgez/bgezal/bltzal/bltz (Branch on ... and link)
                    --Jump Instructions
                    '1' when opcode = "000010" else -- j (jump)
                    '1' when opcode = "000011" else -- jal (jump and link)
                    --Load Instructions
                    '0' when opcode = "100000" else -- lb (Load Byte)
                    '0' when opcode = "100001" else -- lh (Load Half word)
                    '0' when opcode = "100010" else -- lwl (Load word left)
                    '0' when opcode = "100011" else -- lw
                    '0' when opcode = "100100" else -- lbu (Load Byte unsigned)
                    '0' when opcode = "100101" else -- lhu (Load Half word unsigned)
                    '0' when opcode = "100110" else -- lwr (Load word right)
                    '0' when opcode = "110000" else -- ll (Load Link -- FOR MULTIPROCESSORS & Atomics)
                 --'0' when opcode = "110001" else -- lwc1 (Load word coprocessor 1 - for floating point)
                    --Store Instructions
                    '0' when opcode = "101000" else -- sb (Store Byte)
                    '0' when opcode = "101001" else -- sh (Store Half word)
                    '0' when opcode = "101010" else -- swl (Store word left)
                    '0' when opcode = "101011" else -- sw
                    '0' when opcode = "101110" else -- swr (Store word right)
                 --'0' when opcode = "110001" else -- swc1 (Store word coprocessor 1 - for floating point)
                    '0' when opcode = "111000" else -- sc (Store conditional - FOR MULTIPROCESSORS & Atomics)
                 --'0' when opcode = "111101" else -- sdc1 (Store double-word coprocessor 1 - for floating point)
                    --Data Movement Instructions
                    --Floating-Point Instructions                   
                    '0';
    
    Branch  <=  '0' when opcode = "000000" else -- R-type inst (add,addu,and,div,divu,mult,multu,nor,or,..)
                    --Arithmetic Instructions                      (sll,sllv,sra,srav,srl,srlv,sub,subu,xor,slt,sltu,jalr,jr)
                    '0' when opcode = "001000" else -- addi
                    '0' when opcode = "001001" else -- addiu
                    '0' when opcode = "001100" else -- andi
                    '0' when opcode = "011100" else -- clo/clz/mul/madd/maddu/msub/msuub
                    '0' when opcode = "001101" else -- ori
                    '0' when opcode = "001110" else -- xori
                    --Constant Manipulating Instructions
                    '0' when opcode = "001111" else -- lui (Load upper immediate)
                    --Comparison Instructions
                    '0' when opcode = "001010" else -- slti (Set less than immediate)
                    '0' when opcode = "001011" else -- sltiu (Set less than immediate unsigned)
                    --Branch Instructions                   
                    '1' when opcode = "000100" else -- beq (Branch on equal)
                    '1' when opcode = "000101" else -- bne (Branch on not equal)
                    '1' when opcode = "000110" else -- blez (Branch on less than equal zero)
                    '1' when opcode = "000111" else -- bgtz (Branch on greather than zero)                  
                    '1' when opcode = "000001" else -- bgez/bgezal/bltzal/bltz (Branch on ... and link)
                    --Jump Instructions
                    '0' when opcode = "000010" else -- j (jump)
                    '0' when opcode = "000011" else -- jal (jump and link)
                    --Load Instructions
                    '0' when opcode = "100000" else -- lb (Load Byte)
                    '0' when opcode = "100001" else -- lh (Load Half word)
                    '0' when opcode = "100010" else -- lwl (Load word left)
                    '0' when opcode = "100011" else -- lw
                    '0' when opcode = "100100" else -- lbu (Load Byte unsigned)
                    '0' when opcode = "100101" else -- lhu (Load Half word unsigned)
                    '0' when opcode = "100110" else -- lwr (Load word right)
                    '0' when opcode = "110000" else -- ll (Load Link -- FOR MULTIPROCESSORS & Atomics)
                 --'0' when opcode = "110001" else -- lwc1 (Load word coprocessor 1 - for floating point)
                    --Store Instructions
                    '0' when opcode = "101000" else -- sb (Store Byte)
                    '0' when opcode = "101001" else -- sh (Store Half word)
                    '0' when opcode = "101010" else -- swl (Store word left)
                    '0' when opcode = "101011" else -- sw
                    '0' when opcode = "101110" else -- swr (Store word right)
                 --'0' when opcode = "110001" else -- swc1 (Store word coprocessor 1 - for floating point)
                    '0' when opcode = "111000" else -- sc (Store conditional - FOR MULTIPROCESSORS & Atomics)
                 --'0' when opcode = "111101" else -- sdc1 (Store double-word coprocessor 1 - for floating point)
                    --Data Movement Instructions
                    --Floating-Point Instructions                   
                    '0';
    
    MemRead <=  '0' when opcode = "000000" else -- R-type inst (add,addu,and,div,divu,mult,multu,nor,or,..)
                    --Arithmetic Instructions                      (sll,sllv,sra,srav,srl,srlv,sub,subu,xor,slt,sltu,jalr,jr)
                    '0' when opcode = "001000" else -- addi
                    '0' when opcode = "001001" else -- addiu
                    '0' when opcode = "001100" else -- andi
                    '0' when opcode = "011100" else -- clo/clz/mul/madd/maddu/msub/msuub
                    '0' when opcode = "001101" else -- ori
                    '0' when opcode = "001110" else -- xori
                    --Constant Manipulating Instructions
                    '0' when opcode = "001111" else -- lui (Load upper immediate)
                    --Comparison Instructions
                    '0' when opcode = "001010" else -- slti (Set less than immediate)
                    '0' when opcode = "001011" else -- sltiu (Set less than immediate unsigned)
                    --Branch Instructions                   
                    '0' when opcode = "000100" else -- beq (Branch on equal)
                    '0' when opcode = "000101" else -- bne (Branch on not equal)
                    '0' when opcode = "000110" else -- blez (Branch on less than equal zero)
                    '0' when opcode = "000111" else -- bgtz (Branch on greather than zero)                  
                    '0' when opcode = "000001" else -- bgez/bgezal/bltzal/bltz (Branch on ... and link)
                    --Jump Instructions
                    '0' when opcode = "000010" else -- j (jump)
                    '0' when opcode = "000011" else -- jal (jump and link)
                    --Load Instructions
                    '1' when opcode = "100000" else -- lb (Load Byte)
                    '1' when opcode = "100001" else -- lh (Load Half word)
                    '1' when opcode = "100010" else -- lwl (Load word left)
                    '1' when opcode = "100011" else -- lw
                    '1' when opcode = "100100" else -- lbu (Load Byte unsigned)
                    '1' when opcode = "100101" else -- lhu (Load Half word unsigned)
                    '1' when opcode = "100110" else -- lwr (Load word right)
                    '1' when opcode = "110000" else -- ll (Load Link -- FOR MULTIPROCESSORS & Atomics)
                 --'1' when opcode = "110001" else -- lwc1 (Load word coprocessor 1 - for floating point)
                    --Store Instructions
                    '0' when opcode = "101000" else -- sb (Store Byte)
                    '0' when opcode = "101001" else -- sh (Store Half word)
                    '0' when opcode = "101010" else -- swl (Store word left)
                    '0' when opcode = "101011" else -- sw
                    '0' when opcode = "101110" else -- swr (Store word right)
                 --'0' when opcode = "110001" else -- swc1 (Store word coprocessor 1 - for floating point)
                    '0' when opcode = "111000" else -- sc (Store conditional - FOR MULTIPROCESSORS & Atomics)
                 --'0' when opcode = "111101" else -- sdc1 (Store double-word coprocessor 1 - for floating point)
                    --Data Movement Instructions
                    --Floating-Point Instructions                   
                    '0';
    
    MemWrite    <=  '0' when opcode = "000000" else -- R-type inst (add,addu,and,div,divu,mult,multu,nor,or,..)
                    --Arithmetic Instructions                      (sll,sllv,sra,srav,srl,srlv,sub,subu,xor,slt,sltu,jalr,jr)
                    '0' when opcode = "001000" else -- addi
                    '0' when opcode = "001001" else -- addiu
                    '0' when opcode = "001100" else -- andi
                    '0' when opcode = "011100" else -- clo/clz/mul/madd/maddu/msub/msuub
                    '0' when opcode = "001101" else -- ori
                    '0' when opcode = "001110" else -- xori
                    --Constant Manipulating Instructions
                    '0' when opcode = "001111" else -- lui (Load upper immediate)
                    --Comparison Instructions
                    '0' when opcode = "001010" else -- slti (Set less than immediate)
                    '0' when opcode = "001011" else -- sltiu (Set less than immediate unsigned)
                    --Branch Instructions                   
                    '0' when opcode = "000100" else -- beq (Branch on equal)
                    '0' when opcode = "000101" else -- bne (Branch on not equal)
                    '0' when opcode = "000110" else -- blez (Branch on less than equal zero)
                    '0' when opcode = "000111" else -- bgtz (Branch on greather than zero)                  
                    '0' when opcode = "000001" else -- bgez/bgezal/bltzal/bltz (Branch on ... and link)
                    --Jump Instructions
                    '0' when opcode = "000010" else -- j (jump)
                    '0' when opcode = "000011" else -- jal (jump and link)
                    --Load Instructions
                    '0' when opcode = "100000" else -- lb (Load Byte)
                    '0' when opcode = "100001" else -- lh (Load Half word)
                    '0' when opcode = "100010" else -- lwl (Load word left)
                    '0' when opcode = "100011" else -- lw
                    '0' when opcode = "100100" else -- lbu (Load Byte unsigned)
                    '0' when opcode = "100101" else -- lhu (Load Half word unsigned)
                    '0' when opcode = "100110" else -- lwr (Load word right)
                    '0' when opcode = "110000" else -- ll (Load Link -- FOR MULTIPROCESSORS & Atomics)
                 --'0' when opcode = "110001" else -- lwc1 (Load word coprocessor 1 - for floating point)
                    --Store Instructions
                    '1' when opcode = "101000" else -- sb (Store Byte)
                    '1' when opcode = "101001" else -- sh (Store Half word)
                    '1' when opcode = "101010" else -- swl (Store word left)
                    '1' when opcode = "101011" else -- sw
                    '1' when opcode = "101110" else -- swr (Store word right)
                 --'1' when opcode = "110001" else -- swc1 (Store word coprocessor 1 - for floating point)
                    '1' when opcode = "111000" else -- sc (Store conditional - FOR MULTIPROCESSORS & Atomics)
                 --'1' when opcode = "111101" else -- sdc1 (Store double-word coprocessor 1 - for floating point)
                    --Data Movement Instructions
                    --Floating-Point Instructions                   
                    '0';
                    
    ByteAddress <= '1' when opcode = "100000" else -- lb (Load Byte)
                    '0' when opcode = "100001" else -- lh (Load Half word)
                    '0' when opcode = "100010" else -- lwl (Load word left)
                    '0' when opcode = "100011" else -- lw
                    '1' when opcode = "100100" else -- lbu (Load Byte unsigned)
                    '0' when opcode = "100101" else -- lhu (Load Half word unsigned)
                    '0' when opcode = "100110" else -- lwr (Load word right)
                    '0' when opcode = "110000" else -- ll (Load Link -- FOR MULTIPROCESSORS & Atomics)
                 --'0' when opcode = "110001" else -- lwc1 (Load word coprocessor 1 - for floating point)
                    --Store Instructions
                    '1' when opcode = "101000" else -- sb (Store Byte)
                    '0' when opcode = "101001" else -- sh (Store Half word)
                    '0' when opcode = "101010" else -- swl (Store word left)
                    '0' when opcode = "101011" else -- sw
                    '0' when opcode = "101110" else -- swr (Store word right)
                 --'0' when opcode = "110001" else -- swc1 (Store word coprocessor 1 - for floating point)
                    '0' when opcode = "111000" else -- sc (Store conditional - FOR MULTIPROCESSORS & Atomics)
                 --'0' when opcode = "111101" else -- sdc1 (Store double-word coprocessor 1 - for floating point)
                    '0';
                        
    WordAddress <= '0' when opcode = "100000" else -- lb (Load Byte)
                    '0' when opcode = "100001" else -- lh (Load Half word)
                    '1' when opcode = "100010" else -- lwl (Load word left)
                    '1' when opcode = "100011" else -- lw
                    '0' when opcode = "100100" else -- lbu (Load Byte unsigned)
                    '0' when opcode = "100101" else -- lhu (Load Half word unsigned)
                    '1' when opcode = "100110" else -- lwr (Load word right)
                    '1' when opcode = "110000" else -- ll (Load Link -- FOR MULTIPROCESSORS & Atomics)
                 --'1' when opcode = "110001" else -- lwc1 (Load word coprocessor 1 - for floating point)
                    --Store Instructions
                    '0' when opcode = "101000" else -- sb (Store Byte)
                    '0' when opcode = "101001" else -- sh (Store Half word)
                    '1' when opcode = "101010" else -- swl (Store word left)
                    '1' when opcode = "101011" else -- sw
                    '1' when opcode = "101110" else -- swr (Store word right)
                 --'1' when opcode = "110001" else -- swc1 (Store word coprocessor 1 - for floating point)
                    '1' when opcode = "111000" else -- sc (Store conditional - FOR MULTIPROCESSORS & Atomics)
                 --'1' when opcode = "111101" else -- sdc1 (Store double-word coprocessor 1 - for floating point)
                    '1';
                        
    MemtoReg <= '0' when opcode = "000000" else -- R-type inst (add,addu,and,div,divu,mult,multu,nor,or,..)
                    --Arithmetic Instructions                      (sll,sllv,sra,srav,srl,srlv,sub,subu,xor,slt,sltu,jalr,jr)
                    '0' when opcode = "001000" else -- addi
                    '0' when opcode = "001001" else -- addiu
                    '0' when opcode = "001100" else -- andi
                    '0' when opcode = "011100" else -- clo/clz/mul/madd/maddu/msub/msuub
                    '0' when opcode = "001101" else -- ori
                    '0' when opcode = "001110" else -- xori
                    --Constant Manipulating Instructions
                    '0' when opcode = "001111" else -- lui (Load upper immediate)
                    --Comparison Instructions
                    '0' when opcode = "001010" else -- slti (Set less than immediate)
                    '0' when opcode = "001011" else -- sltiu (Set less than immediate unsigned)
                    --Branch Instructions                   
                    '-' when opcode = "000100" else -- beq (Branch on equal)
                    '-' when opcode = "000101" else -- bne (Branch on not equal)
                    '-' when opcode = "000110" else -- blez (Branch on less than equal zero)
                    '-' when opcode = "000111" else -- bgtz (Branch on greather than zero)                  
                    '-' when opcode = "000001" else -- bgez/bgezal/bltzal/bltz (Branch on ... and link)
                    --Jump Instructions
                    '-' when opcode = "000010" else -- j (jump)
                    '-' when opcode = "000011" else -- jal (jump and link)
                    --Load Instructions
                    '1' when opcode = "100000" else -- lb (Load Byte)
                    '1' when opcode = "100001" else -- lh (Load Half word)
                    '1' when opcode = "100010" else -- lwl (Load word left)
                    '1' when opcode = "100011" else -- lw
                    '1' when opcode = "100100" else -- lbu (Load Byte unsigned)
                    '1' when opcode = "100101" else -- lhu (Load Half word unsigned)
                    '1' when opcode = "100110" else -- lwr (Load word right)
                    '1' when opcode = "110000" else -- ll (Load Link -- FOR MULTIPROCESSORS & Atomics)
                 --'1' when opcode = "110001" else -- lwc1 (Load word coprocessor 1 - for floating point)
                    --Store Instructions
                    '-' when opcode = "101000" else -- sb (Store Byte)
                    '-' when opcode = "101001" else -- sh (Store Half word)
                    '-' when opcode = "101010" else -- swl (Store word left)
                    '-' when opcode = "101011" else -- sw
                    '-' when opcode = "101110" else -- swr (Store word right)
                 --'-' when opcode = "110001" else -- swc1 (Store word coprocessor 1 - for floating point)
                    '-' when opcode = "111000" else -- sc (Store conditional - FOR MULTIPROCESSORS & Atomics)
                 --'-' when opcode = "111101" else -- sdc1 (Store double-word coprocessor 1 - for floating point)
                    --Data Movement Instructions
                    --Floating-Point Instructions                   
                    '0';
                    
                    
    RegDst  <=  '1' when opcode = "000000" else -- R-type inst (add,addu,and,div,divu,mult,multu,nor,or,..)
                    --Arithmetic Instructions                      (sll,sllv,sra,srav,srl,srlv,sub,subu,xor,slt,sltu,jalr,jr)
                    '0' when opcode = "001000" else -- addi
                    '0' when opcode = "001001" else -- addiu
                    '0' when opcode = "001100" else -- andi
                    '0' when opcode = "011100" else -- clo/clz/mul/madd/maddu/msub/msuub
                    '0' when opcode = "001101" else -- ori
                    '0' when opcode = "001110" else -- xori
                    --Constant Manipulating Instructions
                    '0' when opcode = "001111" else -- lui (Load upper immediate)
                    --Comparison Instructions
                    '0' when opcode = "001010" else -- slti (Set less than immediate)
                    '0' when opcode = "001011" else -- sltiu (Set less than immediate unsigned)
                    --Branch Instructions                   
                    '-' when opcode = "000100" else -- beq (Branch on equal)
                    '-' when opcode = "000101" else -- bne (Branch on not equal)
                    '-' when opcode = "000110" else -- blez (Branch on less than equal zero)
                    '-' when opcode = "000111" else -- bgtz (Branch on greather than zero)                  
                    '-' when opcode = "000001" else -- bgez/bgezal/bltzal/bltz (Branch on ... and link)
                    --Jump Instructions
                    '-' when opcode = "000010" else -- j (jump)
                    '-' when opcode = "000011" else -- jal (jump and link)
                    --Load Instructions
                    '0' when opcode = "100000" else -- lb (Load Byte)
                    '0' when opcode = "100001" else -- lh (Load Half word)
                    '0' when opcode = "100010" else -- lwl (Load word left)
                    '0' when opcode = "100011" else -- lw
                    '0' when opcode = "100100" else -- lbu (Load Byte unsigned)
                    '0' when opcode = "100101" else -- lhu (Load Half word unsigned)
                    '0' when opcode = "100110" else -- lwr (Load word right)
                    '0' when opcode = "110000" else -- ll (Load Link -- FOR MULTIPROCESSORS & Atomics)
                 --'0' when opcode = "110001" else -- lwc1 (Load word coprocessor 1 - for floating point)
                    --Store Instructions
                    '-' when opcode = "101000" else -- sb (Store Byte)
                    '-' when opcode = "101001" else -- sh (Store Half word)
                    '-' when opcode = "101010" else -- swl (Store word left)
                    '-' when opcode = "101011" else -- sw
                    '-' when opcode = "101110" else -- swr (Store word right)
                 --'-' when opcode = "110001" else -- swc1 (Store word coprocessor 1 - for floating point)
                    '-' when opcode = "111000" else -- sc (Store conditional - FOR MULTIPROCESSORS & Atomics)
                 --'-' when opcode = "111101" else -- sdc1 (Store double-word coprocessor 1 - for floating point)
                    --Data Movement Instructions
                    --Floating-Point Instructions                   
                    '1';
                    
                    --ARREGLAR LA ALU PER INSTRUCCIONS AMB INMEDIAT!
    ALUOp       <=  "010" when opcode = "000000" else -- R-type inst (add,addu,and,div,divu,mult,multu,nor,or,..)
                    --Arithmetic Instructions                      (sll,sllv,sra,srav,srl,srlv,sub,subu,xor,slt,sltu,jalr,jr)
                    "100" when opcode = "001000" else -- addi
                    "100" when opcode = "001001" else -- addiu
                    "100" when opcode = "001100" else -- andi
                    "---" when opcode = "011100" else -- clo/clz/mul/madd/maddu/msub/msuub
                    "100" when opcode = "001101" else -- ori
                    "100" when opcode = "001110" else -- xori
                    --Constant Manipulating Instructions
                    "000" when opcode = "001111" else -- lui (Load upper immediate)
                    --Comparison Instructions
                    "100" when opcode = "001010" else -- slti (Set less than immediate)
                    "100" when opcode = "001011" else -- sltiu (Set less than immediate unsigned)
                    --Branch Instructions                   
                    "001" when opcode = "000100" else -- beq (Branch on equal)
                    "001" when opcode = "000101" else -- bne (Branch on not equal)
                    "001" when opcode = "000110" else -- blez (Branch on less than equal zero)
                    "001" when opcode = "000111" else -- bgtz (Branch on greather than zero)                    
                    "001" when opcode = "000001" else -- bgez/bgezal/bltzal/bltz (Branch on ... and link)
                    --Jump Instructions
                    "000" when opcode = "000010" else -- j (jump)
                    "000" when opcode = "000011" else -- jal (jump and link)
                    --Load Instructions
                    "000" when opcode = "100000" else -- lb (Load Byte)
                    "000" when opcode = "100001" else -- lh (Load Half word)
                    "000" when opcode = "100010" else -- lwl (Load word left)
                    "000" when opcode = "100011" else -- lw
                    "000" when opcode = "100100" else -- lbu (Load Byte unsigned)
                    "000" when opcode = "100101" else -- lhu (Load Half word unsigned)
                    "000" when opcode = "100110" else -- lwr (Load word right)
                    "000" when opcode = "110000" else -- ll (Load Link -- FOR MULTIPROCESSORS & Atomics)
                 --"00" when opcode = "110001" else -- lwc1 (Load word coprocessor 1 - for floating point)
                    --Store Instructions
                    "000" when opcode = "101000" else -- sb (Store Byte)
                    "000" when opcode = "101001" else -- sh (Store Half word)
                    "000" when opcode = "101010" else -- swl (Store word left)
                    "000" when opcode = "101011" else -- sw
                    "000" when opcode = "101110" else -- swr (Store word right)
                 --"000" when opcode = "110001" else -- swc1 (Store word coprocessor 1 - for floating point)
                    "000" when opcode = "111000" else -- sc (Store conditional - FOR MULTIPROCESSORS & Atomics)
                 --"000" when opcode = "111101" else -- sdc1 (Store double-word coprocessor 1 - for floating point)
                    --Data Movement Instructions
                    --Floating-Point Instructions           
                    "XXX";
                    
                    
                    
    ALUSrc  <=  '0' when opcode = "000000" else -- R-type inst (add,addu,and,div,divu,mult,multu,nor,or,..)
                    --Arithmetic Instructions                      (sll,sllv,sra,srav,srl,srlv,sub,subu,xor,slt,sltu,jalr,jr)
                    '1' when opcode = "001000" else -- addi
                    '1' when opcode = "001001" else -- addiu
                    '1' when opcode = "001100" else -- andi
                    '0' when opcode = "011100" else -- clo/clz/mul/madd/maddu/msub/msuub
                    '1' when opcode = "001101" else -- ori
                    '1' when opcode = "001110" else -- xori
                    --Constant Manipulating Instructions
                    '1' when opcode = "001111" else -- lui (Load upper immediate)
                    --Comparison Instructions
                    '1' when opcode = "001010" else -- slti (Set less than immediate)
                    '1' when opcode = "001011" else -- sltiu (Set less than immediate unsigned)
                    --Branch Instructions                   
                    '0' when opcode = "000100" else -- beq (Branch on equal)
                    '0' when opcode = "000101" else -- bne (Branch on not equal)
                    '-' when opcode = "000110" else -- blez (Branch on less than equal zero)
                    '-' when opcode = "000111" else -- bgtz (Branch on greather than zero)                  
                    '-' when opcode = "000001" else -- bgez/bgezal/bltzal/bltz (Branch on ... and link)
                    --Jump Instructions
                    '-' when opcode = "000010" else -- j (jump)
                    '-' when opcode = "000011" else -- jal (jump and link)
                    --Load Instructions
                    '1' when opcode = "100000" else -- lb (Load Byte)
                    '1' when opcode = "100001" else -- lh (Load Half word)
                    '1' when opcode = "100010" else -- lwl (Load word left)
                    '1' when opcode = "100011" else -- lw
                    '1' when opcode = "100100" else -- lbu (Load Byte unsigned)
                    '1' when opcode = "100101" else -- lhu (Load Half word unsigned)
                    '1' when opcode = "100110" else -- lwr (Load word right)
                    '1' when opcode = "110000" else -- ll (Load Link -- FOR MULTIPROCESSORS & Atomics)
                 --'1' when opcode = "110001" else -- lwc1 (Load word coprocessor 1 - for floating point)
                    --Store Instructions
                    '1' when opcode = "101000" else -- sb (Store Byte)
                    '1' when opcode = "101001" else -- sh (Store Half word)
                    '1' when opcode = "101010" else -- swl (Store word left)
                    '1' when opcode = "101011" else -- sw
                    '1' when opcode = "101110" else -- swr (Store word right)
                 --'1' when opcode = "110001" else -- swc1 (Store word coprocessor 1 - for floating point)
                    '1' when opcode = "111000" else -- sc (Store conditional - FOR MULTIPROCESSORS & Atomics)
                 --'1' when opcode = "111101" else -- sdc1 (Store double-word coprocessor 1 - for floating point)
                    --Data Movement Instructions
                    --Floating-Point Instructions                   
                    '0';
    
end Structure;
