library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ALU implementation from Patterson/Hennesy 5th ed. Appendix B. p B-27 to B-37.

entity alu_multiplier is
	port(	-- buses
			a			:	in std_logic_vector(31 downto 0);
			b			:	in std_logic_vector(31 downto 0);
			resHi		:	out std_logic_vector(31 downto 0);
			resLo		:	out std_logic_vector(31 downto 0);
			-- control signals
			Overflow	: 	out std_logic;
		 --CarryOut	: 	out std_logic;
			ALUOp		:	in	std_logic_vector(3 downto 0));
end alu_multiplier;

architecture Structure of alu_multiplier is

begin
	
end Structure;