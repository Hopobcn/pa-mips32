library ieee;
use ieee.std_logic_1164.all;

entity alu_control is
	port (-- buses
			opcode		: in std_logic_vector(5 downto 0);
			funct 		: in std_logic_vector(5 downto 0);	-- function bits
			-- control signals
			ALUOp_in 	: in std_logic_vector(2 downto 0);							
			ALUOp_out	: out std_logic_vector(3 downto 0);
			SignedSrc 	: out std_logic;
			ShiftSrc		: out std_logic);

end alu_control;
	
	
architecture Structure of alu_control is

begin
	--See p260 pattern-henesy & p.119
					
	-- "0000" and | andi 
	-- "0001" or  | ori
	-- "0010" add | addi | addiu
	-- "0011" sll
	-- "0100" srl
	-- "0101" sra
	-- "0110" sub
	-- "0111" slt | slti | sltiu
	-- "1000" 
	-- "1001"   
	-- "1010" mult
	-- "1011" div
	-- "1100" nor
	-- "1101"
	-- "1110" 
	-- "1111" xor | xori
	
	ALUOp_out <=	"0010" when ALUOp_in	= "000" 							 	else	--LW or SW or ADDI 	(add) 			[core]
						"0110" when ALUOp_in	= "001" 							 	else --Branch equal 			(sub)				[core]
						"0011" when ALUOp_in = "010" and funct = "000000"	else -- sll 					(shift left)	[shifter]
						"0100" when ALUOp_in = "010" and funct = "000010"	else -- srl						(shift right l)[shifter]
						"0101" when ALUOp_in = "010" and funct = "000011"	else -- sra						(shift right a)[shifter]
						"1010" when ALUOp_in = "010" and funct = "011000"	else -- mult					(mult)			[multiplier]
						"1011" when ALUOp_in = "010" and funct = "011010"	else -- div						(div)				[multiplier]
						"0010" when ALUOp_in = "010" and funct = "100000"	else -- add											[core]
						"0010" when ALUOp_in = "010" and funct = "100001"	else -- addu										[core]
						"0110" when ALUOp_in = "010" and funct = "100010" 	else -- sub											[core]
						"0110" when ALUOp_in = "010" and funct = "100011" 	else -- subu										[core]
						"0000" when ALUOp_in = "010" and funct = "100100" 	else -- and											[core]
						"0001" when ALUOp_in = "010" and funct = "100101" 	else -- or											[core]
						"1111" when ALUOp_in = "010" and funct = "100110" 	else -- xor											[core]
						"1100" when ALUOp_in = "010" and funct = "100111" 	else -- nor											[core]
						"0111" when ALUOp_in = "010" and funct = "101010" 	else -- slt											[core]
						"0111" when ALUOp_in = "010" and funct = "101011" 	else -- sltu										[core]
						"0010" when ALUOp_in = "100" and opcode = "001000" else --Immediate Inst		(addi)			[core]
						"0010" when ALUOp_in = "100" and opcode = "001001" else --Immediate Inst		(addiu)			[core]
						"0000" when ALUOp_in	= "100" and opcode = "001100"	else --Immediate Inst 		(andi)			[core]
						"0001" when ALUOp_in	= "100" and opcode = "001101"	else --Immediate Inst 		(ori)				[core]
						"1111" when ALUOp_in	= "100" and opcode = "001110"	else --Immediate Inst 		(xori)			[core]
						"0111" when ALUOp_in = "100" and opcode = "001010" else -- slti (Set less than immediate)		[core]
						"0111" when ALUOp_in = "100" and opcode = "001011" else -- sltiu (Set less than imm unsigned)[core]
						"XXXX";								
			
	SignedSrc <=	'0' when ((opcode = "000000" and funct = "100001") or --addu
									 (opcode = "000000" and funct = "100011") or --subu
									 (opcode = "000000" and funct = "101011") or --sltu
									 opcode = "001001"  or --addiu
									 opcode = "001011"  or --sltiu
									 opcode = "100100"  or --lbu
									 opcode = "100101") else  --lhu
						'1';
						
	
	ShiftSrc 	<=	'1' when (opcode = "000000" and funct(5 downto 3) = "000") else --sll, lrl, sra, sllv, srlv, srav
						'0';
	
	
end Structure;
