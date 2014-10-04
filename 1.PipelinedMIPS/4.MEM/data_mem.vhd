library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_mem is
	port (-- data buses
			addr			:	in std_logic_vector(31 downto 0);
			write_data	:	in std_logic_vector(31 downto 0);
			read_data	:	out std_logic_vector(31 downto 0);
			-- control signals
			clk			:	in std_logic;
			MemRead		:	in std_logic;
			MemWrite		:	in	std_logic;
			ByteAddress :  in std_logic;
			WordAddress	:	in	std_logic);

end data_mem;

architecture Structure of data_mem is
	type DATA_MEM is array (2**8-1 downto 0) of std_logic_vector(7 downto 0);
	signal mem : DATA_MEM;
begin

	data_mem_read : process(clk)
	begin
		if (clk'event and clk = '1') then
			if (MemRead = '1') then
				if (ByteAddress = '1' and WordAddress = '0') then
					read_data(7 downto 0) 	<= mem(to_integer(unsigned(addr)));
					read_data(31 downto 8)	<=	x"000000";    -- LB should sign ext and LBU should put Zeros
				elsif (ByteAddress = '0' and WordAddress = '0') then
					read_data(7 downto 0) 	<= mem(to_integer(unsigned(addr)));
					read_data(15 downto 8) 	<= mem(to_integer(unsigned(addr)));
					read_data(31 downto 16)	<=	x"0000";
				else 
					read_data(7 downto 0) 	<= mem(to_integer(unsigned(addr)));
					read_data(15 downto 8) 	<= mem(to_integer(unsigned(addr)));
					read_data(23 downto 16) <= mem(to_integer(unsigned(addr)));
					read_data(31 downto 24) <= mem(to_integer(unsigned(addr)));
				end if;
			end if;
		end if;
	end process data_mem_read;
	
	data_mem_write : process(clk)
	begin
		if (clk'event and clk = '1') then
			if (MemWrite = '1') then
				if (ByteAddress = '1' and WordAddress = '0') then
					mem(to_integer(unsigned(addr      ))) <= write_data(7 downto 0);
				elsif (ByteAddress = '0' and WordAddress = '0') then
					mem(to_integer(unsigned(addr      ))) <= write_data(7 downto 0);
					mem(to_integer(unsigned(addr+x"01"))) <= write_data(15 downto 8);
				else
					mem(to_integer(unsigned(addr      ))) <= write_data(7 downto 0);
					mem(to_integer(unsigned(addr+x"01"))) <= write_data(15 downto 8);
					mem(to_integer(unsigned(addr+x"02"))) <= write_data(23 downto 16);
					mem(to_integer(unsigned(addr+x"03"))) <= write_data(31 downto 24);
				end if;
			end if;
		end if;
	end process data_mem_write;
	
end Structure;
			