library ieee;
use ieee.std_logic_1164.all;


entity hazard_ctrl is
    port (idRegisterRs    : in  std_logic_vector(5 downto 0);  --consumidor
          idRegisterRt    : in  std_logic_vector(5 downto 0);  --consumidor
          exeRegisterRd   : in  std_logic_vector(5 downto 0);  --productor (load) in exe
          tagRegisterRd   : in  std_logic_vector(5 downto 0);  --productor (load) in lookup
          exeMemRead      : in  std_logic;
          tagMemRead      : in  std_logic;
          Branch          : in  std_logic;                     -- from LOOKUP stage (1=branch taken)
          Jump            : in  std_logic;                     -- from EXE stage
          Exception       : in  std_logic;                     -- from Exception Ctrl (LOOKUP stage) --wait until instruction is the oldest ``alive''
          Interrupt       : in  std_logic;                     -- from Interrupt Ctrl (any point)
          Interrupt_to_Exception_ctrl : out std_logic;
          IC_Ready        : in  std_logic;                     -- from IF (means Instruction Cache Ready (1 when hit) if 0 stall)
          DC_Ready        : in  std_logic;                     -- from MEM (means Data Cache Ready (1 when hit)
          ROB_Ready       : in  std_logic;                     -- from ROB, indicating not-full state
          ROB_Update      : out std_logic;                     -- to ROB, when we are not stalling ID
          robLoadStoreDep : in  std_logic;
          -- control signals
          Stall_LP        : out std_logic;
          Stall_PC        : out std_logic;
          Stall_IF_ID     : out std_logic;
          Stall_ID_EXE    : out std_logic;
          Stall_EXE_LOOKUP: out std_logic;
          NOP_to_LP       : out std_logic;
          NOP_to_ID       : out std_logic;
          NOP_to_EXE      : out std_logic;
          NOP_to_L        : out std_logic;
          NOP_to_C        : out std_logic;
          NOP_to_WB       : out std_logic;
          -- asynchronous dependence with boot signal
          boot            : in  std_logic);
end hazard_ctrl;

architecture Structure of hazard_ctrl is
    
begin
                       
    stall_logic : process(boot, idRegisterRs,idRegisterRt,exeRegisterRd,tagRegisterRd,exeMemRead,tagMemRead,Branch,Jump,Exception,Interrupt,IC_Ready,DC_Ready)
    begin
        ROB_Update      <= '1';
        Stall_PC        <= '0';
        Stall_IF_ID     <= '0';
        Stall_ID_EXE    <= '0';
        Stall_LP        <= '0';
        Stall_EXE_LOOKUP<= '0';
        NOP_to_ID       <= '0';
        NOP_to_EXE      <= '0';
        NOP_to_LP       <= '0';
        NOP_to_L        <= '0';
        NOP_to_C        <= '0';
        NOP_to_WB       <= '0';
        Interrupt_to_Exception_ctrl <= '0';
        if (boot = '1') then
            ROB_Update      <= '0';
            Stall_PC        <= '0';
            Stall_IF_ID     <= '0';
            Stall_ID_EXE    <= '0';
            Stall_LP        <= '0';
            Stall_EXE_LOOKUP<= '0';
            NOP_to_ID       <= '1';
            NOP_to_EXE      <= '1';
            NOP_to_LP       <= '1';
            NOP_to_L        <= '1';
            NOP_to_C        <= '1';
            NOP_to_WB       <= '1';
            Interrupt_to_Exception_ctrl <= '0';
        elsif (Exception = '1') then
            ROB_Update      <= '0';
            NOP_to_ID       <= '1';
            NOP_to_EXE      <= '1';
            NOP_to_LP       <= '1';
            NOP_to_L        <= '1';
            NOP_to_C        <= '1';
            --NOP_to_WB     <= '1'; --do not clear the memory stage
            -- because the memory stage is the one with the exception
        elsif (Interrupt = '1' and Jump = '0') then
            -- TODO add a "store check", because then the instruction cannot be executed again
            ROB_Update      <= '0';
            NOP_to_ID       <= '1';
            NOP_to_EXE      <= '1';
            NOP_to_LP       <= '1';
            NOP_to_L        <= '1';
            NOP_to_C        <= '1';
            NOP_to_WB       <= '1';
        elsif (not DC_Ready = '1') then
            ROB_Update      <= '0';
            Stall_PC        <= '1';
            Stall_IF_ID     <= '1';
            Stall_ID_EXE    <= '1';
            Stall_LP        <= '1';
            Stall_EXE_LOOKUP<= '1';
            NOP_to_C        <= '1';
        elsif (Branch = '1') then 
            ROB_Update      <= '0';
            NOP_to_ID       <= '1';
            NOP_to_EXE      <= '1';
            NOP_to_LP       <= '1';
            NOP_to_L        <= '1';
        elsif (Jump = '1') then
            ROB_Update      <= '0';
            NOP_to_ID       <= '1';
            NOP_to_EXE      <= '1';
            NOP_to_LP       <= '1';
        elsif (robLoadStoreDep = '1') then -- LOAD in lookup, STORE in ROB, @ match
            ROB_Update      <= '0';
              Stall_PC        <= '1';
                Stall_IF_ID     <= '1';
                Stall_ID_EXE    <= '1';
                Stall_EXE_LOOKUP<= '1';
                NOP_to_C        <= '1'; -- NOT shure if this is necessary
        elsif ((idRegisterRs = exeRegisterRd or idRegisterRt = exeRegisterRd) and exeMemRead = '1') then -- LOAD in exe (we need to wait until C to forward)
            ROB_Update      <= '0';
            Stall_PC        <= '1';
            Stall_IF_ID     <= '1';
            NOP_to_EXE      <= '1';
        elsif ((idRegisterRs = tagRegisterRd or idRegisterRt = tagRegisterRd) and tagMemRead = '1') then -- LOAD in lookup (we need to wait until C to forward)
            ROB_Update      <= '0';
            Stall_PC        <= '1';
            Stall_IF_ID     <= '1';
            NOP_to_LP       <= '1';
            NOP_to_EXE      <= '1';
        elsif (ROB_Ready = '0') then
            ROB_Update      <= '0';
            Stall_PC        <= '1';
            Stall_IF_ID     <= '1';
            NOP_to_LP       <= '1';
            NOP_to_EXE      <= '1';
        elsif (not IC_Ready = '1') then
            ROB_Update      <= '1';
            Stall_PC        <= '1';
            NOP_to_ID       <= '1';
        end if;
  end process;

end Structure;
