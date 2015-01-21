library ieee;
use ieee.std_logic_1164.all;


entity interrupt_ctrl is
    port (interrupt  : in  std_logic;
          int_clear  : in  std_logic;
          int_flag   : out std_logic;
          clk        : in std_logic;
          boot       : in std_logic); 
end interrupt_ctrl;

architecture Structure of interrupt_ctrl is
  signal int_flag_tmp : std_logic;
begin
    -- Process to synchronize the signal
    interrupt_synchronize : process(clk, boot, interrupt, int_clear)
    begin
        if (rising_edge(clk)) then
            if (boot = '1') then
                int_flag_tmp <= '0';
            else
                if (interrupt = '1') then
                    int_flag_tmp <= '1';
                end if;
                if (int_clear = '1') then
                    int_flag_tmp <= '0';
                end if;
            end if;
        end if;
    end process;

    int_flag <= int_flag_tmp;

end Structure;
