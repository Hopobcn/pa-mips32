library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; --for conv_integer

use ieee.std_logic_textio.all;
use std.textio.all;


entity inst_mem is
	port (addr			:	in std_logic_vector(31 downto 0);
			instruction	:	out std_logic_vector(31 downto 0);
			-- control signal
			clk			:	in std_logic;
			boot			:	in std_logic);
end inst_mem;

architecture Structure of inst_mem is
	type INST_MEM is array (2 ** 16 downto 0) of std_logic_vector(31 downto 0);
	signal mem : INST_MEM;
	
	--	FIX THIS
	--procedure Load_File_DataMem(signal memory : inout INST_MEM) is
	--	file 		romfile	:text open read_mode is "contingut.memoria.hexa.rom";
	--	variable	lbuf		:line;
	--	variable i			:integer := 0; -- x"C000" adreça inicial
	--	variable	fdata		:std_logic_vector(31 downto 0);
	--begin
	--	while not endfile(romfile) loop
	--		readline(romfile, lbuf);
	--		hread(lbuf, fdata);
	--		memory(i) <= fdata;
	--		i:=i+1;
	--	end loop;
	--end procedure;
	
begin
	
	instruction_mem_read : process(clk)
	begin
		if (clk'event and clk = '1') then
			if boot = '1' then
				-- Load the instructions from a file
				--Load_File_DataMem(mem);
			end if;
			
			instruction <= mem(conv_integer(addr));
		end if;
	end process instruction_mem_read;
	
end Structure;