library ieee;
use ieee.std_logic_1164.all;

entity write_back is
	port (-- buses
			read_data		:	in std_logic_vector(31 downto 0);	--from MEM
			bypass_mem		:	in std_logic_vector(31 downto 0); 	--from MEM
			write_data		:	out std_logic_vector(31 downto 0);	--to IF
			addr_regw_in	:	in	std_logic_vector(4 downto 0);	--from MEM
			addr_regw_out	:	out std_logic_vector(4 downto 0);	--to IF
			-- control signals
			RegWrite_in		:	in std_logic;
			RegWrite_out	:	out std_logic;
			MemtoReg			:	in	std_logic);
			
end write_back;

architecture Structure of write_back is
	
begin
	addr_regw_out 	<=	addr_regw_in;
	
	RegWrite_out	<= Regwrite_in;
	
		
	write_data <= bypass_mem when MemtoReg = '0' else
	              read_data;
		
end Structure;