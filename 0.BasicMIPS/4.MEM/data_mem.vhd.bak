Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity regfile is
	port (clk		:	in std_logic;
			addr_rs	:	in std_logic_vector(4 downto 0);
			addr_rt	:	in	std_logic_vector(4 downto 0);
			addr_rd	:	in	std_logic_vector(4 downto 0);
			rs			:	out std_logic_vector(31 downto 0);
			rt			: 	out std_logic_vector(31 downto 0);
			rd			:	in	std_logic_vector(31 downto 0);
			RegWrite	:	in	std_logic); --write permit
end regfile;

architecture Structure of regfile is
	type REGISTER_BLOCK is array (4 downto 0) of std_logic_vector(31 downto 0);
	signal reg : REGISTER_BLOCK;
begin

	rs <= reg(conv_integer(addr_rs)); -- Read Register 1
	rt <= reg(conv_integer(addr_rt)); -- Read Register 2
	
	instruction_fetch : process(clk)
	begin
		if (clk'event and clk = '1') then
			if (RegWrite = '1') then
				reg(conv_integer(addr_rd)) <= rd; -- Write Register 3
			end if;
		end if;
	end process instruction_fetch;
	
end Structure;
			