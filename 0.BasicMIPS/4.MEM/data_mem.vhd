library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity data_mem is
	port (-- data buses
			addr			:	in std_logic_vector(31 downto 0);
			write_data	:	in std_logic_vector(31 downto 0);
			read_data	:	out std_logic_vector(31 downto 0);
			-- control signals
			clk			:	in std_logic;
			MemRead		:	in std_logic;
			MemWrite		:	in	std_logic);

end data_mem;

architecture Structure of data_mem is
	type DATA_MEM is array (31 downto 0) of std_logic_vector(31 downto 0);
	signal mem : DATA_MEM;
begin

	data_mem_read : process(clk)
	begin
		if (clk'event and clk = '1') then
			if (MemRead = '1') then
				read_data <= mem(conv_integer(addr));
			end if;
		end if;
	end process data_mem_read;
	
	data_mem_write : process(clk)
	begin
		if (clk'event and clk = '1') then
			if (MemWrite = '1') then
				mem(conv_integer(addr)) <= write_data;
			end if;
		end if;
	end process data_mem_write;
	
end Structure;
			