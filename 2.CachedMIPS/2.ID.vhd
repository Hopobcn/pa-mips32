library ieee;
use ieee.std_logic_1164.all;

entity instruction_decode is
    port (-- buses
          instruction     :   in  std_logic_vector(31 downto 0);  --from IF
          addr_jump       :   out std_logic_vector(31 downto 0);  --to EXE,IF
          pc_up_in        :   in  std_logic_vector(31 downto 0);  --from IF
          pc_up_out       :   out std_logic_vector(31 downto 0);  --to EXE
          opcode          :   out std_logic_vector(5 downto 0);   --to EXE
          rs              :   out std_logic_vector(31 downto 0);  --to EXE
          rt              :   out std_logic_vector(31 downto 0);  --to EXE
          rd              :   in  std_logic_vector(31 downto 0);  --from ROB
          sign_ext        :   out std_logic_vector(31 downto 0);  --to EXE
          zero_ext        :   out std_logic_vector(31 downto 0);  --to EXE
          addr_rs         :   out std_logic_vector(5 downto 0);   --to HAZARD CTRL
          addr_rt         :   out std_logic_vector(5 downto 0);   --to EXE
          addr_rd         :   out std_logic_vector(5 downto 0);   --to EXE
          write_data      :   out std_logic_vector(31 downto 0);  --to EXE,LOOKUP,CACHE
          addr_regw       :   in  std_logic_vector(4 downto 0);   --from ReOrderBuffer
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
            
end instruction_decode;


architecture Structure of instruction_decode is

    component if_id_reg is
    port (instruction_in   : in  std_logic_vector(31 downto 0);
          instruction_out  : out std_logic_vector(31 downto 0);
          pc_up_in         : in  std_logic_vector(31 downto 0);    
          pc_up_out        : out std_logic_vector(31 downto 0); 
          -- register control signals
          enable           : in  std_logic;
          clk              : in  std_logic;
          -- exception identifier bits
          exception_if_in  : in  std_logic;
          exception_if_out : out std_logic;
          -- exception registers
          Exc_EPC_in       : in  std_logic_vector(31 downto 0);
          Exc_EPC_out      : out std_logic_vector(31 downto 0);
          Exc_Cause_in     : in  std_logic_vector(31 downto 0);
          Exc_Cause_out    : out std_logic_vector(31 downto 0);
          Exc_BadVAddr_in  : in  std_logic_vector(31 downto 0);
          Exc_BadVAddr_out : out std_logic_vector(31 downto 0));
    end component;
    
    signal instruction_reg  :   std_logic_vector(31 downto 0);
    signal pc_up_reg        :   std_logic_vector(31 downto 0);
    
    component control_inst_decode is
    port (opcode            :   in  std_logic_vector(5 downto 0);
          opcode_extra      :   in  std_logic_vector(3 downto 0);
          LongPipe          :   out std_logic;
          RegWrite          :   out std_logic;
          c0RegWrite        :   out std_logic;
          c0RegRead         :   out std_logic;
          Jump              :   out std_logic;
          Branch            :   out std_logic;
          MemRead           :   out std_logic;                              
          MemWrite          :   out std_logic;  
          ByteAddress       :   out std_logic;
          WordAddress       :   out std_logic;
          MemtoReg          :   out std_logic;
          RegDst            :   out std_logic;  
          FreeSlot          :   out std_logic;
          ALUOp             :   out std_logic_vector(2 downto 0);
          ALUSrc            :   out std_logic); 
    end component;
    
    component regfile is
    port (clk               :   in  std_logic;
          addr_rs           :   in  std_logic_vector(4 downto 0);
          addr_rt           :   in  std_logic_vector(4 downto 0);
          addr_rd           :   in  std_logic_vector(4 downto 0);
          rs                :   out std_logic_vector(31 downto 0);
          rt                :   out std_logic_vector(31 downto 0);
          rd                :   in  std_logic_vector(31 downto 0);
          RegWrite          :   in  std_logic);
    end component;

    component c0regfile is
    port (clk                 :   in  std_logic;
          addr_read         :     in  std_logic_vector(4 downto 0);   --! Read address
          reg_read          :     out   std_logic_vector(31 downto 0); --! Register data for the read operation
          addr_write        :   in  std_logic_vector(4 downto 0);  --! Write address
          reg_write         :   in  std_logic_vector(31 downto 0);  --! Register data for the write operation
          RegWrite          :   in  std_logic;                      --! Enable Write for the write port
          BadVAddr_reg      :   in  std_logic_vector(31 downto 0);  --! Direct input of the BadVAddr register (#8)
          BadVAddr_w        :   in  std_logic;                      --! Enable Write flag for the BadVAddr register
          Status_reg        :   in  std_logic_vector(31 downto 0);  --! Direct input of the Status register (#12)
          Status_w          :   in  std_logic;                      --! Enable Write flag for the Status register
          Cause_reg         :   in  std_logic_vector(31 downto 0);  --! Direct input for the Cause register (#13)
          Cause_w           :   in  std_logic;                      --! Enable Write flag for the Cause register
          EPC_reg           :   in  std_logic_vector(31 downto 0);  --! Direct input for the EPC  register (#14)
          EPC_w             :   in  std_logic);                     --! Enable Write flag for the EPC register
    end component;
    
    component seu is
    port (input             :   in  std_logic_vector(15 downto 0);
          output            :   out std_logic_vector(31 downto 0));
    end component;
    
    signal RegWrite_tmp     :   std_logic;
    signal MemtoReg_tmp     :   std_logic;
    signal MemWrite_tmp     :   std_logic;
    signal MemRead_tmp      :   std_logic;
    signal RegDst_tmp       :   std_logic;
    signal FreeSlot_tmp     :   std_logic;
    signal ALUOp_tmp        :   std_logic_vector(2 downto 0);
    signal Jump_tmp         :   std_logic;
    signal Branch_tmp       :   std_logic;
    
    signal LongPipe_tmp     :   std_logic;
    
    signal rs_regfile       :   std_logic_vector(31 downto 0);
    signal rt_regfile       :   std_logic_vector(31 downto 0);
    
    signal exception_if_reg   : std_logic;
    signal exception_internal : std_logic;
    -- Exception buses
    signal Exc_BadVAddr_reg  : std_logic_vector(31 downto 0);
    signal Exc_Cause_reg     : std_logic_vector(31 downto 0);
    signal Exc_EPC_reg       : std_logic_vector(31 downto 0);
    
    -- Coprocessor 0 operations
    signal c0RegRead_tmp    :  std_logic;
     signal c0RegWrite_tmp   :  std_logic;
     signal c0reg_out        :  std_logic_vector(31 downto 0);

    -- Signal to the regular register file for non-c0 write operations
    signal addr_rd_tmp      :  std_logic_vector(4 downto 0);
     -- Signal for the c0 register file
     signal addr_c0_write_tmp:  std_logic_vector(4 downto 0);

     -- Enable for the write operations on c0 register file
    signal c0RegWrite_in_tmp:  std_logic;

    signal enable           :   std_logic;
begin
  
    enable <= not Stall;
        
    -- IF/ID Register 
    IF_ID_register : if_id_reg
    port map(instruction_in     => instruction,
             instruction_out    => instruction_reg,
             pc_up_in           => pc_up_in,
             pc_up_out          => pc_up_reg,
             enable             => enable, 
             clk                => clk,
             -- exceptions
             exception_if_in  => exception_if_in,
             exception_if_out => exception_if_reg,
             -- Exception buses
             Exc_BadVAddr_in   => Exc_BadVAddr_in,
             Exc_BadVAddr_out  => Exc_BadVAddr_reg,
             Exc_Cause_in      => Exc_Cause_in,
             Exc_Cause_out     => Exc_Cause_reg,
             Exc_EPC_in        => Exc_EPC_in,
             Exc_EPC_out       => Exc_EPC_reg);
                
        --jump addres is PC+4[31-28]+Shift_left_2(Instruction[25-0])
    addr_jump   <= pc_up_reg(31 downto 28) & instruction_reg(25 downto 0) & "00";
    pc_up_out   <= pc_up_reg;
    opcode      <= instruction_reg(31 downto 26);
    addr_rs     <= '0' & instruction_reg(25 downto 21);
    addr_rt     <= '1' & instruction_reg(20 downto 16) when c0RegRead_tmp = '1' else
                   '0' & instruction_reg(20 downto 16) when c0RegWrite_tmp = '1' else
                   '0' & instruction_reg(20 downto 16);
    addr_rd     <= '0' & instruction_reg(15 downto 11) when c0RegRead_tmp = '1' else
                   '1' & instruction_reg(15 downto 11) when c0RegWrite_tmp = '1' else
                   '0' & instruction_reg(15 downto 11);
    
    --logica de control enmascarada, aixi es mes facil gestionar-la
    control : control_inst_decode 
    port map(opcode     => instruction_reg(31 downto 26),
            opcode_extra=> instruction_reg(25 downto 22), 
            LongPipe    => LongPipe_tmp,
            RegWrite    => RegWrite_tmp,
            c0RegWrite  => c0RegWrite_tmp,
            c0RegRead   => c0RegRead_tmp,
            Jump        => Jump_tmp,
            Branch      => Branch_tmp,
            MemRead     => MemRead_tmp,
            MemWrite    => MemWrite_tmp,
            ByteAddress => ByteAddress,
            WordAddress => WordAddress,
            MemtoReg    => MemtoReg_tmp,
            RegDst      => RegDst_tmp,
            FreeSlot    => FreeSlot_tmp,
            ALUOp       => ALUOp_tmp,
            ALUSrc      => ALUSrc);
            
    -- Exception (should detect problems with illegal decodings)
    exception_internal <= '0';
    
    -- Output the exception (and put exceptions through)
    exception_if_out <= exception_if_reg when NOP_to_EXE = '0' else
                        '0';
    exception_id <= exception_internal when NOP_to_EXE = '0' else
                    '0';
    -- Output the exception registers, change when needed
    Exc_BadVaddr_out <= Exc_BadVAddr_reg;
    Exc_EPC_out <= Exc_EPC_reg;
    -- ToDo Appendix A-35 something better
    Exc_Cause_out <= x"00000001" when exception_internal = '1' else
                     Exc_Cause_reg;
    
    --big nop multiplexor
    RegWrite_out    <= RegWrite_tmp when NOP_to_EXE = '0' and exception_internal = '0' else
                       '0';
    MemRead         <= MemRead_tmp  when NOP_to_EXE = '0' and exception_internal = '0' else
                       '0';
    MemWriteHazard  <= MemWrite_tmp;
    MemWrite        <= MemWrite_tmp when NOP_to_EXE = '0' and exception_internal = '0' else
                       '0';
    MemtoReg        <= MemtoReg_tmp when    NOP_to_EXE = '0' and exception_internal = '0' else
                       '0';
    RegDst          <= RegDst_tmp    when NOP_to_EXE = '0' and exception_internal = '0' else
                       '0';
    FreeSlot        <= FreeSlot_tmp when NOP_to_EXE = '0' and exception_internal = '0' else -- IF WE introduce a NOP we consider it as a FreeSlot for Stores in ROB
	                    '1';
    ALUOp           <= ALUOp_tmp     when NOP_to_EXE = '0' and exception_internal = '0' else
                       "010";                                    -- NOP = R0 = R0 OR R0
    -- the Jump only goes through when not stalling
    Jump            <= Jump_tmp     when NOP_to_EXE = '0' and exception_internal = '0' else
                       '0'; 
    Branch          <= Branch_tmp   when NOP_to_EXE = '0' and exception_internal = '0' else
                       '0';
                        
                        
    register_file   :   regfile
    port map(clk        => clk,
             addr_rs    => instruction_reg(25 downto 21),
             addr_rt    => instruction_reg(20 downto 16),
             addr_rd    => addr_rd_tmp,
             rs         => rs_regfile,
             rt         => rt_regfile,
             rd         => rd,
             RegWrite   => RegWrite_in);

     addr_rd_tmp <= addr_regw;
     
--     addr_c0_write_tmp <= addr_regw(4 downto 0) when  addr_regw(5) = '1' else
--                          "00000";
    addr_c0_write_tmp <= "00000";
    
--     c0RegWrite_in_tmp <= RegWrite_in and addr_regw(5);
  c0RegWrite_in_tmp <= '0';

     coprocessor0_register_file : c0regfile
     port map(clk          => clk,
              addr_read    => instruction_reg(15 downto 11),
              reg_read     => c0reg_out,
              addr_write   => "00000",
              reg_write    => x"00000000",
              RegWrite     => '0',
              BadVAddr_reg => Exc_BadVAddr_to_regfile,
              BadVAddr_w   => writeBadVAddr_to_regfile,
              Status_reg   => x"00000000",
              Status_w     => c0RegWrite_in_tmp,
              Cause_reg    => Exc_Cause_to_regfile,
              Cause_w      => writeCause_to_regfile,
              EPC_reg      => Exc_EPC_to_regfile,
              EPC_w        => writeEPC_to_regfile);

    rs  <= fwd_path_alu     when fwd_aluRs = "111" else
           fwd_path_lookup  when fwd_aluRs = "110" else
           fwd_path_cache   when fwd_aluRs = "101" else
           fwd_path_rob_rs  when fwd_aluRs = "100" else
           rs_regfile;         --fwd_aluRs = "00"
            
    rt  <= fwd_path_alu     when fwd_aluRt = "111" else
           fwd_path_lookup  when fwd_aluRt = "110" else
           fwd_path_cache   when fwd_aluRt = "101" else
           fwd_path_rob_rt  when fwd_aluRt = "100" else
           rt_regfile;         --fwd_aluRt = "00"
            
    write_data <= fwd_path_alu        when fwd_alu_regmem = "111" else
                  fwd_path_lookup     when fwd_alu_regmem = "110" else
                  fwd_path_cache      when fwd_alu_regmem = "101" else
                  fwd_path_rob_rt_mem when fwd_alu_regmem = "100" else
                  rt_regfile;
    
    -- Long Pipe things for valid behaviour
    lp_doinst  <= LongPipe_tmp;
    lp_addr_rd <= instruction_reg(15 downto 11);
    lp_rs      <= fwd_path_alu     when fwd_aluRs = "111" else
                  fwd_path_lookup  when fwd_aluRs = "110" else
                  fwd_path_cache   when fwd_aluRs = "101" else
                  fwd_path_rob_rs  when fwd_aluRs = "100" else
                  rs_regfile;         --fwd_aluRs = "000";
           
    lp_rt      <= fwd_path_alu     when fwd_aluRt = "111" else
                  fwd_path_lookup  when fwd_aluRt = "110" else
                  fwd_path_cache   when fwd_aluRt = "101" else
                  fwd_path_rob_rt  when fwd_aluRt = "100" else
                  rt_regfile;         --fwd_aluRt = "00"

    sign_extend_unit    :   seu
    port map(input      => instruction_reg(15 downto 0),
             output     => sign_ext);
    
    zero_ext <= "0000000000000000" & instruction_reg(15 downto 0);
    
end Structure;
