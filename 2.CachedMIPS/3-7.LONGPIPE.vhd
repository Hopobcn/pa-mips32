library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity longinstruction is
    port (-- buses
            rs              :   in  std_logic_vector(31 downto 0);  --from ID
            rt              :   in  std_logic_vector(31 downto 0);  --from ID
            addr_rd         :   in  std_logic_vector(4 downto 0);   --from ID
            write_data_out  :   out std_logic_vector(31 downto 0);  --to 8.WB
            addr_regw       :   out std_logic_vector(4 downto 0);   --to 8.WB
            -- control signals
            clk             :   in std_logic;
            boot            :   in std_logic;
            Stall           :   in std_logic;
            doinstruction   :   in  std_logic;
            write_output    :   out std_logic);

end longinstruction;

architecture Structure of longinstruction is

    component LI_stage is
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
    end component;

    signal rs_reg12      : std_logic_vector(31 downto 0);
    signal rs_reg23      : std_logic_vector(31 downto 0);
    signal rs_reg34      : std_logic_vector(31 downto 0);
    signal rs_reg45      : std_logic_vector(31 downto 0);
    signal rt_reg12      : std_logic_vector(31 downto 0);
    signal rt_reg23      : std_logic_vector(31 downto 0);
    signal rt_reg34      : std_logic_vector(31 downto 0);
    signal rt_reg45      : std_logic_vector(31 downto 0);
    signal addr_rd_reg12 : std_logic_vector(4 downto 0);
    signal addr_rd_reg23 : std_logic_vector(4 downto 0);
    signal addr_rd_reg34 : std_logic_vector(4 downto 0);
    signal addr_rd_reg45 : std_logic_vector(4 downto 0);
    signal doinst_reg12  : std_logic;
    signal doinst_reg23  : std_logic;
    signal doinst_reg34  : std_logic;
    signal doinst_reg45  : std_logic;
    
    signal doinst_reg12bis  : std_logic;
    signal doinst_reg23bis  : std_logic;
    signal doinst_reg34bis  : std_logic;
    signal doinst_reg45bis  : std_logic;


begin

    doinst_reg12bis <= '0' when boot = '1' else
                      '1';
    doinst_reg23bis <= '0' when boot = '1' else
                      '1';
    doinst_reg34bis <= '0' when boot = '1' else
                      '1';
    doinst_reg45bis <= '0' when boot = '1' else
                      '1';

    stage1 : LI_stage
    port map(-- buses
             rs_in          => rs,
             rs_out         => rs_reg12,
             rt_in          => rt,
             rt_out         => rt_reg12,
             addr_rd_in     => addr_rd,
             addr_rd_out    => addr_rd_reg12,
             -- control signals
             clk            => clk,
             Stall          => Stall,
             doinst_in      => doinstruction,
             doinst_out     => doinst_reg12);

    stage2 : LI_stage
    port map(-- buses
             rs_in          => rs_reg12,
             rs_out         => rs_reg23,
             rt_in          => rt_reg12,
             rt_out         => rt_reg23,
             addr_rd_in     => addr_rd_reg12,
             addr_rd_out    => addr_rd_reg23,
             -- control signals
             clk            => clk,
             Stall          => Stall,
             doinst_in      => doinst_reg12bis,
             doinst_out     => doinst_reg23);
    
    stage3 : LI_stage
    port map(-- buses
             rs_in          => rs_reg23,
             rs_out         => rs_reg34,
             rt_in          => rt_reg23,
             rt_out         => rt_reg34,
             addr_rd_in     => addr_rd_reg23,
             addr_rd_out    => addr_rd_reg34,
             -- control signals
             clk            => clk,
             Stall          => Stall,
             doinst_in      => doinst_reg23bis,
             doinst_out     => doinst_reg34);
    
    stage4 : LI_stage
    port map(-- buses
             rs_in          => rs_reg34,
             rs_out         => rs_reg45,
             rt_in          => rt_reg34,
             rt_out         => rt_reg45,
             addr_rd_in     => addr_rd_reg34,
             addr_rd_out    => addr_rd_reg45,
             -- control signals
             clk            => clk,
             Stall          => Stall,
             doinst_in      => doinst_reg34bis,
             doinst_out     => doinst_reg45);

    stage5 : LI_stage
    port map(-- buses
             rs_in          => rs_reg45,
             rs_out         => write_data_out,
             rt_in          => rt_reg45,
             --rt_out         => <unused>,
             addr_rd_in     => addr_rd_reg45,
             addr_rd_out    => addr_regw,
             -- control signals
             clk            => clk,
             Stall          => Stall,
             doinst_in      => doinst_reg45bis,
             doinst_out     => write_output);

end Structure;
