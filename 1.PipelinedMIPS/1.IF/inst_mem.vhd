library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; --Not an standard library-don't use
use ieee.numeric_std.all;
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
	type INST_MEM is array (2 ** 8 - 1 downto 0) of std_logic_vector(7 downto 0);
	signal mem : INST_MEM;
	
	--	FIX THIS
	procedure Load_File_DataMem(signal memory : inout INST_MEM) is
		file 		romfile	:text open read_mode is "contingut.memoria.hexa.rom";
		variable	lbuf		:line;
		variable i			:integer := 0; -- x"C000" adreca inicial
		variable	byte0		:std_logic_vector(7 downto 0);
		variable	byte1		:std_logic_vector(7 downto 0);
		variable	byte2		:std_logic_vector(7 downto 0);
		variable	byte3		:std_logic_vector(7 downto 0);
	begin
		while i < 2**8-1 loop --not endfile(romfile) loop
			readline(romfile, lbuf);
			hread(lbuf, byte0);
			hread(lbuf, byte1);
			hread(lbuf, byte2);
			hread(lbuf, byte3);			
			-- Big Endian
			--memory(i  ) <= byte0;	
			--memory(i+1) <= byte1;	
			--memory(i+2) <= byte2;	
			--memory(i+3) <= byte3;
			-- Little Endian			
			memory(i  ) <= byte3;	
			memory(i+1) <= byte2;	
			memory(i+2) <= byte1;	
			memory(i+3) <= byte0;
			i := i+4;
			exit when endfile(romfile);
		end loop;
	end procedure;
	
	signal addr1 : std_logic_vector(31 downto 0);
	signal addr2 : std_logic_vector(31 downto 0);
	signal addr3 : std_logic_vector(31 downto 0);
	
begin
	
	addr1 <= addr + x"01";
	addr2 <= addr + x"02";
	addr3 <= addr + x"03";
	
	-- In MIPS we write in the first semi-cycle and read in the second semi-cycle					
	instruction_mem_read	 : process(clk)
	begin
		if (falling_edge(clk)) then
			instruction <= mem(to_integer(unsigned(addr3))) & 
								mem(to_integer(unsigned(addr2))) &
								mem(to_integer(unsigned(addr1))) &
								mem(to_integer(unsigned(addr )));
		end if;
	end process instruction_mem_read;
						
						
	instruction_mem_write : process(clk)
	begin
		if (rising_edge(clk)) then
			if boot = '1' then
				-- Load the instructions from a file
				Load_File_DataMem(mem);
			end if;
		end if;
	end process instruction_mem_write;
	
	
end Structure;