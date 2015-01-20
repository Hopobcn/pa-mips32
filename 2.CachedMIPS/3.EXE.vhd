library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity execute is
    port (-- buses
          pc_up               :   in  std_logic_vector(31 downto 0);  --from ID
          opcode              :   in  std_logic_vector(5 downto 0);   --from ID
          rs                  :   in  std_logic_vector(31 downto 0);  --from ID
          rt                  :   in  std_logic_vector(31 downto 0);  --from ID
          sign_ext            :   in  std_logic_vector(31 downto 0);  --from ID
          zero_ext            :   in  std_logic_vector(31 downto 0);  --from ID
          addr_rt_in          :   in  std_logic_vector(4 downto 0);   --from ID
          addr_rt_out         :   out std_logic_vector(4 downto 0);   --to Hazard Ctrl
          addr_rd             :   in  std_logic_vector(4 downto 0);   --from ID
          addr_jump_in        :   in  std_logic_vector(31 downto 0);  --from ID
          addr_jump_out       :   out std_logic_vector(31 downto 0);  --to IF
          addr_branch         :   out std_logic_vector(31 downto 0);  --to LOOKUP,then IF
          alu_res             :   out std_logic_vector(31 downto 0);  --to LOOKUP
          write_data_in       :   in  std_logic_vector(31 downto 0);  --from ID
          write_data_out      :   out std_logic_vector(31 downto 0);  --to LOOKUP
          addr_regw           :   out std_logic_vector(4 downto 0);   --to LOOKUP,CACHE,WB, then IF
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

       
end execute;

architecture Structure of execute is

    component id_exe_reg is
    port (-- buses
            pc_up_in        :   in  std_logic_vector(31 downto 0);  
            pc_up_out       :   out std_logic_vector(31 downto 0);  
            opcode_in       :   in  std_logic_vector(5 downto 0);       
            opcode_out      :   out std_logic_vector(5 downto 0);   
            rs_in           :   in  std_logic_vector(31 downto 0);  
            rs_out          :   out std_logic_vector(31 downto 0);  
            rt_in           :   in  std_logic_vector(31 downto 0);  
            rt_out          :   out std_logic_vector(31 downto 0);
            sign_ext_in     :   in  std_logic_vector(31 downto 0);  
            sign_ext_out    :   out std_logic_vector(31 downto 0);
            zero_ext_in     :   in  std_logic_vector(31 downto 0);  
            zero_ext_out    :   out std_logic_vector(31 downto 0);
            addr_rt_in      :   in  std_logic_vector(4 downto 0);       
            addr_rt_out     :   out std_logic_vector(4 downto 0);   
            addr_rd_in      :   in  std_logic_vector(4 downto 0);       
            addr_rd_out     :   out std_logic_vector(4 downto 0);   
            addr_jump_in    :   in  std_logic_vector(31 downto 0);  
            addr_jump_out   :   out std_logic_vector(31 downto 0);  
            -- control signals
            RegWrite_in     :   in  std_logic;                                  
            RegWrite_out    :   out std_logic;  
            Jump_in         :   in  std_logic;                          
            Jump_out        :   out std_logic;  
            Branch_in       :   in  std_logic;                              
            Branch_out      :   out std_logic;  
            MemRead_in      :   in  std_logic;                               
            MemRead_out     :   out std_logic;  
            MemWrite_in     :   in  std_logic;                               
            MemWrite_out    :   out std_logic;  
            ByteAddress_in  :   in  std_logic;                              
            ByteAddress_out :   out std_logic;  
            WordAddress_in  :   in  std_logic;                      
            WordAddress_out :   out std_logic;  
            MemtoReg_in     :   in  std_logic;                          
            MemtoReg_out    :   out std_logic;  
            RegDst_in       :   in  std_logic;
            RegDst_out      :   out std_logic;
            ALUOp_in        :   in  std_logic_vector(2 downto 0);       
            ALUOp_out       :   out std_logic_vector(2 downto 0);       
            ALUSrc_in       :   in  std_logic;          
            ALUSrc_out      :   out std_logic;  
            -- register control signals
            enable          :   in  std_logic;
            clk             :   in  std_logic;
            
            -- exceptions
            exception_if_in   : in  std_logic;
            exception_if_out  : out std_logic;
            exception_id_in   : in  std_logic;
            exception_id_out  : out std_logic;
            -- Exception-related registers
            Exc_BadVAddr_in  : in  std_logic_vector(31 downto 0);
            Exc_BadVAddr_out : out std_logic_vector(31 downto 0);
            Exc_Cause_in     : in  std_logic_vector(31 downto 0);
            Exc_Cause_out    : out std_logic_vector(31 downto 0);
            Exc_EPC_in       : in  std_logic_vector(31 downto 0);
            Exc_EPC_out      : out std_logic_vector(31 downto 0));

    end component;

    signal pc_up_reg        :   std_logic_vector(31 downto 0);  
    signal opcode_reg       :   std_logic_vector(5 downto 0);   
    signal rs_reg           :   std_logic_vector(31 downto 0);  
    signal rt_reg           :   std_logic_vector(31 downto 0);
    signal sign_ext_reg     :   std_logic_vector(31 downto 0);
    signal zero_ext_reg     :   std_logic_vector(31 downto 0);  
    signal addr_rt_reg      :   std_logic_vector(4 downto 0);       
    signal addr_rd_reg      :   std_logic_vector(4 downto 0);   
    signal addr_jump_reg    :   std_logic_vector(31 downto 0);  
    signal RegWrite_reg     :   std_logic;  
    signal Jump_reg         :   std_logic;  
    signal Branch_reg       :   std_logic;  
    signal MemRead_reg      :   std_logic;  
    signal MemWrite_reg     :   std_logic;  
    signal ByteAddress_reg  :   std_logic;  
    signal WordAddress_reg  :   std_logic;  
    signal MemtoReg_reg     :   std_logic;  
    signal RegDst_reg       :   std_logic;
    signal ALUOp_reg        :   std_logic_vector(2 downto 0);       
    signal ALUSrc_reg       :   std_logic;  
    
    signal exception_if_reg   : std_logic;
    signal exception_id_reg   : std_logic;
    signal exception_internal : std_logic;
    -- Exception buses
    signal Exc_BadVAddr_reg  : std_logic_vector(31 downto 0);
    signal Exc_Cause_reg     : std_logic_vector(31 downto 0);
    signal Exc_EPC_reg       : std_logic_vector(31 downto 0);
                    
    component alu_control is
    port (opcode        : in std_logic_vector(5 downto 0);
          funct         : in std_logic_vector(5 downto 0); 
          ALUOp_in      : in std_logic_vector(2 downto 0);
          ALUOp_out     : out std_logic_vector(3 downto 0);
          SignedSrc     : out std_logic;
          ShiftSrc      : out std_logic);
    end component;
    
    component alu is
    port (a             :   in std_logic_vector(31 downto 0);
          b             :   in std_logic_vector(31 downto 0);
          res           :   out std_logic_vector(31 downto 0);
          Zero          :   out std_logic;
          Overflow    :   out std_logic;
          --CarryOut    :   out std_logic;
          funct         :   in std_logic_vector(5 downto 0);
          ALUOp         :   in  std_logic_vector(3 downto 0));
    end component;
    
    signal alu_result       :  std_logic_vector(31 downto 0);
    signal shamt            :   std_logic_vector(31 downto 0);
    signal sign_immed_mux   :   std_logic_vector(31 downto 0);
    signal alusrc_a_mux     :   std_logic_vector(31 downto 0);
    signal alusrc_b_mux     :   std_logic_vector(31 downto 0);
    signal shiftsrc_mux     :   std_logic_vector(31 downto 0);
    signal ALUOp_control    :   std_logic_vector(3 downto 0);
    signal sign_ext_sh2     :   std_logic_vector(31 downto 0);
    
    signal SignedSrc        :  std_logic;
    signal ShiftSrc         :   std_logic;
    
    signal enable           : std_logic;
begin
 
  enable <= not Stall;
  
    -- ID/EXE Register 
    ID_EXE_register : id_exe_reg
    port map(pc_up_in       => pc_up,
             pc_up_out      => pc_up_reg,
             opcode_in      => opcode,
             opcode_out     => opcode_reg,
             rs_in          => rs,
             rs_out         => rs_reg,
             rt_in          => rt,
             rt_out         => rt_reg,
             sign_ext_in    => sign_ext,
             sign_ext_out   => sign_ext_reg,
             zero_ext_in    => zero_ext,
             zero_ext_out   => zero_ext_reg,
             addr_rt_in     => addr_rt_in,
             addr_rt_out    => addr_rt_reg,
             addr_rd_in     => addr_rd,
             addr_rd_out    => addr_rd_reg,
             addr_jump_in   => addr_jump_in,
             addr_jump_out  => addr_jump_reg,
             RegWrite_in    => RegWrite_in,
             RegWrite_out   => RegWrite_reg,
             Jump_in        => Jump_in,
             Jump_out       => Jump_reg,
             Branch_in      => Branch_in,
             Branch_out     => Branch_reg,
             MemRead_in     => MemRead_in,
             MemRead_out    => MemRead_reg,
             MemWrite_in    => MemWrite_in,
             MemWrite_out   => MemWrite_reg,
             ByteAddress_in => ByteAddress_in,
             ByteAddress_out=> ByteAddress_reg,
             WordAddress_in => WordAddress_in,
             WordAddress_out=> WordAddress_reg,
             MemtoReg_in    => MemtoReg_in,
             MemtoReg_out   => MemtoReg_reg,
             RegDst_in      => RegDst,
             RegDst_out     => RegDst_reg,
             ALUOp_in       => ALUOp,
             ALUOp_out      => ALUOp_reg,
             ALUSrc_in      => ALUSrc,
             ALUSrc_out     => ALUSrc_reg,
             enable         => enable,
             clk            => clk,
             -- exceptions 
             exception_if_in  => exception_if_in,
             exception_if_out => exception_if_reg,
             exception_id_in  => exception_id_in,
             exception_id_out => exception_id_reg,
             -- Exception buses
             Exc_BadVAddr_in   => Exc_BadVAddr_in,
             Exc_BadVAddr_out  => Exc_BadVAddr_reg,
             Exc_Cause_in      => Exc_Cause_in,
             Exc_Cause_out     => Exc_Cause_reg,
             Exc_EPC_in        => Exc_EPC_in,
             Exc_EPC_out       => Exc_EPC_reg);

    -- Output the exception (and put exceptions through)
    exception_if_out <= exception_if_reg when NOP_to_L = '0' else
                        '0';
    exception_id_out <= exception_id_reg when NOP_to_L = '0' else
                        '0';
    exception_exe    <= exception_internal when NOP_to_L = '0' else
                        '0';
    -- Output the exception registers, change when needed
    Exc_BadVaddr_out <= Exc_BadVAddr_reg;
    Exc_EPC_out <= Exc_EPC_reg;
    -- ToDo Appendix A-35 something better
    Exc_Cause_out <= x"00000001" when exception_internal = '1' else
                     Exc_Cause_reg;


    -- NOP IMPLEMENTATION
    -- pulling to zero the bits that can modify the state of the processor seems enough (not all needed)
    addr_jump_out   <= addr_jump_reg;
    write_data_out  <= fwd_path_cache      when fwd_cache_regmem = '1' else
                        fwd_path_lookup     when fwd_lookup_regmem = '1' else
                       write_data_in;

    RegWrite_out    <= '0' when NOP_to_L = '1' or exception_internal = '1' else
                        RegWrite_reg;
                        
    Jump_out        <= '0' when NOP_to_L = '1' or exception_internal = '1' else
                       Jump_reg;
    Branch_out      <= '0' when NOP_to_L = '1' or exception_internal = '1' else
                       Branch_reg;
    
    MemRead_out     <= '0' when NOP_to_L = '1' or exception_internal = '1' else
                        MemRead_reg;
                            
    MemWrite_out    <= '0' when NOP_to_L = '1' or exception_internal = '1' else
                        MemWrite_reg;
    ByteAddress_out <= ByteAddress_reg;
    WordAddress_out <= WordAddress_reg;
    MemtoReg_out    <=  MemtoReg_reg;
    
    control : alu_control
    port map(opcode     => opcode_reg,
             funct      => sign_ext_reg(5 downto 0), --only 6 bits
             ALUOp_in   => ALUOp_reg,
             ALUOp_out  => ALUOp_control,
             SignedSrc  => SignedSrc,
             ShiftSrc   => ShiftSrc);
                
    addr_rt_out <= addr_rt_reg;
    
    shamt <= "000000000000000000000000000" & zero_ext_reg(10 downto 6);
    
    sign_immed_mux <= zero_ext_reg      when SignedSrc = '0' else
                      sign_ext_reg;
    
    alusrc_b_mux   <= rt_reg            when ALUSrc_reg = '0' else
                      sign_immed_mux;          

    shiftsrc_mux   <= alusrc_b_mux      when ShiftSrc = '0' else
                      shamt;
    
    alusrc_a_mux   <= rs_reg            when ShiftSrc = '0' else
                      rt_reg;
    
    integer_alu : alu
    port map(a        => alusrc_a_mux,
             b        => shiftsrc_mux,
             res      => alu_result,
             Zero     =>  Zero,
             Overflow => exception_internal,
             --CarryOut =>
             funct    => sign_ext_reg(5 downto 0),
             ALUOp    => ALUOp_control); 
    
    fwd_path_alu <= alu_result;
    alu_res      <= alu_result;
            
        
    addr_regw   <= addr_rt_reg  when RegDst_reg = '0' else
                   addr_rd_reg; 

                
    sign_ext_sh2 <= sign_ext_reg(29 downto 0)&"00";
            
    addr_branch  <= pc_up_reg + sign_ext_sh2;       
            
end Structure;
