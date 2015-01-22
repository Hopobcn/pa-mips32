library ieee;
use ieee.std_logic_1164.all;

entity CachedMIPS32 is
    port(clk                : in std_logic;
         boot               : in std_logic;
         external_interrupt : in std_logic);

end CachedMIPS32;

architecture Structure of CachedMIPS32 is
    
    component instruction_fetch is
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
            
    end component;
    
    component instruction_decode is
    port (-- buses
          instruction     :   in  std_logic_vector(31 downto 0);  --from IF
          addr_jump       :   out std_logic_vector(31 downto 0);  --to EXE,IF
          pc_up_in        :   in  std_logic_vector(31 downto 0);  --from IF
          pc_up_out       :   out std_logic_vector(31 downto 0);  --to EXE
          opcode          :   out std_logic_vector(5 downto 0);   --to EXE
          rs              :   out std_logic_vector(31 downto 0);  --to EXE
          rt              :   out std_logic_vector(31 downto 0);  --to EXE
          rd              :   in  std_logic_vector(31 downto 0);  --from WB           
          sign_ext        :   out std_logic_vector(31 downto 0);  --to EXE
          zero_ext        :   out std_logic_vector(31 downto 0);  --to EXE
          addr_rs         :   out std_logic_vector(5 downto 0);   --to HAZARD CTRL
          addr_rt         :   out std_logic_vector(5 downto 0);   --to EXE
          addr_rd         :   out std_logic_vector(5 downto 0);   --to EXE
          write_data      :   out std_logic_vector(31 downto 0);  --to EXE,LOOKUP,CACHE
          addr_regw       :   in  std_logic_vector(5 downto 0);   --from WB
          fwd_path_alu    :   in  std_logic_vector(31 downto 0);  --from ALU    [FWD]
          fwd_path_lookup :   in  std_logic_vector(31 downto 0);  --from LOOKUP [FWD]
          fwd_path_cache  :   in  std_logic_vector(31 downto 0);  --from CACHE  [FWD]
          -- the long pipe, a bit special
          lp_rs           :   out std_logic_vector(31 downto 0);
          lp_rt           :   out std_logic_vector(31 downto 0);
          lp_addr_rd      :   out std_logic_vector(4 downto 0);
          lp_doinst       :   out std_logic;
          -- control signals
          clk             :   in  std_logic;
          RegWrite_out    :   out std_logic;                      --to EXE,LOOKUP,CACHE,WB and then ID
          Jump            :   out std_logic;                      --to EXE,IF
          Branch          :   out std_logic;                      --to EXE,LOOKUP
          MemRead         :   out std_logic;                      --to EXE,LOOKUP (CACHE?)
          MemWrite        :   out std_logic;                      --to EXE,LOOKUP (CACHE?)
          MemWriteHazard  :   out std_logic;                      --to Hazard control (pure value without NOP, if not weird things occur)
          ByteAddress     :   out std_logic;                      --to EXE,LOOKUP (CACHE?)
          WordAddress     :   out std_logic;                      --to EXE,LOOKUP (CACHE?)
          MemtoReg        :   out std_logic;                      --to EXE,LOOKUP,CACHE,WB
          RegDst          :   out std_logic;                      --to EXE
          ALUOp           :   out std_logic_vector(2 downto 0);   --to EXE
          ALUSrc          :   out std_logic;                      --to EXE
          RegWrite_in     :   in  std_logic;                      --from WB   
          fwd_aluRs       :   in  std_logic_vector(1 downto 0);   --from FWD Ctrl
          fwd_aluRt       :   in  std_logic_vector(1 downto 0);   --from FWD Ctrl
          fwd_alu_regmem  :   in  std_logic_vector(1 downto 0);   --from FWD Ctrl 
          NOP_to_EXE      :   in  std_logic;                      --from Hazard Ctrl
          Stall           :   in  std_logic; 
          -- exception bits
          exception_if_in :   in  std_logic;
          exception_if_out:   out std_logic;
          exception_id    :   out std_logic;
          -- Exception-related registers
          Exc_BadVAddr_in :   in  std_logic_vector(31 downto 0);
          Exc_BadVAddr_out:   out std_logic_vector(31 downto 0);
          Exc_Cause_in    :   in  std_logic_vector(31 downto 0);
          Exc_Cause_out   :   out std_logic_vector(31 downto 0);
          Exc_EPC_in      :   in  std_logic_vector(31 downto 0);
          Exc_EPC_out     :   out std_logic_vector(31 downto 0);
          -- Write into the Exception Register File
          Exc_BadVAddr_to_regfile  : in std_logic_vector(31 downto 0);
          Exc_Cause_to_regfile     : in std_logic_vector(31 downto 0);
          Exc_EPC_to_regfile       : in std_logic_vector(31 downto 0);
          writeBadVAddr_to_regfile : in std_logic;
          writeCause_to_regfile    : in std_logic;
          writeEPC_to_regfile      : in std_logic);
 
    end component;

    component execute is
    port (-- buses
          pc_up               :   in  std_logic_vector(31 downto 0);  --from ID
          opcode              :   in  std_logic_vector(5 downto 0);   --from ID
          rs                  :   in  std_logic_vector(31 downto 0);  --from ID
          rt                  :   in  std_logic_vector(31 downto 0);  --from ID
          sign_ext            :   in  std_logic_vector(31 downto 0);  --from ID
          zero_ext            :   in  std_logic_vector(31 downto 0);  --from ID
          addr_rt_in          :   in  std_logic_vector(5 downto 0);   --from ID
          addr_rt_out         :   out std_logic_vector(5 downto 0);   --to Hazard Ctrl
          addr_rd             :   in  std_logic_vector(5 downto 0);   --from ID
          addr_jump_in        :   in  std_logic_vector(31 downto 0);  --from ID
          addr_jump_out       :   out std_logic_vector(31 downto 0);  --to IF
          addr_branch         :   out std_logic_vector(31 downto 0);  --to LOOKUP,then IF
          alu_res             :   out std_logic_vector(31 downto 0);  --to LOOKUP
          write_data_in       :   in  std_logic_vector(31 downto 0);  --from ID
          write_data_out      :   out std_logic_vector(31 downto 0);  --to LOOKUP
          addr_regw           :   out std_logic_vector(5 downto 0);   --to LOOKUP,CACHE,WB, then IF
          fwd_path_alu        :   out std_logic_vector(31 downto 0);  --to ID         [FWD]
          fwd_path_lookup     :   in  std_logic_vector(31 downto 0);  --from LOOKUP   [FWD]
          fwd_path_cache      :   in  std_logic_vector(31 downto 0);  --from CACHE    [FWD]
          -- control signals
          clk                 :   in  std_logic;
          RegWrite_in         :   in  std_logic;                      --from ID
          RegWrite_out        :   out std_logic;                      --to LOOKUP,CACHE,WB, then ID
          Jump_in             :   in  std_logic;                      --from ID
          Jump_out            :   out std_logic;                      --to IF
          Branch_in           :   in  std_logic;                      --from ID
          Branch_out          :   out std_logic;                      --to LOOKUP
          MemRead_in          :   in  std_logic;                      --from ID 
          MemRead_out         :   out std_logic;                      --to LOOKUP
          MemWrite_in         :   in  std_logic;                      --from ID  
          MemWrite_out        :   out std_logic;                      --to LOOKUP    
          ByteAddress_in      :   in  std_logic;                      --from ID
          ByteAddress_out     :   out std_logic;                      --from LOOKUP
          WordAddress_in      :   in  std_logic;                      --from ID
          WordAddress_out     :   out std_logic;                      --from LOOKUP  
          MemtoReg_in         :   in  std_logic;                      --from EXE
          MemtoReg_out        :   out std_logic;                      --to LOOKUP,CACHE,WB
          RegDst              :   in  std_logic;                      --from ID
          ALUOp               :   in  std_logic_vector(2 downto 0);   --from ID
          ALUSrc              :   in  std_logic;                      --from ID
          Zero                :   out std_logic;                      --to LOOKUP
          fwd_lookup_regmem   :   in  std_logic;                      --from FWD Ctrl
          fwd_cache_regmem    :   in  std_logic;                      --from FWD Ctrl
          NOP_to_L            :   in  std_logic;                      --from Hazard Ctrl
          Stall               :   in  std_logic;
          -- exception bits
          exception_if_in     :   in  std_logic;
          exception_if_out    :   out std_logic;
          exception_id_in     :   in  std_logic;
          exception_id_out    :   out std_logic;
          exception_exe       :   out std_logic;
          -- Exception-related registers
          Exc_BadVAddr_in     :   in  std_logic_vector(31 downto 0);
          Exc_BadVAddr_out    :   out std_logic_vector(31 downto 0);
          Exc_Cause_in        :   in  std_logic_vector(31 downto 0);
          Exc_Cause_out       :   out std_logic_vector(31 downto 0);
          Exc_EPC_in          :   in  std_logic_vector(31 downto 0);
          Exc_EPC_out         :   out std_logic_vector(31 downto 0));

    end component;
            
    component lookup is
    port (-- buses
          addr_branch_in     : in  std_logic_vector(31 downto 0);  --from EXE
          addr_branch_out    : out std_logic_vector(31 downto 0);  --to IF
          addr_in            : in  std_logic_vector(31 downto 0);  --from EXE --named alu_res in EXE
          addr_out           : out std_logic_vector(31 downto 0);  --to CACHE
          write_data_mem_in  : in  std_logic_vector(31 downto 0);  --from EXE
          write_data_mem_out : out std_logic_vector(31 downto 0);  --to CACHE
          addr_regw_in       : in  std_logic_vector(5 downto 0);   --from EXE
          addr_regw_out      : out std_logic_vector(5 downto 0);   --to CACHE, WB, then IF
          fwd_path_lookup    : out std_logic_vector(31 downto 0);  --to ID [FWD]
          -- control signals
          clk                : in  std_logic;
          boot               : in  std_logic;
          RegWrite_in        : in  std_logic;                      --from EXE
          RegWrite_out       : out std_logic;                      --to CACHE,WB, then ID
          Branch             : in  std_logic;                      --from EXE
          BranchTaken        : out std_logic;                      --to control (identify end of branch stall)
          PCSrc              : out std_logic;                      --to ID
          MemRead            : in  std_logic;                      --from EXE
          MemWrite           : in  std_logic;                      --from EXE
          ByteAddress_in     : in  std_logic;                      --from EXE
          ByteAddress_out    : out std_logic;                      --to CACHE
          WordAddress_in     : in  std_logic;                      --from EXE
          WordAddress_out    : out std_logic;                      --to CACHE
          MemtoReg_in        : in  std_logic;                      --from EXE
          MemtoReg_out       : out std_logic;                      --to CACHE
          Zero               : in  std_logic;                      --from EXE
             -- interface with data_cache data
          WriteCache         : out std_logic;                      --to CACHE
          muxDataR           : out std_logic;                      --to CACHE
          muxDataW           : out std_logic;                      --to CACHE 
          BusRd              : out std_logic;                      --to Main Memory
          BusWr              : out std_logic;                      --to Main Memory
          BusReady           : in  std_logic;                      --from Main Memory
             -- interface with Hazard Control
          DC_Ready           : out std_logic;                      --to Hazard Ctrl
          NOP_to_C           : in  std_logic;                      --from Hazard Control
          Stall              : in  std_logic;                      --from Hazard Control
          -- exception bits
          exception_if_in    : in  std_logic;
          exception_if_out   : out std_logic;
          exception_id_in    : in  std_logic;
          exception_id_out   : out std_logic;
          exception_exe_in   : in  std_logic;
          exception_exe_out  : out std_logic;
          exception_lookup   : out std_logic;
          -- Exception-related registers
          Exc_BadVAddr_in    : in  std_logic_vector(31 downto 0);
          Exc_BadVAddr_out   : out std_logic_vector(31 downto 0);
          Exc_Cause_in       : in  std_logic_vector(31 downto 0);
          Exc_Cause_out      : out std_logic_vector(31 downto 0);
          Exc_EPC_in         : in  std_logic_vector(31 downto 0);
          Exc_EPC_out        : out std_logic_vector(31 downto 0));
            
    end component;

    component cache is
    port (-- buses
          addr                 : in  std_logic_vector(31 downto 0);  --from LOOKUP
          write_data_mem       : in  std_logic_vector(31 downto 0);  --from LOOKUP
          addr_regw_in         : in  std_logic_vector(5 downto 0);   --from LOOKUP
          addr_regw_out        : out std_logic_vector(5 downto 0);   --to WB,ID
          write_data_reg       : out std_logic_vector(31 downto 0);  --to WB
          fwd_path_cache       : out std_logic_vector(31 downto 0);  --to ID [FWD]       
          busDataMem           : in  std_logic_vector(127 downto 0);  --from Main Memory
          -- control signals
          clk                  : in  std_logic;
          RegWrite_in          : in  std_logic;                      --from LOOKUP
          RegWrite_out         : out std_logic;                      --to WB, ID
          ByteAddress          : in  std_logic;                      --from LOOKUP
          WordAddress          : in  std_logic;                      --from LOOKUP
          MemtoReg             : in  std_logic;                      --from LOOKUP
          -- interface with data_cache data
          WriteCache           : in  std_logic;                      --to CACHE
          muxDataR             : in  std_logic;                      --to CACHE
          muxDataW             : in  std_logic;                      --to CACHE 
          -- interface with Hazard Control
          NOP_to_WB            : in  std_logic;                      --from Hazard Control
          -- exception bits
          exception_if_in      : in  std_logic;
          exception_if_out     : out std_logic;
          exception_id_in      : in  std_logic;
          exception_id_out     : out std_logic;
          exception_exe_in     : in  std_logic;
          exception_exe_out    : out std_logic;
          exception_lookup_in  : in std_logic;
          exception_lookup_out : out std_logic;
          exception_cache      : out std_logic;
          -- Exception-related registers
          Exc_BadVAddr_in      : in  std_logic_vector(31 downto 0);    --from previous stage (pipelined)
          Exc_BadVAddr_out     : out std_logic_vector(31 downto 0);    --to coprocessor 0 register file
          Exc_Cause_in         : in  std_logic_vector(31 downto 0);    --from previous stage (pipelined)
          Exc_Cause_out        : out std_logic_vector(31 downto 0);    --to coprocessor 0 register file
          Exc_EPC_in           : in  std_logic_vector(31 downto 0);    --from previous stage (pipelined)
          Exc_EPC_out          : out std_logic_vector(31 downto 0));    --to coprocessor 0 register file

    end component;

    component write_back is
    port (-- buses
          write_data_in    : in  std_logic_vector(31 downto 0);  --from LOOKUP
          write_data_out   : out std_logic_vector(31 downto 0);  --to WB,ID
          addr_regw_in     : in  std_logic_vector(5 downto 0);   --from LOOKUP
          addr_regw_out    : out std_logic_vector(5 downto 0);   --to WB,ID
          -- control signals
          clk              : in std_logic;
          RegWrite_in      : in std_logic;
          RegWrite_out     : out std_logic;
          -- Exception-related registers
          Exc_BadVAddr_in  : in  std_logic_vector(31 downto 0);    --from previous stage (pipelined)
          Exc_BadVAddr_out : out std_logic_vector(31 downto 0);    --to coprocessor 0 register file
          Exc_Cause_in     : in  std_logic_vector(31 downto 0);    --from previous stage (pipelined)
          Exc_Cause_out    : out std_logic_vector(31 downto 0);    --to coprocessor 0 register file
          Exc_EPC_in       : in  std_logic_vector(31 downto 0);    --from previous stage (pipelined)
          Exc_EPC_out      : out std_logic_vector(31 downto 0);    --to coprocessor 0 register file
          -- Write enabling bits from exception control
          writeEPC_in      : in  std_logic;      --from Exception Control
          writeEPC_out     : out std_logic;      --to coprocessor 0 register file
          writeBadVAddr_in : in  std_logic;      --from Exception Control
          writeBadVAddr_out: out std_logic;      --to coprocessor 0 register file
          writeCause_in    : in  std_logic;      --from Exception Control
          writeCause_out   : out std_logic);     --to coprocessor 0 register file

    end component;
    
    component long_pipe is
      port (-- buses
            rs              :   in  std_logic_vector(31 downto 0);  --from ID
            rt              :   in  std_logic_vector(31 downto 0);  --from ID
            addr_rd         :   in  std_logic_vector(4 downto 0);   --from ID
            write_data_out  :   out std_logic_vector(31 downto 0);  --to 8.WB
            addr_regw       :   out std_logic_vector(4 downto 0);   --to 8.WB
            -- control signals
            clk             :   in std_logic;
            Stall           :   in std_logic;
            doinstruction   :   in  std_logic;
            write_output    :   out std_logic);
    end component;
    
    component main_mem is
    port (-- data buses
          addr         : in  std_logic_vector(31 downto 0); 
          write_data   : in  std_logic_vector(31 downto 0);
          read_data    : out std_logic_vector(127 downto 0);
          -- control signals
          Rd           : in  std_logic;
          Wr           : in  std_logic;
          Ready        : out std_logic;
          reset        : in  std_logic;
          clk          : in  std_logic);
    end component;

    component hazard_ctrl is
    port (idRegisterRs    : in  std_logic_vector(5 downto 0);  --consumidor
          idRegisterRt    : in  std_logic_vector(5 downto 0);  --consumidor
          exeRegisterRt   : in  std_logic_vector(5 downto 0);  --productor (load)
          exeMemRead      : in  std_logic;
          Branch          : in  std_logic;                     -- from LOOKUP stage (1=branch taken)
          Jump            : in  std_logic;                     -- from EXE stage
          Exception       : in  std_logic;                     -- from Exception Ctrl (LOOKUP stage) --wait until instruction is the oldest ``alive''
          Interrupt       : in  std_logic;                     -- from Interrupt Ctrl (any point)
          Interrupt_to_Exception_ctrl : out std_logic;
          IC_Ready        : in  std_logic;                     -- from IF (means Instruction Cache Ready (1 when hit) if 0 stall)
          DC_Ready        : in  std_logic;                     -- from MEM (means Data Cache Ready (1 when hit)
          ROB_Ready       : in  std_logic;                     -- from ROB, indicating not-full state
          ROB_Update      : out std_logic;                     -- to ROB, when we are not stalling ID
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
          NOP_to_WB       : out std_logic);
    end component;
    
    component forwarding_ctrl is
    port (idRegisterRs      : in  std_logic_vector(5 downto 0);  --consumer
          idRegisterRt      : in  std_logic_vector(5 downto 0);  --consumer
          exeRegisterRd     : in  std_logic_vector(5 downto 0);  --producer
          exeRegisterRt     : in  std_logic_vector(5 downto 0);  --producer
          tagRegisterRd     : in  std_logic_vector(5 downto 0);  --producer "tag -> LOOKUP stage"
          dcaRegisterRd     : in  std_logic_vector(5 downto 0);  --producer "dca == data cache -> CACHE stage"
          exeRegWrite       : in  std_logic;
          tagRegWrite       : in  std_logic;
          dcaRegWrite       : in  std_logic;
          idMemWrite        : in  std_logic;
          exeMemWrite       : in  std_logic;
          fwd_aluRs         : out std_logic_vector(1 downto 0);
          fwd_aluRt         : out std_logic_vector(1 downto 0);
          fwd_alu_regmem    : out std_logic_vector(1 downto 0);
          fwd_lookup_regmem : out std_logic;
          fwd_cache_regmem  : out std_logic); 
    end component;
    
    component exception_ctrl is
    port (-- Exception state at the MEMory stage
          exception_if        : in std_logic;
          exception_id        : in std_logic;
          exception_exe       : in std_logic;
          exception_lookup    : in std_logic;
          exception_cache     : in std_logic;
          -- If an interrupt-exception is "available"
          exception_interrupt : in std_logic;
          -- Exception flag
          exception_flag      : out std_logic; -- Exception-exception indicator
          exception_jump      : out std_logic; -- to IF, Force PC to jump to handler
          -- Signals for writeback
          wbexc_writeEPC      : out std_logic;
          wbexc_writeBadVAddr : out std_logic;
          wbexc_writeCause    : out std_logic); 
    end component;  

    component interrupt_ctrl is
    port (interrupt  : in  std_logic;
          int_clear  : in  std_logic;
          int_flag   : out std_logic;
          clk        : in  std_logic;
          boot       : in  std_logic); 
    end component;
    
    component rob_ctrl is
    port (
      clk : in std_logic;
      boot : in std_logic;

      -- The exception flag, for a certain exception operation
      except_flag : in std_logic;
      except_addr : in std_logic_vector(2 downto 0);

      -- The value flag, for storing an intermediate value
      value_flag : in std_logic;
      value_addr : in std_logic_vector(2 downto 0);
      value_alu  : in std_logic_vector(31 downto 0);
      -- ... and the memory address for stores
      value_mem  : in std_logic_vector(31 downto 0);

      -- To-RegisterFile signals
      rf_write   : out std_logic;
      rf_addr    : out std_logic_vector(4 downto 0);
      rf_val     : out std_logic_vector(31 downto 0);

      -- New entries (from decode stage)
      newentry_flag  : in std_logic; -- UB if using this while full
      newentry_store : in std_logic;

      ready : out std_logic;  -- If head == tail and !empty, then we are full
      tail  : out std_logic_vector(2 downto 0)
    );
    end component;
 
    -- buses
    signal addr_jump_2to3           :   std_logic_vector(31 downto 0);
    signal addr_jump_3to1           :   std_logic_vector(31 downto 0);
    
    signal addr_branch_3to4         :   std_logic_vector(31 downto 0);
    signal addr_branch_4to1         :   std_logic_vector(31 downto 0);
 
    signal pc_1toDRAM               :   std_logic_vector(31 downto 0);
    signal pc_up_1to2               :   std_logic_vector(31 downto 0);
    signal pc_up_2to3               :   std_logic_vector(31 downto 0);
    
    signal instruction_1to2         :   std_logic_vector(31 downto 0);
    signal opcode_2to3              :   std_logic_vector(5 downto 0);
    
    signal register_s_2to3          :   std_logic_vector(31 downto 0);
    signal register_t_2to3          :   std_logic_vector(31 downto 0);
    signal register_d_5to6          :   std_logic_vector(31 downto 0);
    signal register_d_6to2          :   std_logic_vector(31 downto 0);
    
    signal sign_ext_2to3            :   std_logic_vector(31 downto 0);
    signal zero_ext_2to3            :   std_logic_vector(31 downto 0);
    
    signal alu_res_3to4             :   std_logic_vector(31 downto 0);
    signal alu_res_4to5             :   std_logic_vector(31 downto 0);

    signal write_data_2to3          :   std_logic_vector(31 downto 0);
    signal write_data_3to4          :   std_logic_vector(31 downto 0);
    signal write_data_4to5          :   std_logic_vector(31 downto 0);
    
    signal addr_rs_2toCtrl          :   std_logic_vector(5 downto 0);
    signal addr_rt_2to3             :   std_logic_vector(5 downto 0);
    signal addr_rt_3toHazardCtrl    :   std_logic_vector(5 downto 0);
    signal addr_rd_2to3             :   std_logic_vector(5 downto 0);
    signal addr_regw_3to4           :   std_logic_vector(5 downto 0);
    signal addr_regw_4to5           :   std_logic_vector(5 downto 0);
    signal addr_regw_5to6           :   std_logic_vector(5 downto 0);
    signal addr_regw_6to2           :   std_logic_vector(5 downto 0);
    
    signal fwd_path_alu_3to2           :   std_logic_vector(31 downto 0);
    signal fwd_path_lookup_4to2        :   std_logic_vector(31 downto 0);
    signal fwd_path_cache_5to2and3and4 : std_logic_vector(31 downto 0);
    
    signal instCacheReady_1toCtrl   :   std_logic;
    signal dataCacheReady_4toCtrl   :   std_logic;
    
    -- control signals
    signal PCSrc_4to1               :   std_logic;
    
    signal RegWrite_2to3            :   std_logic;
    signal RegWrite_3to4            :   std_logic;
    signal RegWrite_4to5            :   std_logic;
    signal RegWrite_5to6            :   std_logic;
    signal RegWrite_6to2            :   std_logic;
    
    signal Jump_2to3                :   std_logic;
    signal Jump_3to1                :   std_logic;
    signal Jump_3toCtrl             :   std_logic;
    
    signal Branch_2to3              :   std_logic;
    signal Branch_3to4              :   std_logic;
    signal BranchTaken_4toCtrl      :   std_logic;
    
    signal RegDst_2to3              :   std_logic;
    signal ALUOp_2to3               :   std_logic_vector(2 downto 0);
    signal ALUSrc_2to3              :   std_logic;
    
    signal MemRead_2to3             :   std_logic;
    signal MemRead_3to4             :   std_logic;
    
    signal MemWrite_2to3            :   std_logic;
    signal MemWrite_3to4            :   std_logic;
    signal MemWrite_2toHazardCtrl   :   std_logic;
    
    signal ByteAddress_2to3         :   std_logic;
    signal ByteAddress_3to4         :   std_logic;
    signal ByteAddress_4to5         :   std_logic;
    signal WordAddress_2to3         :   std_logic;
    signal WordAddress_3to4         :   std_logic;
    signal WordAddress_4to5         :   std_logic;
    
    signal MemtoReg_2to3            :   std_logic;
    signal MemtoReg_3to4            :   std_logic;
    signal MemtoReg_4to5            :   std_logic;
    
    signal Zero_3to4                :   std_logic;
    
    signal Stall_HazardCtrltoLP     :   std_logic;
    signal Stall_HazardCtrlto1      :   std_logic;
    signal Stall_HazardCtrlto2      :   std_logic;
    signal Stall_HazardCtrlto3      :   std_logic;
    signal Stall_HazardCtrlto4      :   std_logic;
    
    signal fwd_aluRs_to2            :   std_logic_vector(1 downto 0);
    signal fwd_aluRt_to2            :   std_logic_vector(1 downto 0);
    signal fwd_alu_regmem_to2       :   std_logic_vector(1 downto 0);
    signal fwd_lookup_regmem_4to3   :   std_logic;
    signal fwd_cache_regmem_5to3    :   std_logic;
    
    signal NOP_HazardCtrltoLP       :   std_logic;
    signal NOP_HazardCtrlto1        :   std_logic;
    signal NOP_HazardCtrlto2        :   std_logic;
    signal NOP_HazardCtrlto3        :   std_logic;
    signal NOP_HazardCtrlto4        :   std_logic;
    signal NOP_HazardCtrlto5        :   std_logic;

    signal Exception_ExcepCtrlOut   :   std_logic;
    signal Interrupt_InterruptCtrltoHazaardCtrl : std_logic;
    signal Interrupt_ExceptionCtrlfromHazardCtrl : std_logic;

    signal WriteCache_4to5          :   std_logic;
    signal muxDataR_4to5            :   std_logic;
    signal muxDataW_4to5            :   std_logic;
    
    --------------------------------
    ---    Long Pipe Signals     ---
    --------------------------------
    
    signal lp_rs       : std_logic_vector(31 downto 0);
    signal lp_rt       : std_logic_vector(31 downto 0);
    signal lp_addr_rd  : std_logic_vector(4 downto 0);
    signal lp_addr_regw: std_logic_vector(4 downto 0);
    signal lp_doinst   : std_logic;
    signal lp_write_data_out : std_logic_vector(31 downto 0);
    signal lp_write_output   : std_logic;
    signal lp_Stall    : std_logic;
    
    --------------------------------
     ---     Memory Interface      --
    --------------------------------
    signal busRdDataMem             :   std_logic_vector(127 downto 0);
    signal busWrDataMem             :   std_logic_vector(31 downto 0);
    signal busAddr                  :   std_logic_vector(31 downto 0);
    signal BusRd_1toDRAM            :   std_logic;
    signal BusRd_4toDRAM            :   std_logic;
    signal BusRd                    :   std_logic;
    signal BusWr_1toDRAM            :   std_logic;
    signal BusWr_4toDRAM            :   std_logic;
    signal BusWr                    :   std_logic;
    signal BusReady_DRAMto1         :   std_logic;
    signal BusReady_DRAMto5         :   std_logic;
    signal BusReady                 :   std_logic;
    
    --------------------------------
    -- All the exceptions signals --
    --------------------------------
    
    -- IF exception
    signal exception_if_at_if       :   std_logic;
    signal exception_if_at_id       :   std_logic;
    signal exception_if_at_exe      :   std_logic;
    signal exception_if_at_lookup   :   std_logic;
    signal exception_if_at_cache    :   std_logic;
  
    -- ID exception
    signal exception_id_at_id       :   std_logic;
    signal exception_id_at_exe      :   std_logic;
    signal exception_id_at_lookup   :   std_logic;
    signal exception_id_at_cache    :   std_logic;

    -- EXE exception
    signal exception_exe_at_exe     :   std_logic;
    signal exception_exe_at_lookup  :   std_logic;
    signal exception_exe_at_cache   :   std_logic;

    -- LOOKUP exception
    signal exception_lookup_at_lookup :   std_logic;
    signal exception_lookup_at_cache  :   std_logic;

    -- CACHE exception
    signal exception_cache_at_cache :   std_logic;

    -- BadVAddr register
    signal Exc_BadVAddr_at_if       :   std_logic_vector(31 downto 0);
    signal Exc_BadVAddr_at_id       :   std_logic_vector(31 downto 0);
    signal Exc_BadVAddr_at_exe      :   std_logic_vector(31 downto 0);
    signal Exc_BadVAddr_at_lookup   :   std_logic_vector(31 downto 0);
    signal Exc_BadVAddr_at_cache    :   std_logic_vector(31 downto 0);
    --signal Exc_BadVAddr_at_wb       :   std_logic_vector(31 downto 0);
    signal Exc_BadVAddr_to_id       :   std_logic_vector(31 downto 0); -- write to register file
  
    -- Cause register
    signal Exc_Cause_at_if          :   std_logic_vector(31 downto 0);
    signal Exc_Cause_at_id          :   std_logic_vector(31 downto 0);
    signal Exc_Cause_at_exe         :   std_logic_vector(31 downto 0);
    signal Exc_Cause_at_lookup      :   std_logic_vector(31 downto 0);
    signal Exc_Cause_at_cache       :   std_logic_vector(31 downto 0);
    --signal Exc_Cause_at_wb          :   std_logic_vector(31 downto 0);
    signal Exc_Cause_to_id          :   std_logic_vector(31 downto 0); -- write to register file
  
    -- EPC register
    signal Exc_EPC_at_if            :   std_logic_vector(31 downto 0);
    signal Exc_EPC_at_id            :   std_logic_vector(31 downto 0);
    signal Exc_EPC_at_exe           :   std_logic_vector(31 downto 0);
    signal Exc_EPC_at_lookup        :   std_logic_vector(31 downto 0);
    signal Exc_EPC_at_cache         :   std_logic_vector(31 downto 0);
    --signal Exc_EPC_at_wb            :   std_logic_vector(31 downto 0);
    signal Exc_EPC_to_id            :   std_logic_vector(31 downto 0); -- write to register file
    
    -- The stuff for the ReOrderBuffer
    signal ROB_Update_ToROB         :   std_logic;
    signal ROB_Ready_FromROB        :   std_logic;
    signal ROB_tail                 :   std_logic_vector(2 downto 0);
    signal ROB_except_flag          :   std_logic;
    signal ROB_except_addr          :   std_logic_vector(2 downto 0);
    signal ROB_value_flag           :   std_logic;
    signal ROB_value_addr           :   std_logic_vector(2 downto 0);
    signal ROB_value_alu            :   std_logic_vector(31 downto 0);
    signal ROB_value_mem            :   std_logic_vector(31 downto 0);
    signal ROB_rf_write             :   std_logic;
    signal ROB_rf_addr              :   std_logic_vector(4 downto 0);
    signal ROB_rf_val               :   std_logic_vector(31 downto 0);
    signal ROB_newentry_store       :   std_logic;

  
    -- The signals from exception_ctrl to writeback
    signal writeEPC_to_wb           :   std_logic;
    signal writeBadVAddr_to_wb      :   std_logic;
    signal writeCause_to_wb         :   std_logic;
    -- The signals pipelined into the IF (exception register file)
    signal writeEPC_to_id           :   std_logic;
    signal writeBadVAddr_to_id      :   std_logic;
    signal writeCause_to_id         :   std_logic;
    
    signal Exception_IFJump         :   std_logic;
    signal interrupt_clear          :   std_logic;

begin

    first_stage :   instruction_fetch
    port map(addr_jump          => addr_jump_3to1,
             addr_branch        => addr_branch_4to1,
             pc                 => pc_1toDRAM,
             pc_up              => pc_up_1to2,
             instruction        => instruction_1to2,
             busDataMem         => busRdDataMem,
             clk                => clk,
             boot               => boot,
             Jump               => Jump_3to1,
             PCSrc              => PCSrc_4to1,
             ExceptionJump      => Exception_IFJump,
             IC_Ready           => instCacheReady_1toCtrl,
             NOP_to_ID          => NOP_HazardCtrlto1,
             Stall              => Stall_HazardCtrlto1,
             BusRd              => BusRd_1toDRAM,
             BusWr              => BusWr_1toDRAM,
             BusReady           => BusReady_DRAMto1,
             -- exceptions
             exception_if       => exception_if_at_if,
             Exc_BadVAddr_out   => Exc_BadVAddr_at_if,
             Exc_Cause_out      => Exc_Cause_at_if,
             Exc_EPC_out        => Exc_EPC_at_if);

    second_stage    :   instruction_decode 
    port map(instruction        => instruction_1to2,
             addr_jump          => addr_jump_2to3,
             pc_up_in           => pc_up_1to2,
             pc_up_out          => pc_up_2to3,
             opcode             => opcode_2to3,
             rs                 => register_s_2to3,
             rt                 => register_t_2to3,
             rd                 => register_d_6to2,
             sign_ext           => sign_ext_2to3,
             zero_ext           => zero_ext_2to3,
             addr_rs            => addr_rs_2toCtrl,
             addr_rt            => addr_rt_2to3,
             addr_rd            => addr_rd_2to3,
             write_data         => write_data_2to3,
             addr_regw          => addr_regw_6to2,
             fwd_path_alu       => fwd_path_alu_3to2,
             fwd_path_lookup    => fwd_path_lookup_4to2,
             fwd_path_cache     => fwd_path_cache_5to2and3and4,
             -- the long pipe, a bit special
             lp_rs              => lp_rs,
             lp_rt              => lp_rt,
             lp_addr_rd         => lp_addr_rd,
             lp_doinst          => lp_doinst,
             -- --
             clk                => clk,
             RegWrite_out       => RegWrite_2to3,
             Jump               => Jump_2to3,
             Branch             => Branch_2to3,
             MemRead            => MemRead_2to3,
             MemWrite           => MemWrite_2to3,
             MemWriteHazard     => MemWrite_2toHazardCtrl,
             ByteAddress        => ByteAddress_2to3,
             WordAddress        => WordAddress_2to3,
             MemtoReg           => MemtoReg_2to3,
             RegDst             => RegDst_2to3,
             ALUOp              => ALUOp_2to3,
             ALUSrc             => ALUSrc_2to3,
             RegWrite_in        => RegWrite_6to2,
             fwd_aluRs          => fwd_aluRs_to2,
             fwd_aluRt          => fwd_aluRt_to2,
             fwd_alu_regmem     => fwd_alu_regmem_to2,
             NOP_to_EXE         => NOP_HazardCtrlto2,
             Stall              => Stall_HazardCtrlto2,
             -- exceptions
             exception_if_in    => exception_if_at_if,
             exception_if_out   => exception_if_at_id,
             exception_id       => exception_id_at_id,
             -- exception buses
             Exc_BadVAddr_in    => Exc_BadVAddr_at_if,
             Exc_BadVAddr_out   => Exc_BadVAddr_at_id,
             Exc_Cause_in       => Exc_Cause_at_if,
             Exc_Cause_out      => Exc_Cause_at_id,
             Exc_EPC_in         => Exc_EPC_at_if,
             Exc_EPC_out        => Exc_EPC_at_id,
             -- coprocessor 0 exception-related              
             Exc_BadVAddr_to_regfile   => Exc_BadVAddr_to_id, --Exc_BadVAddr_at_wb,
             Exc_Cause_to_regfile      => Exc_Cause_to_id, --Exc_Cause_at_wb,
             Exc_EPC_to_regfile        => Exc_EPC_to_id, --Exc_EPC_at_wb,
             writeBadVAddr_to_regfile  => writeBadVAddr_to_id,
             writeCause_to_regfile     => writeCause_to_id,
             writeEPC_to_regfile       => writeEPC_to_id);
    
    third_stage :   execute
    port map(pc_up              => pc_up_2to3,
             opcode             => opcode_2to3,
             rs                 => register_s_2to3,
             rt                 => register_t_2to3,
             sign_ext           => sign_ext_2to3,
             zero_ext           => zero_ext_2to3,
             addr_rt_in         => addr_rt_2to3,
             addr_rt_out        => addr_rt_3toHazardCtrl,
             addr_rd            => addr_rd_2to3,
             addr_jump_in       => addr_jump_2to3,
             addr_jump_out      => addr_jump_3to1,
             addr_branch        => addr_branch_3to4,
             alu_res            => alu_res_3to4,
             write_data_in      => write_data_2to3,
             write_data_out     => write_data_3to4,
             addr_regw          => addr_regw_3to4,
             fwd_path_alu       => fwd_path_alu_3to2,
             fwd_path_lookup    => fwd_path_lookup_4to2,
             fwd_path_cache     => fwd_path_cache_5to2and3and4,
             clk                => clk,
             RegWrite_in        => RegWrite_2to3,
             RegWrite_out       => RegWrite_3to4,
             Jump_in            => Jump_2to3,
             Jump_out           => Jump_3to1,
             Branch_in          => Branch_2to3,
             Branch_out         => Branch_3to4,
             MemRead_in         => MemRead_2to3,
             MemRead_out        => MemRead_3to4,
             MemWrite_in        => MemWrite_2to3,
             MemWrite_out       => MemWrite_3to4,
             ByteAddress_in     => ByteAddress_2to3,
             ByteAddress_out    => ByteAddress_3to4,
             WordAddress_in     => WordAddress_2to3,
             WordAddress_out    => WordAddress_3to4,
             MemtoReg_in        => MemtoReg_2to3,
             MemtoReg_out       => MemtoReg_3to4,
             RegDst             => RegDst_2to3,
             ALUOp              => ALUOp_2to3,
             ALUSrc             => ALUSrc_2to3,
             Zero               => Zero_3to4,
             fwd_lookup_regmem  => fwd_lookup_regmem_4to3,
             fwd_cache_regmem   => fwd_cache_regmem_5to3,
             NOP_to_L           => NOP_HazardCtrlto3,
             Stall              => Stall_HazardCtrlto3,
             -- exceptions
             exception_if_in    => exception_if_at_id,
             exception_if_out   => exception_if_at_exe,
             exception_id_in    => exception_id_at_id,
             exception_id_out   => exception_id_at_exe,
             exception_exe      => exception_exe_at_exe,
             -- exception buses
             Exc_BadVAddr_in    => Exc_BadVAddr_at_id,
             Exc_BadVAddr_out   => Exc_BadVAddr_at_exe,
             Exc_Cause_in       => Exc_Cause_at_id,
             Exc_Cause_out      => Exc_Cause_at_exe,
             Exc_EPC_in         => Exc_EPC_at_id,
             Exc_EPC_out        => Exc_EPC_at_exe);


           --  write_data_mem      => write_data_3to4,
           --  write_data_rb       => register_d_4to5,
             
    fourth_stage   : lookup
    port map(addr_branch_in     => addr_branch_3to4,
             addr_branch_out    => addr_branch_4to1,
             addr_in            => alu_res_3to4,
             addr_out           => alu_res_4to5,
             write_data_mem_in  => write_data_3to4,
             write_data_mem_out => write_data_4to5,
             addr_regw_in       => addr_regw_3to4,
             addr_regw_out      => addr_regw_4to5,
             fwd_path_lookup    => fwd_path_lookup_4to2,
             clk                => clk,
             boot               => boot,
             RegWrite_in        => RegWrite_3to4,
             RegWrite_out       => RegWrite_4to5,
             Branch             => Branch_3to4,
             BranchTaken        => BranchTaken_4toCtrl,
             PCSrc              => PCSrc_4to1,
             MemRead            => MemRead_3to4,
             MemWrite           => MemWrite_3to4,
             ByteAddress_in     => ByteAddress_3to4,
             ByteAddress_out    => ByteAddress_4to5,
             WordAddress_in     => WordAddress_3to4,
             WordAddress_out    => WordAddress_4to5,
             MemtoReg_in        => MemtoReg_3to4,
             MemtoReg_out       => MemtoReg_4to5,
             Zero               => Zero_3to4,
             WriteCache         => WriteCache_4to5,
             muxDataR           => muxDataR_4to5,
             muxDataW           => muxDataW_4to5,
             BusRd              => BusRd_4toDRAM,
             BusWr              => BusWr_4toDRAM,
             BusReady           => BusReady_DRAMto5,
             DC_Ready           => dataCacheReady_4toCtrl,
             NOP_to_C           => NOP_HazardCtrlto4,
             Stall              => Stall_HazardCtrlto4,
             -- exception bits
             exception_if_in    => exception_if_at_exe,
             exception_if_out   => exception_if_at_lookup,
             exception_id_in    => exception_id_at_exe,
             exception_id_out   => exception_id_at_lookup,
             exception_exe_in   => exception_exe_at_exe,
             exception_exe_out  => exception_exe_at_lookup,
             exception_lookup   => exception_lookup_at_lookup,
             -- Exception-related registers
             Exc_BadVAddr_in    => Exc_BadVAddr_at_exe,
             Exc_BadVAddr_out   => Exc_BadVAddr_at_lookup,
             Exc_Cause_in       => Exc_Cause_at_exe,
             Exc_Cause_out      => Exc_Cause_at_lookup,
             Exc_EPC_in         => Exc_EPC_at_exe,
             Exc_EPC_out        => Exc_EPC_at_lookup );

    fifth_stage : cache
    port map(addr               => alu_res_4to5,
             write_data_mem     => write_data_4to5, 
             addr_regw_in       => addr_regw_4to5,
             addr_regw_out      => addr_regw_5to6,
                write_data_reg     => register_d_5to6,
             fwd_path_cache     => fwd_path_cache_5to2and3and4,
             busDataMem         => busRdDataMem,
             clk                => clk,
             RegWrite_in        => RegWrite_4to5,
             RegWrite_out       => RegWrite_5to6,
                ByteAddress        => ByteAddress_4to5,
             WordAddress        => WordAddress_4to5,
                MemtoReg           => MemtoReg_4to5,
                WriteCache         => WriteCache_4to5,
             muxDataR           => muxDataR_4to5,
             muxDataW           => muxDataW_4to5,
             NOP_to_WB          => NOP_HazardCtrlto5,
                -- exception bits
             exception_if_in    => exception_if_at_lookup,
             exception_if_out   => exception_if_at_cache,
             exception_id_in    => exception_id_at_lookup,
             exception_id_out   => exception_id_at_cache,
             exception_exe_in   => exception_exe_at_lookup,
             exception_exe_out  => exception_exe_at_cache,
             exception_lookup_in  => exception_lookup_at_lookup,
                exception_lookup_out => exception_lookup_at_cache,
                exception_cache    => exception_cache_at_cache,
             -- Exception-related registers
             Exc_BadVAddr_in    => Exc_BadVAddr_at_lookup,
             Exc_BadVAddr_out   => Exc_BadVAddr_at_cache,
             Exc_Cause_in       => Exc_Cause_at_lookup,
             Exc_Cause_out      => Exc_Cause_at_cache,
             Exc_EPC_in         => Exc_EPC_at_lookup,
             Exc_EPC_out        => Exc_EPC_at_cache );
             
    sixth_stage :   write_back
    port map(write_data_in      => register_d_5to6,
             write_data_out     => register_d_6to2,
             addr_regw_in       => addr_regw_5to6,
             addr_regw_out      => addr_regw_6to2,
             clk                => clk,
             RegWrite_in        => RegWrite_5to6,
             RegWrite_out       => RegWrite_6to2,
             -- exception buses
             Exc_BadVAddr_in    => Exc_BadVAddr_at_cache,
             Exc_BadVAddr_out   => Exc_BadVAddr_to_id,
             Exc_Cause_in       => Exc_Cause_at_cache,
             Exc_Cause_out      => Exc_Cause_to_id,
             Exc_EPC_in         => Exc_EPC_at_cache,
             Exc_EPC_out        => Exc_EPC_to_id,
             -- write enable for exception registers
             writeEPC_in        => writeEPC_to_wb,
             writeEPC_out       => writeEPC_to_id,
             writeBadVAddr_in   => writeBadVAddr_to_wb,
             writeBadVAddr_out  => writeBadVAddr_to_id,
             writeCause_in      => writeCause_to_wb,
             writeCause_out     => writeCause_to_id);

    long_pipe_stage : long_pipe
    port map(rs             => lp_rs,
             rt             => lp_rt,
             addr_rd        => lp_addr_rd,
             write_data_out => lp_write_data_out,
             addr_regw      => lp_addr_regw,
             -- control signals
             clk            => clk,
             Stall          => lp_Stall,
             doinstruction  => lp_doinst,
             write_output   => lp_write_output);

    -- ARBITRER SUPER BASTO (Ignorem la IC, prioritat a la DC)
    busWrDataMem <= x"00000000";
    busAddr <= alu_res_4to5 when (BusRd_4toDRAM = '1' or BusWr_4toDRAM = '1') else
               pc_1toDRAM; 
    BusRd   <= BusRd_4toDRAM when (BusRd_4toDRAM = '1' or BusWr_4toDRAM = '1') else
               BusRd_1toDRAM;
    BusWr   <= BusWr_4toDRAM when (BusRd_4toDRAM = '1' or BusWr_4toDRAM = '1') else
               BusWr_1toDRAM;

    BusReady_DRAMto1 <= '0' when (BusRd_4toDRAM = '1' or BusWr_4toDRAM = '1') else
                        BusReady;
    BusReady_DRAMto5 <= BusReady;
     
    DRAM : main_mem
     port map(addr               => busAddr,
             write_data         => busWrDataMem, -- OBS: We never write Global mem, IC don't write and DC don't do refill operations
             read_data          => busRdDataMem,
             Rd                 => BusRd,
             Wr                 => BusWr,
             Ready              => BusReady,
             reset              => boot,
             clk                => clk);
    
    
    Jump_3toCtrl <= Jump_3to1;
    hazard_contol_logic : hazard_ctrl
    port map(idRegisterRs       => addr_rs_2toCtrl,
             idRegisterRt       => addr_rt_2to3,
             exeRegisterRt      => addr_rt_3toHazardCtrl, --this is addr_rt
             exeMemRead         => MemRead_3to4,
             Branch             => BranchTaken_4toCtrl,
             Jump               => Jump_3toCtrl,
             Exception          => Exception_ExcepCtrlOut,
             Interrupt          => Interrupt_InterruptCtrltoHazaardCtrl,
                 Interrupt_to_Exception_ctrl => Interrupt_ExceptionCtrlfromHazardCtrl,
             ROB_Ready          => ROB_Ready_FromROB,
             ROB_Update         => ROB_Update_ToROB,
             IC_Ready           => instCacheReady_1toCtrl,
             DC_Ready           => dataCacheReady_4toCtrl,
             Stall_LP           => Stall_HazardCtrltoLP,
             Stall_PC           => Stall_HazardCtrlto1,
             Stall_IF_ID        => Stall_HazardCtrlto2,
             Stall_ID_EXE       => Stall_HazardCtrlto3,
             Stall_EXE_LOOKUP   => Stall_HazardCtrlto4,
             NOP_to_LP          => NOP_HazardCtrltoLP,
             NOP_to_ID          => NOP_HazardCtrlto1,
             NOP_to_EXE         => NOP_HazardCtrlto2,
             NOP_to_L           => NOP_HazardCtrlto3,
             NOP_to_C           => NOP_HazardCtrlto4,
             NOP_to_WB          => NOP_HazardCtrlto5);

    
    forwarding_control_logic : forwarding_ctrl 
    port map(idRegisterRs       => addr_rs_2toCtrl,
             idRegisterRt       => addr_rt_2to3,
             exeRegisterRd      => addr_regw_3to4,
             exeRegisterRt      => addr_rt_3toHazardCtrl,
             tagRegisterRd      => addr_regw_4to5,
             dcaRegisterRd      => addr_regw_5to6,
             exeRegWrite        => RegWrite_3to4,
             tagRegWrite        => RegWrite_4to5,
             dcaRegWrite        => RegWrite_5to6,
             idMemWrite         => MemWrite_2toHazardCtrl,
             exeMemWrite        => MemWrite_3to4,
             fwd_aluRs          => fwd_aluRs_to2,
             fwd_aluRt          => fwd_aluRt_to2,
             fwd_alu_regmem     => fwd_alu_regmem_to2,
             fwd_lookup_regmem  => fwd_lookup_regmem_4to3,
             fwd_cache_regmem   => fwd_cache_regmem_5to3); 
                
    exception_control_logic : exception_ctrl
    port map(exception_if       => exception_if_at_cache,
             exception_id       => exception_id_at_cache,
             exception_exe      => exception_exe_at_cache,
             exception_lookup   => exception_lookup_at_cache,
             exception_cache    => exception_cache_at_cache,
             exception_interrupt=> Interrupt_ExceptionCtrlfromHazardCtrl,
             exception_flag     => Exception_ExcepCtrlOut,
             exception_jump     => Exception_IFJump,
             wbexc_writeEPC      => writeEPC_to_wb,
             wbexc_writeBadVAddr => writeBadVAddr_to_wb,
             wbexc_writeCause    => writeCause_to_wb); 
       
    rob_control_logic : rob_ctrl
    port map (clk   => clk,
          boot  => boot,
          except_flag => ROB_except_flag,
          except_addr => ROB_except_addr,
          value_flag => ROB_value_flag,
          value_addr => ROB_value_addr,
          value_alu  => ROB_value_alu,
          value_mem  => ROB_value_mem,
          rf_write   => ROB_rf_write,
          rf_addr    => ROB_rf_addr,
          rf_val     => ROB_rf_val,
          newentry_flag  => ROB_Update_ToROB,
          newentry_store => ROB_newentry_store,
          ready => ROB_Ready_FromROB,
          tail  => ROB_tail);

    interrupts_control_logic : interrupt_ctrl
    port map(interrupt          => external_interrupt,
             int_clear          => '0', -- interrupt_clear,
             int_flag           => Interrupt_InterruptCtrltoHazaardCtrl,
             clk                => clk,
             boot               => boot ); 
     
end Structure;
