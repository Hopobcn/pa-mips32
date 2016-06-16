library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ALU implementation from Patterson/Hennesy 5th ed. Appendix B. p B-27 to B-37.

entity alu_1bit_adder is
	port(	a			:	in std_logic;
			b			:	in std_logic;
			carryIn	:	in	std_logic;
			res		:	out std_logic;
			carryOut	:	out std_logic);
			
end alu_1bit_adder;

architecture Structure of alu_1bit_adder is
	
	
begin
	res	<= (a and not(b) and not(carryIn)) or (not(a) and b and not(carryIn)) or (not(a) and not(b) and carryIn) or (a and b and carryIn);
	
	carryOut	<= (b and CarryIn) or (a and CarryIn) or (a and b);
	
end Structure;