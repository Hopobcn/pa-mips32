library ieee;
use ieee.std_logic_1164.all;

entity mux is
	port (a	:	in	std_logic_vector(31 downto 0);
			b	:	in std_logic_vector(31 downto 0);
			c	:	out std_logic_vector(31 downto 0);
			s	:	in	std_logic);
end mux;

architecture Structure of mux is

begin 

	c <= a when s = '0' else
		  b;
end Structure;