library ieee;
use ieee.std_logic_1164.all;

entity mem_wb_reg is
	port (-- buses
			read_data_in	:	in 	std_logic_vector(31 downto 0);	
			read_data_out	:	out 	std_logic_vector(31 downto 0);	
			bypass_mem_in	:	in 	std_logic_vector(31 downto 0);	
			bypass_mem_out	:	out 	std_logic_vector(31 downto 0);
			addr_regw_in	:	in		std_logic_vector(4 downto 0);	
			addr_regw_out	:	out 	std_logic_vector(4 downto 0);	
			-- control signals
			RegWrite_in		:	in 	std_logic;
			RegWrite_out	:	out 	std_logic;
			MemtoReg_in		:	in		std_logic;	
			MemtoReg_out	:	out 	std_logic;
			-- register control signals
			enable			:	in 	std_logic;
			clk				:	in 	std_logic);
end mem_wb_reg;

architecture Structure of mem_wb_reg is

begin

	mem_wb_reg : process(clk,enable)
	begin
		if (enable = '1') then
			if (rising_edge(clk)) then
				read_data_out	<= read_data_in;
				bypass_mem_out	<= bypass_mem_in;
				addr_regw_out	<= addr_regw_in;
				RegWrite_out	<= RegWrite_in;
				MemtoReg_out	<= MemtoReg_in;
			end if;
		end if;
	end process;	
	
end Structure;
			