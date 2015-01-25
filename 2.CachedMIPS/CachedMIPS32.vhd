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
          addr_regw       :   in  std_logic_vector(4 downto 0);   --from WB
          fwd_path_alu    :   in  std_logic_vector(31 downto 0);  --from ALU    [FWD]
          fwd_path_lookup :   in  std_logic_vector(31 downto 0);  --from LOOKUP [FWD]
          fwd_path_cache  :   in  std_logic_vector(31 downto 0);  --from CACHE  [FWD]
          fwd_path_rob_rs :   in  std_logic_vector(31 downto 0);  --from ROB    [FWD]
          fwd_path_rob_rt :   in  std_logic_vector(31 downto 0);  --from ROB    [FWD]
          fwd_path_rob_rt_mem : in std_logic_vector(31 downto 0); --form ROB    [FWD]
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
          FreeSlot        :   out std_logic;                      --to EXE,LOOKUP (ROB will check in L if a store can be introduced)
          ALUOp           :   out std_logic_vector(2 downto 0);   --to EXE
          ALUSrc          :   out std_logic;                      --to EXE
          RegWrite_in     :   in  std_logic;                      --from WB   
          fwd_aluRs       :   in  std_logic_vector(2 downto 0);   --from FWD Ctrl
          fwd_aluRt       :   in  std_logic_vector(2 downto 0);   --from FWD Ctrl
          fwd_alu_regmem  :   in  std_logic_vector(2 downto 0);   --from FWD Ctrl 
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
          addr_rt_out         :   out std_logic_vector(5 downto 0);   --to FWD Control
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
          rob_addr_in         :   in  std_logic_vector(2 downto 0);   --ReOrder Buffer pipelined
          rob_addr_out        :   out std_logic_vector(2 downto 0);
          -- control signals
          clk                 :   in  std_logic;
          RegWrite_in         :   in  std_logic;                      --from ID
          RegWrite_out        :   out std_logic;                      --to LOOKUP,CACHE,WB, then ID
          RegWrite_rob        :   out std_logic;                      --to ROB
          Jump_in             :   in  std_logic;                      --from ID
          Jump_out            :   out std_logic;                      --to IF
          Branch_in           :   in  std_logic;                      --from ID
          Branch_out          :   out std_logic;                      --to LOOKUP
          MemRead_in          :   in  std_logic;                      --from ID 
          MemRead_out         :   out std_logic;                      --to LOOKUP
          MemWrite_in         :   in  std_logic;                      --from ID  
          MemWrite_out        :   out std_logic;                      --to LOOKUP 
          MemWrite_rob        :   out std_logic;                      --to ROB    
          ByteAddress_in      :   in  std_logic;                      --from ID
          ByteAddress_out     :   out std_logic;                      --from LOOKUP
          WordAddress_in      :   in  std_logic;                      --from ID
          WordAddress_out     :   out std_logic;                      --from LOOKUP  
          MemtoReg_in         :   in  std_logic;                      --from EXE
          MemtoReg_out        :   out std_logic;                      --to LOOKUP,CACHE,WB
          RegDst              :   in  std_logic;                      --from ID
          FreeSlot_in         :   in  std_logic;                      --from ID
          FreeSlot_out        :   out std_logic;                      --to LOOKUP (ROB)
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
          rob_addr_in        : in  std_logic_vector(2 downto 0);   --ReOrder Buffer pipelined
          rob_addr_out       : out std_logic_vector(2 downto 0);
          busWrDataMemWrite  : out std_logic_vector(31 downto 0);  --to DRAM 
          busAddrDC          : out std_logic_vector(31 downto 0);  --to DRAM
          -- control signals
          clk                : in  std_logic;
          boot               : in  std_logic;
          RegWrite_in        : in  std_logic;                      --from EXE
          RegWrite_out       : out std_logic;                      --to CACHE,WB, then ID
          Branch             : in  std_logic;                      --from EXE
          BranchTaken        : out std_logic;                      --to control (identify end of branch stall)
          PCSrc              : out std_logic;                      --to ID
          MemRead            : in  std_logic;                      --from EXE
          MemRead_out        : out std_logic;                      --to Hazard Control (we need to wait in case of a Load dependences)
          MemWrite           : in  std_logic;                      --from EXE
          ByteAddress_in     : in  std_logic;                      --from EXE
          ByteAddress_out    : out std_logic;                      --to CACHE
          WordAddress_in     : in  std_logic;                      --from EXE
          WordAddress_out    : out std_logic;                      --to CACHE
          MemtoReg_in        : in  std_logic;                      --from EXE
          MemtoReg_out       : out std_logic;                      --to CACHE
          FreeSlot_in        : in  std_logic;                      --from EXE
          FreeSlot_out       : out std_logic;                      --to (ROB)
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
          rob_addr_in          : in  std_logic_vector(2 downto 0);   --ReOrder Buffer pipelined
          rob_addr_out         : out std_logic_vector(2 downto 0);
          -- control signals
          clk                  : in  std_logic;
          RegWrite_in          : in  std_logic;                      --from LOOKUP
          RegWrite_out         : out std_logic;                      --to WB, ID
          ByteAddress          : in  std_logic;                      --from LOOKUP
          WordAddress          : in  std_logic;                      --from LOOKUP
          MemtoReg             : in  std_logic;                      --from LOOKUP
             FreeSlot_in          : in  std_logic;                      --from LOOKUP
             FreeSlot_out         : out std_logic;                      --to Forward Control
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
          rob_addr         : in  std_logic_vector(2 downto 0);   --ReOrder Buffer pipelined
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
            rob_addr_in     :   in  std_logic_vector(2 downto 0);   --ReOrder Buffer pipelined
            rob_addr_out    :   out std_logic_vector(2 downto 0);
            -- control signals
            clk             :   in std_logic;
            boot            :   in std_logic;
            Stall           :   in std_logic;
            doinstruction   :   in  std_logic;
            write_output    :   out std_logic);
    end component;
    
    component main_mem is
    port (-- data buses
          addrIC       : in  std_logic_vector(31 downto 0); 
          write_dataIC : in  std_logic_vector(31 downto 0);
          read_dataIC  : out std_logic_vector(127 downto 0);
          addrDC       : in  std_logic_vector(31 downto 0); 
          write_dataDC : in  std_logic_vector(31 downto 0);
          read_dataDC  : out std_logic_vector(127 downto 0);
          -- control signals
          busRdIC      : in  std_logic;
          busWrIC      : in  std_logic;
          busReadyIC   : out std_logic;
          busRdDC      : in  std_logic;
          busWrDC      : in  std_logic;
          busReadyDC   : out std_logic;
          reset        : in  std_logic;
          clk          : in  std_logic);
    end component;

    component hazard_ctrl is
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
    end component;
    
    component forwarding_ctrl is
    port (idRegisterRs      : in  std_logic_vector(5 downto 0);  --consumer
          idRegisterRt      : in  std_logic_vector(5 downto 0);  --consumer
          exeRegisterRd     : in  std_logic_vector(5 downto 0);  --producer
          exeRegisterRt     : in  std_logic_vector(5 downto 0);  --producer
          tagRegisterRd     : in  std_logic_vector(5 downto 0);  --producer "tag -> LOOKUP stage"
             dcaRegisterRd     : in  std_logic_vector(5 downto 0);  --producer "dca == data cache -> CACHE stage"
          robRegisterRd0    : in  std_logic_vector(5 downto 0);  --producer ROB entrada 0 
          robRegisterRd1    : in  std_logic_vector(5 downto 0);  --producer ROB entrada 1 
          robRegisterRd2    : in  std_logic_vector(5 downto 0);  --producer ROB entrada 2 
          robRegisterRd3    : in  std_logic_vector(5 downto 0);  --producer ROB entrada 3 
          robRegisterRd4    : in  std_logic_vector(5 downto 0);  --producer ROB entrada 4 
          robRegisterRd5    : in  std_logic_vector(5 downto 0);  --producer ROB entrada 5 
          robRegisterRd6    : in  std_logic_vector(5 downto 0);  --producer ROB entrada 6 
          robRegisterRd7    : in  std_logic_vector(5 downto 0);  --producer ROB entrada 7 
             robMatchIdRs_out  : out std_logic_vector(2 downto 0);
             robMatchIdRt_out  : out std_logic_vector(2 downto 0);
             robMatchIdRt_mem_out : out std_logic_vector(2 downto 0);
          exeRegWrite       : in  std_logic;
          tagRegWrite       : in  std_logic;
             dcaRegWrite       : in  std_logic;
             robRegWrite0      : in  std_logic;
             robRegWrite1      : in  std_logic;
             robRegWrite2      : in  std_logic;
             robRegWrite3      : in  std_logic;
             robRegWrite4      : in  std_logic;
             robRegWrite5      : in  std_logic;
             robRegWrite6      : in  std_logic;
             robRegWrite7      : in  std_logic;
          idMemWrite        : in  std_logic;
          exeMemWrite       : in  std_logic;
             FreeSlotL         : in  std_logic; -- If NO instruction is in L stage don't forward from that 
             FreeSlotC         : in  std_logic; -- If NO instruction is in C stage don't forward from that
          robTail           : in  std_logic_vector(2 downto 0);
          fwd_aluRs         : out std_logic_vector(2 downto 0);
          fwd_aluRt         : out std_logic_vector(2 downto 0);
          fwd_alu_regmem    : out std_logic_vector(2 downto 0);
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

        -- 2 WRITE PORTS to allow this:
        --   LOAD :  F D E L C    Wrob   <- Write from cache
        --   arit      F D E Wrob 
        --   arit        F D E    Wrob   <- write from ALU
        
      -- FIRST PORT
      value_flag_exe   : in std_logic;
      value_robid_exe  : in std_logic_vector(2 downto 0);
      value_alu        : in std_logic_vector(31 downto 0); -- Value from alu when commiting an Aritmetic operation
        
        -- SECOND PORT
        value_flag_cache  : in std_logic;
        value_robid_cache : in std_logic_vector(2 downto 0);
      value_cache       : in std_logic_vector(31 downto 0);  -- Value from Cache when commiting a LOAD operation 

      -- To-RegisterFile signals
      rf_write   : out std_logic;
      rf_addr    : out std_logic_vector(4 downto 0);
      rf_val     : out std_logic_vector(31 downto 0);

      -- New entries (from decode stage)
      newentry_flag  : in std_logic; -- UB if using this while full
      newentry_store : in std_logic;
      newentry_load  : in std_logic; -- mutually exclusive with store
      newentry_regaddr : in std_logic_vector(5 downto 0);

      robRegisterRd0        : out  std_logic_vector(5 downto 0);  --producer ROB entrada 0 
      robRegisterRd1        : out  std_logic_vector(5 downto 0);  --producer ROB entrada 1 
      robRegisterRd2        : out  std_logic_vector(5 downto 0);  --producer ROB entrada 2 
      robRegisterRd3        : out  std_logic_vector(5 downto 0);  --producer ROB entrada 3 
      robRegisterRd4        : out  std_logic_vector(5 downto 0);  --producer ROB entrada 4 
      robRegisterRd5        : out  std_logic_vector(5 downto 0);  --producer ROB entrada 5 
      robRegisterRd6        : out  std_logic_vector(5 downto 0);  --producer ROB entrada 6 
      robRegisterRd7        : out  std_logic_vector(5 downto 0);  --producer ROB entrada 7 
        robMatchIdRs_in       : in std_logic_vector(2 downto 0);
        robMatchIdRt_in       : in std_logic_vector(2 downto 0);
        robMatchIdRt_mem_in   : in std_logic_vector(2 downto 0);
        robRegWrite0          : out  std_logic;
        robRegWrite1          : out  std_logic;
        robRegWrite2          : out  std_logic;
        robRegWrite3          : out  std_logic;
        robRegWrite4          : out  std_logic;
        robRegWrite5          : out  std_logic;
        robRegWrite6          : out  std_logic;
        robRegWrite7          : out  std_logic;
      fwd_path_rob_rs       : out std_logic_vector(31 downto 0); 
        fwd_path_rob_rt       : out std_logic_vector(31 downto 0);
        fwd_path_rob_rt_mem   : out std_logic_vector(31 downto 0);
        
        FreeSlot  : in std_logic; -- From LOOKUP stage. (1: L stage can be populated with an Store, 0: otherwise)
        
        robLoadStoreDep       : out std_logic; -- To Hazard_ctrl
        lookup_load_addr      : in  std_logic_vector(31 downto 0); -- Addres of a load in Lookup stage
        
      ready : out std_logic;  -- If head == tail and !empty, then we are full
      tail  : out std_logic_vector(2 downto 0)
    );
    end component;
 
    -- buses
    signal addr_jump_2to3           :   std_logic_vector(31 downto 0);
    signal addr_jump_3to1           :   std_logic_vector(31 downto 0);
    
    signal addr_branch_3to4         :   std_logic_vector(31 downto 0);
    signal addr_branch_4to1         :   std_logic_vector(31 downto 0);
 
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
     signal addr_rt_3toCtrl          :   std_logic_vector(5 downto 0);
    signal addr_rd_2to3             :   std_logic_vector(5 downto 0);
    signal addr_regw_3to4           :   std_logic_vector(5 downto 0);
    signal addr_regw_4to5           :   std_logic_vector(5 downto 0);
    signal addr_regw_5to6           :   std_logic_vector(5 downto 0);
    signal addr_regw_6to2           :   std_logic_vector(5 downto 0);
    
    signal fwd_path_alu_3to2           :   std_logic_vector(31 downto 0);
    signal fwd_path_lookup_4to2        :   std_logic_vector(31 downto 0);
    signal fwd_path_cache_5to2and3and4 :   std_logic_vector(31 downto 0);
    signal fwd_path_rob_rs             :   std_logic_vector(31 downto 0);
    signal fwd_path_rob_rt             :   std_logic_vector(31 downto 0);
    signal fwd_path_rob_rt_mem         :   std_logic_vector(31 downto 0);
     
    signal instCacheReady_1toCtrl   :   std_logic;
    signal dataCacheReady_4toCtrl   :   std_logic;
    
    signal rob_addr_EXE_L           :   std_logic_vector(2 downto 0);
    signal rob_addr_L_C             :   std_logic_vector(2 downto 0);
    signal rob_addr_C_WB            :   std_logic_vector(2 downto 0);
    signal rob_addr_fromLP          :   std_logic_vector(2 downto 0);
    
    -- control signals
    signal PCSrc_4to1               :   std_logic;
    
    signal RegWrite_2to3            :   std_logic;
    signal RegWrite_3to4            :   std_logic;
    signal RegWrite_3toROB          :   std_logic;
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

    signal FreeSlot_2to3            :   std_logic;
    signal FreeSlot_3to4            :   std_logic;   
    signal FreeSlot_4to5_and_ROB    :   std_logic;
    signal FreeSlot_5toForward      :   std_logic;

    signal ALUOp_2to3               :   std_logic_vector(2 downto 0);
    signal ALUSrc_2to3              :   std_logic;
    
    signal MemRead_2to3             :   std_logic;
    signal MemRead_3to4             :   std_logic;
    signal MemRead_4toCtrl          :   std_logic;
     
    signal MemWrite_2to3            :   std_logic;
    signal MemWrite_3to4            :   std_logic;
    signal MemWrite_3toROB          :   std_logic;
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
    
    signal fwd_aluRs_to2            :   std_logic_vector(2 downto 0);
    signal fwd_aluRt_to2            :   std_logic_vector(2 downto 0);
    signal fwd_alu_regmem_to2       :   std_logic_vector(2 downto 0);
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
     ------- FWD <--> ROB  ----------
    --------------------------------
     
     signal robRegisterRd0           : std_logic_vector(5 downto 0);  --producer ROB entrada 0 
    signal robRegisterRd1           : std_logic_vector(5 downto 0);  --producer ROB entrada 1 
    signal robRegisterRd2           : std_logic_vector(5 downto 0);  --producer ROB entrada 2 
    signal robRegisterRd3           : std_logic_vector(5 downto 0);  --producer ROB entrada 3 
    signal robRegisterRd4           : std_logic_vector(5 downto 0);  --producer ROB entrada 4 
    signal robRegisterRd5           : std_logic_vector(5 downto 0);  --producer ROB entrada 5 
    signal robRegisterRd6           : std_logic_vector(5 downto 0);  --producer ROB entrada 6 
    signal robRegisterRd7           : std_logic_vector(5 downto 0);  --producer ROB entrada 7 
     signal robMatchIdRs_out         : std_logic_vector(2 downto 0);
     signal robMatchIdRt_out         : std_logic_vector(2 downto 0);
     signal robMatchIdRt_mem_out     : std_logic_vector(2 downto 0);
    signal exeRegWrite              : std_logic;
    signal tagRegWrite              : std_logic;
    signal dcaRegWrite              : std_logic;
    signal robRegWrite0             : std_logic;
    signal robRegWrite1             : std_logic;
    signal robRegWrite2             : std_logic;
    signal robRegWrite3             : std_logic;
    signal robRegWrite4             : std_logic;
    signal robRegWrite5             : std_logic;
    signal robRegWrite6             : std_logic;
    signal robRegWrite7             : std_logic;
             
     signal robLoadStoreDep          : std_logic;
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
    signal busRdDataMemIC           :   std_logic_vector(127 downto 0);
    signal busWrDataMemIC           :   std_logic_vector(31 downto 0);
    signal busAddrIC                :   std_logic_vector(31 downto 0);
    signal BusRdIC                  :   std_logic;
    signal BusWrIC                  :   std_logic;
    signal BusReadyIC               :   std_logic;
    signal busRdDataMemDC           :   std_logic_vector(127 downto 0);
    signal busWrDataMemDC           :   std_logic_vector(31 downto 0);
    signal busAddrDC                :   std_logic_vector(31 downto 0);
    signal BusRdDC                  :   std_logic;
    signal BusWrDC                  :   std_logic;
    signal BusReadyDC               :   std_logic;
 
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
    signal ROB_value_flag_exe       :   std_logic;
    signal ROB_value_robid_exe      :   std_logic_vector(2 downto 0);
    signal ROB_value_alu            :   std_logic_vector(31 downto 0);
     signal ROB_value_flag_cache     :   std_logic;
     signal ROB_value_robid_cache    :   std_logic_vector(2 downto 0);
    signal ROB_value_cache          :   std_logic_vector(31 downto 0);
    signal ROB_rf_write             :   std_logic;
    signal ROB_rf_addr              :   std_logic_vector(4 downto 0);
    signal ROB_rf_val               :   std_logic_vector(31 downto 0);
    signal ROB_newentry_flag        :   std_logic;
    signal ROB_newentry_regaddr     :   std_logic_vector(5 downto 0);

  
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
             pc                 => busAddrIC,
             pc_up              => pc_up_1to2,
             instruction        => instruction_1to2,
             busDataMem         => busRdDataMemIC,
             clk                => clk,
             boot               => boot,
             Jump               => Jump_3to1,
             PCSrc              => PCSrc_4to1,
             ExceptionJump      => Exception_IFJump,
             IC_Ready           => instCacheReady_1toCtrl,
             NOP_to_ID          => NOP_HazardCtrlto1,
             Stall              => Stall_HazardCtrlto1,
             BusRd              => busRdIC,
             BusWr              => BusWrIC,
             BusReady           => BusReadyIC,
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
             rd                 => ROB_rf_val,
             sign_ext           => sign_ext_2to3,
             zero_ext           => zero_ext_2to3,
             addr_rs            => addr_rs_2toCtrl,
             addr_rt            => addr_rt_2to3,
             addr_rd            => addr_rd_2to3,
             write_data         => write_data_2to3,
             addr_regw          => ROB_rf_addr,
             fwd_path_alu       => fwd_path_alu_3to2,
             fwd_path_lookup    => fwd_path_lookup_4to2,
             fwd_path_cache     => fwd_path_cache_5to2and3and4,
                 fwd_path_rob_rs    => fwd_path_rob_rs,
             fwd_path_rob_rt    => fwd_path_rob_rt,
             fwd_path_rob_rt_mem => fwd_path_rob_rt_mem,
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
             FreeSlot           => FreeSlot_2to3,
             ALUOp              => ALUOp_2to3,
             ALUSrc             => ALUSrc_2to3,
             RegWrite_in        => ROB_rf_write,
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
             addr_rt_out        => addr_rt_3toCtrl,
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
             rob_addr_in        => ROB_tail,
             rob_addr_out       => rob_addr_EXE_L,
             clk                => clk,
             RegWrite_in        => RegWrite_2to3,
             RegWrite_out       => RegWrite_3to4,
             RegWrite_rob       => RegWrite_3toROB,
             Jump_in            => Jump_2to3,
             Jump_out           => Jump_3to1,
             Branch_in          => Branch_2to3,
             Branch_out         => Branch_3to4,
             MemRead_in         => MemRead_2to3,
             MemRead_out        => MemRead_3to4,
             MemWrite_in        => MemWrite_2to3,
             MemWrite_out       => MemWrite_3to4,
             MemWrite_rob       => MemWrite_3toROB,
             ByteAddress_in     => ByteAddress_2to3,
             ByteAddress_out    => ByteAddress_3to4,
             WordAddress_in     => WordAddress_2to3,
             WordAddress_out    => WordAddress_3to4,
             MemtoReg_in        => MemtoReg_2to3,
             MemtoReg_out       => MemtoReg_3to4,
             RegDst             => RegDst_2to3,
                 FreeSlot_in        => FreeSlot_2to3,
             FreeSlot_out       => FreeSlot_3to4,
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
             rob_addr_in        => rob_addr_EXE_L,
             rob_addr_out       => rob_addr_L_C,
             busWrDataMemWrite  => busWrDataMemDC,
             busAddrDC          => busAddrDC,
             clk                => clk,
             boot               => boot,
             RegWrite_in        => RegWrite_3to4,
             RegWrite_out       => RegWrite_4to5,
             Branch             => Branch_3to4,
             BranchTaken        => BranchTaken_4toCtrl,
             PCSrc              => PCSrc_4to1,
             MemRead            => MemRead_3to4,
             MemRead_out        => MemRead_4toCtrl,
             MemWrite           => MemWrite_3to4,
             ByteAddress_in     => ByteAddress_3to4,
             ByteAddress_out    => ByteAddress_4to5,
             WordAddress_in     => WordAddress_3to4,
             WordAddress_out    => WordAddress_4to5,
             MemtoReg_in        => MemtoReg_3to4,
             MemtoReg_out       => MemtoReg_4to5,
                 FreeSlot_in        => FreeSlot_3to4,
                 FreeSlot_out       => FreeSlot_4to5_and_ROB,
             Zero               => Zero_3to4,
             WriteCache         => WriteCache_4to5,
             muxDataR           => muxDataR_4to5,
             muxDataW           => muxDataW_4to5,
             BusRd              => BusRdDC,
             BusWr              => BusWrDC,
             BusReady           => BusReadyDC,
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
             rob_addr_in        => rob_addr_L_C,
             rob_addr_out       => rob_addr_C_WB,
             busDataMem         => busRdDataMemDC,
             clk                => clk,
             RegWrite_in        => RegWrite_4to5,
             RegWrite_out       => RegWrite_5to6,
             ByteAddress        => ByteAddress_4to5,
             WordAddress        => WordAddress_4to5,
             MemtoReg           => MemtoReg_4to5,
                 FreeSlot_in        => FreeSlot_4to5_and_ROB,
                 FreeSlot_out       => FreeSlot_5toForward,
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
             rob_addr           => rob_addr_C_WB,
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
             rob_addr_in    => ROB_tail,
             rob_addr_out   => rob_addr_fromLP,
             -- control signals
             clk            => clk,
             boot           => boot,
             Stall          => lp_Stall,
             doinstruction  => lp_doinst,
             write_output   => lp_write_output);

    DRAM : main_mem
    port map(addrIC             => busAddrIC,
             write_dataIC       => busWrDataMemIC, 
             read_dataIC        => busRdDataMemIC,
             addrDC             => busAddrDC,
             write_dataDC       => busWrDataMemDC, 
             read_dataDC        => busRdDataMemDC,
             BusRdIC            => BusRdIC,
             BusWrIC            => BusWrIC,
             BusReadyIC         => BusReadyIC,
             BusRdDC            => BusRdDC,
             BusWrDC            => BusWrDC,
             BusReadyDC         => BusReadyDC,
             reset              => boot,
             clk                => clk);
    
    
    Jump_3toCtrl <= Jump_3to1;
    hazard_contol_logic : hazard_ctrl
    port map(idRegisterRs       => addr_rs_2toCtrl,
             idRegisterRt       => addr_rt_2to3,
             exeRegisterRd      => addr_regw_3to4, 
             tagRegisterRd      => addr_regw_4to5,
             exeMemRead         => MemRead_3to4,
             tagMemRead         => MemRead_4toCtrl,
             Branch             => BranchTaken_4toCtrl,
             Jump               => Jump_3toCtrl,
             Exception          => Exception_ExcepCtrlOut,
             Interrupt          => Interrupt_InterruptCtrltoHazaardCtrl,
             Interrupt_to_Exception_ctrl => Interrupt_ExceptionCtrlfromHazardCtrl,
             ROB_Ready          => ROB_Ready_FromROB,
             ROB_Update         => ROB_Update_ToROB,
                 robLoadStoreDep    => robLoadStoreDep,
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
             NOP_to_WB          => NOP_HazardCtrlto5,
             boot               => boot);

             
    forwarding_control_logic : forwarding_ctrl 
    port map(idRegisterRs       => addr_rs_2toCtrl,
             idRegisterRt       => addr_rt_2to3,
             exeRegisterRd      => addr_regw_3to4,
             exeRegisterRt      => addr_rt_3toCtrl,
             tagRegisterRd      => addr_regw_4to5,
             dcaRegisterRd      => addr_regw_5to6,
                 robRegisterRd0     => robRegisterRd0,
                 robRegisterRd1     => robRegisterRd1,
                 robRegisterRd2     => robRegisterRd2,
                 robRegisterRd3     => robRegisterRd3,
                 robRegisterRd4     => robRegisterRd4,
                 robRegisterRd5     => robRegisterRd5,
                 robRegisterRd6     => robRegisterRd6,
                 robRegisterRd7     => robRegisterRd7,
                 robMatchIdRs_out   => robMatchIdRs_out,
                 robMatchIdRt_out   => robMatchIdRt_out,
                 robMatchIdRt_mem_out => robMatchIdRt_mem_out,
             exeRegWrite        => RegWrite_3toROB,
             tagRegWrite        => RegWrite_4to5,
             dcaRegWrite        => RegWrite_5to6,
                 robRegWrite0       => robRegWrite0,
                 robRegWrite1       => robRegWrite1,
                 robRegWrite2       => robRegWrite2,
                 robRegWrite3       => robRegWrite3,
                 robRegWrite4       => robRegWrite4,
                 robRegWrite5       => robRegWrite5,
                 robRegWrite6       => robRegWrite6,
                 robRegWrite7       => robRegWrite7,
             idMemWrite         => MemWrite_2toHazardCtrl,
             exeMemWrite        => MemWrite_3to4,
                FreeSlotL          => FreeSlot_4to5_and_ROB,
                FreeSlotC          => FreeSlot_5toForward,
                 robTail            => ROB_tail,
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
             
    ROB_value_flag_exe <= '0' when Stall_HazardCtrlto4 = '1' else
                          '1' when RegWrite_3toROB = '1' and addr_regw_3to4/= "000000" else
                          '1' when MemWrite_3toROB = '1' else
                          '0';   
    ROB_value_robid_exe <= rob_addr_EXE_L when RegWrite_3toROB = '1' OR MemWrite_3toROB = '1' else
                           rob_addr_fromLP;  
    ROB_value_alu   <= alu_res_3to4 when RegWrite_3toROB = '1' OR MemWrite_3toROB = '1' else
                       lp_write_data_out;                   
    
     
     ROB_value_flag_cache <= '1' when RegWrite_5to6 = '1' and FreeSlot_5toForward = '0' else 
                            '0';
    ROB_value_robid_cache <= rob_addr_C_WB;
    ROB_value_cache       <= register_d_5to6; -- Value for Loads        
            
            
    ROB_newentry_flag <= '0' when Stall_HazardCtrlto3 = '1' else
                         '1' when ROB_Update_ToROB = '1' and 
                                 ((addr_rt_2to3 /= "000000" and RegDst_2to3 = '0') OR  
                                  (addr_rd_2to3 /= "000000" and RegDst_2to3 = '1')) else
                         '1' when ROB_Update_ToROB = '1' and MemWrite_2to3 = '1' else
                         '0';
                         
    ROB_newentry_regaddr <= addr_rt_2to3 when RegDst_2to3 = '0' else
                            addr_rd_2to3;
       
    rob_control_logic : rob_ctrl
    port map(clk   => clk,
             boot  => boot,
             except_flag        => ROB_except_flag,
             except_addr        => ROB_except_addr,
             value_flag_exe     => ROB_value_flag_exe,
             value_robid_exe    => ROB_value_robid_exe,
             value_alu          => ROB_value_alu,
             value_flag_cache   => ROB_value_flag_cache,
             value_robid_cache  => ROB_value_robid_cache,
             value_cache        => ROB_value_cache,
             rf_write           => ROB_rf_write,
             rf_addr            => ROB_rf_addr,
             rf_val             => ROB_rf_val,
             newentry_flag      => ROB_newentry_flag,
             newentry_store     => MemWrite_2to3,
             newentry_load      => MemRead_2to3,
             newentry_regaddr   => ROB_newentry_regaddr,
                 robRegisterRd0     => robRegisterRd0,
                 robRegisterRd1     => robRegisterRd1,
                 robRegisterRd2     => robRegisterRd2,
                 robRegisterRd3     => robRegisterRd3,
                 robRegisterRd4     => robRegisterRd4,
                 robRegisterRd5     => robRegisterRd5,
                 robRegisterRd6     => robRegisterRd6,
                 robRegisterRd7     => robRegisterRd7,
                 robMatchIdRs_in    => robMatchIdRs_out,
                 robMatchIdRt_in    => robMatchIdRt_out,
                 robMatchIdRt_mem_in => robMatchIdRt_mem_out,
                 robRegWrite0       => robRegWrite0,
                 robRegWrite1       => robRegWrite1,
                 robRegWrite2       => robRegWrite2,
                 robRegWrite3       => robRegWrite3,
                 robRegWrite4       => robRegWrite4,
                 robRegWrite5       => robRegWrite5,
                 robRegWrite6       => robRegWrite6,
                 robRegWrite7       => robRegWrite7,
             fwd_path_rob_rs    => fwd_path_rob_rs,
                 fwd_path_rob_rt    => fwd_path_rob_rt,
                 fwd_path_rob_rt_mem => fwd_path_rob_rt_mem,
                 robLoadStoreDep    => robLoadStoreDep,
               lookup_load_addr   => alu_res_4to5,
                 FreeSlot           => FreeSlot_4to5_and_ROB,
                 ready              => ROB_Ready_FromROB,
             tail               => ROB_tail);

    interrupts_control_logic : interrupt_ctrl
    port map(interrupt          => external_interrupt,
             int_clear          => '0', -- interrupt_clear,
             int_flag           => Interrupt_InterruptCtrltoHazaardCtrl,
             clk                => clk,
             boot               => boot ); 
     
end Structure;
