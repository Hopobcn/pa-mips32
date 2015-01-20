library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity LI_stage is
    port (-- buses
            rs_in           :   in  std_logic_vector(31 downto 0);
            rs_out          :   out std_logic_vector(31 downto 0);
            rt_in           :   in  std_logic_vector(31 downto 0);
            rt_out          :   out std_logic_vector(31 downto 0);
            addr_rd_in      :   in  std_logic_vector(4 downto 0);
            addr_rd_out     :   out std_logic_vector(4 downto 0);
            -- control signals
            clk             :   in std_logic;
            Stall           :   in std_logic;
            doinst_in       :   in  std_logic;
            doinst_out      :   out std_logic);
end LI_stage;

architecture Structure of LI_stage is
begin
    LI_stage_register : process(clk)
    begin
        if (rising_edge(clk) AND Stall='0') then
            rs_out      <= rt_in;
            rt_out      <= rs_in;
            addr_rd_out <= addr_rd_in;
            doinst_out  <= doinst_in;
        end if;
    end process;

end Structure;
