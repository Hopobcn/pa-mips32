library ieee;
use ieee.std_logic_1164.all;

--conflicting names between 1.IF/mux and 3.EXE/mux !
entity mux_exe is
	port (a	:	in	std_logic_vector(31 downto 0);
			b	:	in std_logic_vector(31 downto 0);
			c	:	out std_logic_vector(31 downto 0);
			s	:	in	std_logic);
end mux_exe;

architecture Structure of mux_exe is

begin

	c <= a when s = '0' else
		  b;
		  
end Structure;