library ieee;
use ieee.std_logic_1164.all;

entity alu_control is
	port (-- buses
			opcode		: in std_logic_vector(5 downto 0);
			funct 		: in std_logic_vector(5 downto 0);	-- function bits
			-- control signals
			ALUOp_in 	: in std_logic_vector(2 downto 0);							
			ALUOp_out	: out std_logic_vector(3 downto 0);
			UnsignedSrc : out std_logic;
			ShiftSrc		: out std_logic);

end alu_control;
	
	
architecture Structure of alu_control is

begin
	--See p260 pattern-henesy & p.119
					
	-- "0000" and | sll | mult
	-- "0001" or  | srl | div
	-- "0010" add | sra
	-- "0110" sub
	-- "0111" slt
	-- "1100" nor
	-- "1111" xor
	
	ALUOp_out <=	"0010" when ALUOp_in	= "000" 							 	else	--LW or SW or ADDI 	(add) 			[core]
						"0110" when ALUOp_in	= "001" 							 	else --Branch equal 			(sub)				[core]
						"0000" when ALUOp_in = "010" and funct = "000000"	else -- sll 					(shift left)	[shifter]
						"0001" when ALUOp_in = "010" and funct = "000010"	else -- srl						(shift right l)[shifter]
						"0010" when ALUOp_in = "010" and funct = "000011"	else -- sra						(shift right a)[shifter]
						"0010" when ALUOp_in = "010" and funct = "011000"	else -- mult					(mult)			[multiplier]
						"0010" when ALUOp_in = "010" and funct = "011010"	else -- div						(div)				[multiplier]
						"0010" when ALUOp_in = "010" and funct = "100000"	else -- add											[core]
						"0110" when ALUOp_in = "010" and funct = "100010" 	else -- sub											[core]
						"0000" when ALUOp_in = "010" and funct = "100100" 	else -- and											[core]
						"0001" when ALUOp_in = "010" and funct = "100101" 	else -- or											[core]
						"1111" when ALUOp_in = "010" and funct = "100110" 	else -- xor											[core]
						"1100" when ALUOp_in = "010" and funct = "100111" 	else -- nor											[core]
						"0111" when ALUOp_in = "010" and funct = "101010" 	else -- set on les than							[core]
						"0000" when ALUOp_in	= "100" 							 	else --Immediate Inst 		(andi)			[core]
						"0001" when ALUOp_in	= "101" 							 	else --Immediate Inst 		(ori)				[core]
						"1111" when ALUOp_in	= "110" 							 	else --Immediate Inst 		(xori)			[core]
						"XXXX";								
			
	UnsignedSrc <= '1' when (opcode = "001001"  or --addiu
									 opcode = "001011"  or --sltiu
									 opcode = "100100"  or --lbu
									 opcode = "100101") else  --lhu
						'0';
						
	
	ShiftSrc 	<=	'1' when (opcode = "000000" and funct(5 downto 3) = "000") else --sll, lrl, sra, sllv, srlv, srav
						'0';
	
	
end Structure;
