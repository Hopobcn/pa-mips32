Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity if_id_reg is
	port (instruction_in	: 	in std_logic_vector(31 downto 0);
			instruction_out:	out std_logic_vector(31 downto 0);
			pc_up_in			:	in	std_logic_vector(31 downto 0);	
			pc_up_out		:	out std_logic_vector(31 downto 0);	
			-- register control signals
			enable			:	in std_logic;
			clk				:	in std_logic);
end if_id_reg;

architecture Structure of if_id_reg is
	
begin

	if_id_register : process(clk,enable)
	begin
		if (enable = '1') then
			if (rising_edge(clk)) then
				instruction_out <= instruction_in;
				pc_up_out		 <= pc_up_in;				
			end if;
		end if;
	end process;	
	
end Structure;
			