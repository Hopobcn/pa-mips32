Library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all; Not an standard library-don't use
use ieee.numeric_std.all;

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

-- pag.A-24 of Patterson/Henessy List of RegisterName--#Number
architecture Structure of regfile is
	type REGISTER_BLOCK is array (2**5-1 downto 0) of std_logic_vector(31 downto 0);
	signal reg : REGISTER_BLOCK;
	
	signal RegWrite_tmp  : std_logic;
begin

	RegWrite_tmp	<= '0' when addr_rd = "00000" else
							RegWrite;
	
	rs <= x"00000000" when addr_rs = "00000" else
	      reg(to_integer(unsigned(addr_rs)));    
	      
	rt <= x"00000000" when addr_rt = "00000" else
	      reg(to_integer(unsigned(addr_rt))); 
	                    
	--register_file_read : process(clk)
	--begin
	--	if (clk'event and clk = '1') then
			-- Read Register Rs & Register Rt
			--#zero should be read as zeros 
	--		if (addr_rs = "00000") then       --crec que no va
	--			rs <= x"00000000";
	--		else
	--			rs <= reg(to_integer(unsigned(addr_rs))); 
	--		end if;
		  
	--		if (addr_rt = "00000") then
	--			rt <= x"00000000";
	--		else
	--			rt <= reg(to_integer(unsigned(addr_rt)));
	--		end if;
	--	end if;
	--end process register_file_read;
	
	register_file_write : process(clk)
	begin
		if (clk'event and clk = '0') then
			if (RegWrite_tmp = '1') then
			  -- Write Register Rd
				reg(to_integer(unsigned(addr_rd))) <= rd; 
			end if;
		end if;
	end process register_file_write;	
	
end Structure;
			