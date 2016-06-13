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
			clk				:	in std_logic;
			-- exception identifier bits
      exception_if_in   :  in std_logic;
      exception_if_out  : out std_logic;
      -- exception registers
      Exc_EPC_in       : in std_logic_vector(31 downto 0);
      Exc_EPC_out      : out std_logic_vector(31 downto 0);
      Exc_Cause_in     : in std_logic_vector(31 downto 0);
      Exc_Cause_out    : out std_logic_vector(31 downto 0);
      Exc_BadVAddr_in  : in std_logic_vector(31 downto 0);
      Exc_BadVAddr_out : out std_logic_vector(31 downto 0));
      
end if_id_reg;

architecture Structure of if_id_reg is
	
begin

	if_id_register : process(clk, enable)
	begin
		if ((enable = '1') and (rising_edge(clk))) then
				instruction_out <= instruction_in;
				pc_up_out		 <= pc_up_in;	
				-- forward of exception identifier bits
				exception_if_out <= exception_if_in;
				-- forward of registers
				Exc_EPC_out <= Exc_EPC_in;
				Exc_Cause_out <= Exc_Cause_in;
				Exc_BadVAddr_out <= Exc_BadVAddr_in;
		end if;
	end process;	
	
end Structure;
			