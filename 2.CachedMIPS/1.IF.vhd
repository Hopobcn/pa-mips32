library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity instruction_fetch is
    port (-- buses
          addr_jump       :   in  std_logic_vector(31 downto 0);  --from EXE
          addr_branch     :   in  std_logic_vector(31 downto 0);  --from LOOKUP
          pc              :   out std_logic_vector(31 downto 0);  --to Main Memory BUS
          pc_up           :   out std_logic_vector(31 downto 0);  --to stage ID
          instruction     :   out std_logic_vector(31 downto 0);  --to stage ID
          busDataMem      :   in  std_logic_vector(127 downto 0);  --to Main Memory
          -- control signals
          clk             :   in  std_logic;
          boot            :   in  std_logic;
          Jump            :   in  std_logic;                      --from EXE
          PCSrc           :   in  std_logic;                      --from LOOKUP
          ExceptionJump   :   in  std_logic;                      --from Exception Ctrl
			 IC_Ready        :   out std_logic;                      --to Hazard Ctrl
          NOP_to_ID       :   in  std_logic;                      --from Hazard Ctrl
          Stall           :   in  std_logic;                      --from Hazard Ctrl     
          BusRd           :   out std_logic;                      --to Main Memory
          BusWr           :   out std_logic;                      --to Main Memory
          BusReady        :   in  std_logic;                      --to Main Memory
          -- exception bits
          exception_if    :   out std_logic;
          -- Exception-related registers
          Exc_BadVAddr_out : out std_logic_vector(31 downto 0);
          Exc_Cause_out    : out std_logic_vector(31 downto 0);
          Exc_EPC_out      : out std_logic_vector(31 downto 0));
            
            
end instruction_fetch;

architecture Structure of instruction_fetch is
    
    component reg_pc is
    port (pc_up   :   in  std_logic_vector(31 downto 0);
          pc      :   out std_logic_vector(31 downto 0);
          Stall   :   in std_logic;
          clk     :   in  std_logic;
          boot    :   in  std_logic);
    end component;
    
    component inst_cache is
    port (addr       : in  std_logic_vector(31 downto 0);
          instruction: out std_logic_vector(31 downto 0);
          busDataMem : in  std_logic_vector(127 downto 0);
          -- control signal
          BusRd      : out std_logic;
          BusWr      : out std_logic;
          BusReady   : in  std_logic;
          Ready      : out std_logic;
          clk        : in  std_logic;
          reset      : in  std_logic);
    end component;

    signal pc_up_tmp        :   std_logic_vector(31 downto 0);
    signal pc_tmp           :   std_logic_vector(31 downto 0);
    signal instruction_read : std_logic_vector(31 downto 0);
    signal exception_internal : std_logic;
    
    signal Jump_tmp         : std_logic;
begin
    Jump_tmp        <= Jump when boot = '0' else
                       '0';

    -- Branch would be older, so it has priority over Jump. Default is ``next instruction''
    pc_up_tmp       <= addr_branch when PCSrc = '1' else 
                       addr_jump when Jump_tmp = '1' else
                       x"80000180" when ExceptionJump = '1' else
                       pc_tmp + x"00000004";
    
    program_counter :   reg_pc
    port map(pc_up       =>  pc_up_tmp,
                pc       => pc_tmp,
                Stall    => Stall,
                clk      => clk,
                boot     => boot);
                 
     instruction_cache  :   inst_cache
     port map(addr       => pc_tmp,
              instruction=> instruction_read,
              busDataMem => busDataMem,
              BusRd      => BusRd,
              BusWr      => BusWr,
              BusReady   => BusReady,
              Ready      => IC_Ready,
              clk        => clk,
              reset      => boot);
    
    pc    <= pc_tmp;
    pc_up <= pc_up_tmp;
    
    -- Exception (to be fully implemented with virtual memory)
    exception_internal <= '0';
    
    -- Output the exception (and put exceptions through)
    exception_if <= '0' when NOP_to_ID = '1' else
                    '0';
    
    Exc_BadVAddr_out <= pc_tmp;
    Exc_EPC_out <= pc_tmp;
    -- ToDo Appendix A-35 something better
    Exc_Cause_out <= x"00000001" when exception_internal = '1' else
                     x"00000000";

    
    --NOP
    instruction <= x"00000000" when NOP_to_ID = '1' or exception_internal = '1' else
                   instruction_read;
    
    
end Structure;
