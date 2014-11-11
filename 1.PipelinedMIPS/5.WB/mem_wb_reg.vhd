library ieee;
use ieee.std_logic_1164.all;

entity mem_wb_reg is
	port (-- buses	
			write_data_in	:	in 	std_logic_vector(31 downto 0);	
			write_data_out	:	out 	std_logic_vector(31 downto 0);
			addr_regw_in	:	in		std_logic_vector(5 downto 0);	
			addr_regw_out	:	out 	std_logic_vector(5 downto 0);	
			-- control signals
			RegWrite_in		:	in 	std_logic;
			RegWrite_out	:	out 	std_logic;
			-- register control signals
			enable			:	in 	std_logic;
			clk				:	in 	std_logic;
      -- exception registers
      Exc_EPC_in       : in std_logic_vector(31 downto 0);
      Exc_EPC_out      : out std_logic_vector(31 downto 0);
      Exc_Cause_in     : in std_logic_vector(31 downto 0);
      Exc_Cause_out    : out std_logic_vector(31 downto 0);
      Exc_BadVAddr_in  : in std_logic_vector(31 downto 0);
      Exc_BadVAddr_out : out std_logic_vector(31 downto 0);
      -- write enable for exception registers
      writeCause_in     : in std_logic;
      writeCause_out    : out std_logic;
      writeBadVAddr_in  : in std_logic;
      writeBadVAddr_out : out std_logic;
      writeEPC_in       : in std_logic;
      writeEPC_out      : out std_logic);

end mem_wb_reg;

architecture Structure of mem_wb_reg is

begin

	mem_wb_reg : process(clk)
	begin
		if (enable = '1') then
			if (rising_edge(clk)) then
				write_data_out	<= write_data_in;
				addr_regw_out	<= addr_regw_in;
				RegWrite_out	<= RegWrite_in;
				-- forward of registers
				Exc_EPC_out <= Exc_EPC_in;
				Exc_Cause_out <= Exc_Cause_in;
				Exc_BadVAddr_out <= Exc_BadVAddr_in;
        -- forward of bit enable for previous registers (to exception register file)
        writeCause_out <= writeCause_in;
        writeBadVAddr_out <= writeBadVAddr_in;
        writeEPC_out <= writeEPC_in;
			end if;
		end if;
	end process;	
	
end Structure;
			