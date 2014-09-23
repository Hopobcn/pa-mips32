library ieee;
use ieee.std_logic_1164.all;

entity control_inst_decode is
	port (-- buses
			opcode : 	in std_logic_vector(5 downto 0);
			-- control logic
			RegWrite		: 	out std_logic;
			Jump			:	out std_logic;
			Branch		:	out std_logic;
			MemRead		:	out std_logic;								
			MemWrite		:	out std_logic;
			MemtoReg		:	out std_logic;
			RegDst		:	out std_logic;	
			ALUOp			:	out std_logic_vector(1 downto 0);
			ALUSrc		:	out std_logic);
			
end control_inst_decode;

architecture Structure of control_inst_decode is

begin
	RegWrite <= '1' when opcode = "000000" else -- R-type inst
					'1' when opcode = "100011" else -- LW
					'0' when opcode = "101011" else -- SW
					'0' when opcode = "000100" else -- Branch equal
					'X';
					
	Jump		<=	'1' when opcode = "000010" else	-- Jump inst
					'0';
	
	Branch 	<=	'0' when opcode = "000000" else -- R-type inst
					'0' when opcode = "100011" else -- LW
					'0' when opcode = "101011" else -- SW
					'1' when opcode = "000100" else -- Branch equal
					'X';
	
	MemRead	<=	'0' when opcode = "000000" else -- R-type inst
					'1' when opcode = "100011" else -- LW
					'0' when opcode = "101011" else -- SW
					'0' when opcode = "000100" else -- Branch equal
					'X';
	
	MemWrite	<=	'0' when opcode = "000000" else -- R-type inst
					'0' when opcode = "100011" else -- LW
					'1' when opcode = "101011" else -- SW
					'0' when opcode = "000100" else -- Branch equal
					'X';
	
	MemtoReg <=	'0' when opcode = "000000" else -- R-type inst
					'1' when opcode = "100011" else -- LW
					'X' when opcode = "101011" else -- SW
					'X' when opcode = "000100" else -- Branch equal
					'X';
	
	RegDst	<=	'1' when opcode = "000000" else -- R-type inst
					'0' when opcode = "100011" else -- LW
					'X' when opcode = "101011" else -- SW
					'X' when opcode = "000100" else -- Branch equal
					'X';
	
	ALUOp		<=	"10" when opcode = "000000" else -- R-type inst
					"00" when opcode = "100011" else -- LW
					"00" when opcode = "101011" else -- SW
					"01" when opcode = "000100" else -- Branch equal
					"XX";
	
	ALUSrc	<=	'0' when opcode = "000000" else -- R-type inst
					'1' when opcode = "100011" else -- LW
					'1' when opcode = "101011" else -- SW
					'0' when opcode = "000100" else -- Branch equal
					'X';
	
end Structure;