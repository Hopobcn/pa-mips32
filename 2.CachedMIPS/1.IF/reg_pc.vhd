library ieee;
use ieee.std_logic_1164.all;

entity reg_pc is
    port (-- buses
          pc_up   :   in  std_logic_vector(31 downto 0);
          pc      :   out std_logic_vector(31 downto 0);
          -- control signals
          Stall   :   in  std_logic;
          clk     :   in  std_logic;
          boot    :   in  std_logic);
end reg_pc;

architecture Structure of reg_pc is
    signal pc_tmp       : std_logic_vector(31 downto 0);
begin
    pc <= pc_tmp;
    
    instruction_register : process(clk)
    begin
        if (rising_edge(clk)) then
            if (boot = '1') then
                pc_tmp <= x"00000000";
            elsif (Stall = '0') then
                pc_tmp <= pc_up;
            else
                pc_tmp <= pc_tmp;
            end if;
        else
            pc_tmp <= pc_tmp;
        end if;
    end process;
end Structure;
