library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ALU implementation from Patterson/Hennesy 5th ed. Appendix B. p B-27 to B-37.

entity alu_1bit_overflow_detection is
	port(	a			:	in std_logic;
			b			:	in std_logic;
			carryOut	:	in	std_logic;
			res		:	in std_logic;
			overflow	:	out std_logic;
			Binvert	:	in	std_logic);
			
end alu_1bit_overflow_detection;

architecture Structure of alu_1bit_overflow_detection is
	signal part1	: std_logic;
	signal part2	: std_logic;
begin
	-- https://www.uclm.es/profesorado/licesio/Docencia/ETC/22_ConstruccionUAL.pdf
	part1		<= not(Binvert) and ((not(a) and not(b) and res) or (a and 		b  and not(res)));
	part2		<=  	 Binvert  and ((not(a) and     b  and res) or (a and not(b) and not(res)));
	
	overflow	<= part1 or part2;
	
end Structure;




