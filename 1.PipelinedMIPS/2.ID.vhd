library ieee;
use ieee.std_logic_1164.all;

entity instruction_decode is
    port (-- buses
            instruction     :   in std_logic_vector(31 downto 0);   --from IF
            addr_jump       :   out std_logic_vector(31 downto 0);  --to EXE,MEM,IF
            pc_up_in        :   in  std_logic_vector(31 downto 0);  --from IF
            pc_up_out       :   out std_logic_vector(31 downto 0);  --to EXE
            opcode          :   out std_logic_vector(5 downto 0);   --to EXE
            rs              :   out std_logic_vector(31 downto 0);  --to EXE
            rt              :   out std_logic_vector(31 downto 0);  --to EXE
            rd              :   in  std_logic_vector(31 downto 0);  --from WB           
            sign_ext        :   out std_logic_vector(31 downto 0);  --to EXE
            zero_ext        :   out std_logic_vector(31 downto 0);  --to EXE
            addr_rs         :   out std_logic_vector(4 downto 0);   --to HAZARD CTRL
            addr_rt         :   out std_logic_vector(4 downto 0);   --to EXE
            addr_rd         :   out std_logic_vector(4 downto 0);   --to EXE
            write_data      :   out std_logic_vector(31 downto 0);  --to EXE,MEM
            addr_regw       :   in  std_logic_vector(4 downto 0);       --from WB
            fwd_path_alu    :   in  std_logic_vector(31 downto 0);  --from ALU [FWD]
            fwd_path_mem    :   in  std_logic_vector(31 downto 0);  --from MEM [FWD]
            -- control signals
            clk             :   in  std_logic;
            RegWrite_out    :   out std_logic;                      --to EXE,MEM,WB and then ID
            Jump            :   out std_logic;                      --to EXE,MEM,IF
            Branch          :   out std_logic;                      --to EXE,MEMJum
            MemRead         :   out std_logic;                      --to EXE,MEM
            MemWrite        :   out std_logic;                      --to EXE,MEM
            MemWriteHazard  :  out std_logic;                       --to Hazard control (pure value without NOP, if not weird things occur)
            ByteAddress     :  out std_logic;                       --to EXE,MEM
            WordAddress     :   out std_logic;                      --to EXE,MEM
            MemtoReg        :   out std_logic;                      --to EXE,MEM,WB
            RegDst          :   out std_logic;                      --to EXE
            ALUOp           :   out std_logic_vector(2 downto 0);   --to EXE
            ALUSrc          :   out std_logic;                      --to EXE
            RegWrite_in     :   in   std_logic;                     --from WB   
            fwd_aluRs       :   in  std_logic_vector(1 downto 0);   --from FWD Ctrl
            fwd_aluRt       :   in  std_logic_vector(1 downto 0);   --from FWD Ctrl
            fwd_alu_regmem  :   in  std_logic_vector(1 downto 0);   --from FWD Ctrl 
            NOP_to_EXE      :  in  std_logic;                       --from Hazard Ctrl
            Stall           :   in   std_logic; 
            -- exception bits
            exception_if_in :   in  std_logic;
            exception_if_out:   out std_logic;
            exception_id    :   out std_logic;
            -- Exception-related registers
            Exc_BadVAddr_in  : in std_logic_vector(31 downto 0);
            Exc_BadVAddr_out : out std_logic_vector(31 downto 0);
            Exc_Cause_in     : in std_logic_vector(31 downto 0);
            Exc_Cause_out    : out std_logic_vector(31 downto 0);
            Exc_EPC_in       : in std_logic_vector(31 downto 0);
            Exc_EPC_out      : out std_logic_vector(31 downto 0);
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
    port (instruction_in    :   in std_logic_vector(31 downto 0);
          instruction_out   :   out std_logic_vector(31 downto 0);
          pc_up_in          :   in  std_logic_vector(31 downto 0);  
          pc_up_out         :   out std_logic_vector(31 downto 0);  
          -- register control signals
          enable            :   in std_logic;
          clk               :   in std_logic;
          
          -- exceptions
          exception_if_in   : in std_logic;
          exception_if_out  : out std_logic;
          -- Exception-related registers
          Exc_BadVAddr_in  : in std_logic_vector(31 downto 0);
          Exc_BadVAddr_out : out std_logic_vector(31 downto 0);
          Exc_Cause_in     : in std_logic_vector(31 downto 0);
          Exc_Cause_out    : out std_logic_vector(31 downto 0);
          Exc_EPC_in       : in std_logic_vector(31 downto 0);
          Exc_EPC_out      : out std_logic_vector(31 downto 0));
    end component;
    
    signal instruction_reg  :   std_logic_vector(31 downto 0);
    signal pc_up_reg        :   std_logic_vector(31 downto 0);
    
    component control_inst_decode is
    port (opcode            :   in std_logic_vector(5 downto 0);
          RegWrite          :   out std_logic;
          Jump              :   out std_logic;
          Branch            :   out std_logic;
          MemRead           :   out std_logic;                              
          MemWrite          :   out std_logic;  
          ByteAddress       :   out std_logic;
          WordAddress       :   out std_logic;
          MemtoReg          :   out std_logic;
          RegDst            :   out std_logic;  
          ALUOp             :   out std_logic_vector(2 downto 0);
          ALUSrc            :   out std_logic); 
    end component;
    
    component regfile is
    port (clk               :   in std_logic;
          addr_rs           :   in std_logic_vector(4 downto 0);
          addr_rt           :   in  std_logic_vector(4 downto 0);
          addr_rd           :   in  std_logic_vector(4 downto 0);
          rs                :   out std_logic_vector(31 downto 0);
          rt                :   out std_logic_vector(31 downto 0);
          rd                :   in  std_logic_vector(31 downto 0);
          RegWrite          :   in  std_logic);
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
    signal ALUOp_tmp        :   std_logic_vector(2 downto 0);
    signal Jump_tmp         :   std_logic;
    signal Branch_tmp       :   std_logic;
    
    signal rs_regfile       :   std_logic_vector(31 downto 0);
    signal rt_regfile       :   std_logic_vector(31 downto 0);
    
    signal exception_if_reg   : std_logic;
    signal exception_internal : std_logic;
    -- Exception buses
    signal Exc_BadVAddr_reg  : std_logic_vector(31 downto 0);
    signal Exc_Cause_reg     : std_logic_vector(31 downto 0);
    signal Exc_EPC_reg       : std_logic_vector(31 downto 0);
    
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
    addr_rs     <= instruction_reg(25 downto 21);
    addr_rt     <= instruction_reg(20 downto 16);
    addr_rd     <=  instruction_reg(15 downto 11);
    
    --logica de control enmascarada, aixi es mes facil gestionar-la
    control : control_inst_decode 
    port map(opcode     => instruction_reg(31 downto 26),
            RegWrite    => RegWrite_tmp,
            Jump        => Jump_tmp,
            Branch      => Branch_tmp,
            MemRead     => MemRead_tmp,
            MemWrite    => MemWrite_tmp,
            ByteAddress => ByteAddress,
            WordAddress => WordAddress,
            MemtoReg    => MemtoReg_tmp,
            RegDst      => RegDst_tmp,
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
    -- RegWrite_out    <= RegWrite_tmp when NOP_to_EXE = '0' and exception_internal = '0' else
    --                    '0';
    -- MemRead         <= MemRead_tmp  when NOP_to_EXE = '0' and exception_internal = '0' else
    --                    '0';
    -- MemWriteHazard  <= MemWrite_tmp;
    -- MemWrite        <= MemWrite_tmp when NOP_to_EXE = '0' and exception_internal = '0' else
    --                    '0';
    -- MemtoReg        <= MemtoReg_tmp when    NOP_to_EXE = '0' and exception_internal = '0' else
    --                    '0';
    -- RegDst          <= RegDst_tmp    when NOP_to_EXE = '0' and exception_internal = '0' else
    --                    '0';
    -- ALUOp           <= ALUOp_tmp     when NOP_to_EXE = '0' and exception_internal = '0' else
    --                    "010";                                    -- NOP = R0 = R0 OR R0
    -- the Jump only goes through when not stalling
    --Jump            <= Jump_tmp     when NOP_to_EXE = '0' and exception_internal = '0' else
    --                   '0'; 
    --  Branch          <= Branch_tmp   when NOP_to_EXE = '0' and exception_internal = '0' else
    --                     '0';
	 -- We really should use the stuff commented out before.
    RegWrite_out <= RegWrite_tmp;
    MemRead <= MemRead_tmp;
    MemWriteHazard <= MemWrite_tmp;
    MemWrite <= MemWrite_tmp;
    MemtoReg <= MemtoReg_tmp;
    RegDst <= RegDst_tmp;
    ALUop <= ALUOp_tmp;
    Jump <= Jump_tmp;
    Branch <= Branch_tmp;

                        
                        
    register_file   :   regfile
    port map(clk        => clk,
             addr_rs    =>  instruction_reg(25 downto 21),
             addr_rt    => instruction_reg(20 downto 16),
             addr_rd    => addr_regw,
             rs         => rs_regfile,
             rt         => rt_regfile,
             rd         => rd,
             RegWrite   => RegWrite_in);
                
    rs  <= fwd_path_alu     when fwd_aluRs = "11" else
           fwd_path_mem     when fwd_aluRs = "10" else
           rs_regfile;         --fwd_aluRs = "00"
            
    rt  <= fwd_path_alu     when fwd_aluRt = "11" else
           fwd_path_mem     when fwd_aluRt = "10" else
           rt_regfile;         --fwd_aluRt = "00"
            
    write_data <= fwd_path_alu when fwd_alu_regmem = "11" else
                  fwd_path_mem when fwd_alu_regmem = "10" else
                  rt_regfile;
    
    sign_extend_unit    :   seu
    port map(input      => instruction_reg(15 downto 0),
             output     => sign_ext);
    
    zero_ext <= "0000000000000000" & instruction_reg(15 downto 0);
    
end Structure;
