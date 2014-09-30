library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_shifter is
	port(	-- buses
			a			:	in std_logic_vector(31 downto 0);
			shamt		:	in std_logic_vector(31 downto 0);
			res		:	out std_logic_vector(31 downto 0);
			-- control signals
			ALUOp		:	in	std_logic_vector(3 downto 0));
end alu_shifter;

architecture Structure of alu_shifter is

begin

	res <= a;
	-- COMPLETAR
end Structure;