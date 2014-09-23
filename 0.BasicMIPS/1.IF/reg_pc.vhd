library ieee;
use ieee.std_logic_1164.all;

entity reg_pc is
	port (clk	:	in	std_logic;
			pc_up	:	in	std_logic_vector(31 downto 0);
			pc 	:	out std_logic_vector(31 downto 0));
end reg_pc;

architecture Structure of reg_pc is
	signal pc_tmp		: std_logic_vector(31 downto 0);
begin
	pc <= pc_tmp;
	
	process(clk, pc_tmp)
	begin
		if (clk'event and clk = '1') then
			pc_tmp <= pc_up;
		else
			pc_tmp <= pc_tmp;
		end if;
	end process;
end Structure;