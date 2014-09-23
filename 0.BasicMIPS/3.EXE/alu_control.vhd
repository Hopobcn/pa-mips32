library ieee;
use ieee.std_logic_1164.all;

entity alu_control is
	port (-- buses
			input 	: in std_logic_vector(5 downto 0);	-- function bits
			-- control signals
			ALUOp_in : in std_logic_vector(1 downto 0);							
			ALUOp_out: out std_logic_vector(3 downto 0));

end alu_control;
	
	
architecture Structure of alu_control is

begin
	--See p260 pattern-henesy
	
	ALUOp_out <=	"0010" when ALUOp_in = "00" and input = "XXXXXX" else	--LW or SW (add)
						"0110" when ALUOp_in = "01" and input = "XXXXXX" else --Branch equal (sub)
						"0010" when ALUOp_in = "1X" and input = "XX0000" else -- add
						"0110" when ALUOp_in = "1X" and input = "XX0010" else -- sub
						"0000" when ALUOp_in = "1X" and input = "XX0100" else -- and
						"0001" when ALUOp_in = "1X" and input = "XX0101" else -- or
						"0111" when ALUOp_in = "1X" and input = "XX1010" else -- set on les than
						"XXXX";
						
								
			
	
end Structure;
