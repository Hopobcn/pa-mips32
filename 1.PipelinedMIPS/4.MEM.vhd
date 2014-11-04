library ieee;
use ieee.std_logic_1164.all;

entity mem is
    port (-- buses
            addr_branch_in  :   in std_logic_vector(31 downto 0);   --from MEM
            addr_branch_out :   out std_logic_vector(31 downto 0);  --to IF
            addr            :   in std_logic_vector(31 downto 0);   --from EXE --named alu_res in EXE
            write_data_mem  :   in std_logic_vector(31 downto 0);   --from EXE
            write_data_rb   :   out std_logic_vector(31 downto 0);  -- to WB
            addr_regw_in    :   in  std_logic_vector(4 downto 0);   --from EXE
            addr_regw_out   :   out std_logic_vector(4 downto 0);   --to WB, then IF
            fwd_path_mem    :   out std_logic_vector(31 downto 0);  --to ID [FWD]
            -- control signals
            clk             :   in std_logic;
            RegWrite_in     :   in std_logic;                       --from EXE
            RegWrite_out    :   out std_logic;                      --to WB, then ID
            Branch          :   in std_logic;                       --from EXE
            BranchTaken     :   out std_logic;                      --to control (identify end of branch stall)
            PCSrc           :   out std_logic;                      --to ID
            MemRead         :   in std_logic;                       --from EXE
            MemWrite        :   in std_logic;                       --from EXE;
            ByteAddress     :   in std_logic;                       --from EXE
            WordAddress     :   in  std_logic;                      --from EXE
            MemtoReg        :   in std_logic;                       --from MEM
            Zero            :   in std_logic;                       --from EXE
            NOP_to_WB       :   in std_logic;
            Stall           :   in std_logic;
            -- exception bits
            exception_if_in :   in  std_logic;
            exception_if_out:   out std_logic;
            exception_id_in :   in  std_logic;
            exception_id_out:   out std_logic;
            exception_exe_in  : in  std_logic;
            exception_exe_out : out std_logic;
            exception_mem     : out std_logic);
            
end mem;

architecture Structure of mem is
    
    component exe_mem_reg is
    port (-- buses
            addr_branch_in  :   in  std_logic_vector(31 downto 0);  
            addr_branch_out :   out std_logic_vector(31 downto 0);
            addr_in         :   in  std_logic_vector(31 downto 0);  
            addr_out        :   out std_logic_vector(31 downto 0);
            write_data_in   :   in  std_logic_vector(31 downto 0);
            write_data_out  :   out std_logic_vector(31 downto 0);  
            addr_regw_in    :   in  std_logic_vector(4 downto 0);       
            addr_regw_out   :   out std_logic_vector(4 downto 0);
            -- control signals
            RegWrite_in     :   in  std_logic;                              
            RegWrite_out    :   out std_logic;      
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
            Zero_in         :   in  std_logic;
            Zero_out        :   out std_logic;  
            -- register control signals
            enable          :   in std_logic;
            clk             :   in std_logic;
            
            -- exceptions
            exception_if_in   : in std_logic;
            exception_if_out  : out std_logic;
            exception_id_in   : in std_logic;
            exception_id_out  : out std_logic;
            exception_exe_in  : in std_logic;
            exception_exe_out : out std_logic);

    end component;

    signal addr_branch_reg      :   std_logic_vector(31 downto 0);  
    signal addr_reg             :   std_logic_vector(31 downto 0);  
    signal write_data_mem_reg   :   std_logic_vector(31 downto 0);
    signal addr_regw_reg        :   std_logic_vector(4 downto 0);   
    signal RegWrite_reg         :   std_logic;                          
    signal Jump_reg             :   std_logic;      
    signal Branch_reg           :   std_logic;      
    signal MemRead_reg          :   std_logic;  
    signal MemWrite_reg         :   std_logic;  
    signal ByteAddress_reg      :  std_logic;   
    signal WordAddress_reg      :   std_logic;  
    signal MemtoReg_reg         :   std_logic;      
    signal Zero_reg             :   std_logic;
            
    component data_mem is
    port (addr          :   in std_logic_vector(31 downto 0);
            write_data  :   in std_logic_vector(31 downto 0);
            read_data   :   out std_logic_vector(31 downto 0);
            clk         :   in std_logic;
            MemRead     :   in std_logic;
            MemWrite    :   in  std_logic;
            ByteAddress :   in std_logic;
            WordAddress :   in  std_logic);
    end component;
    
    signal read_data_mem    :   std_logic_vector(31 downto 0);
    signal bypass_mem       :   std_logic_vector(31 downto 0);
    signal load_or_bypass   :   std_logic_vector(31 downto 0);
    
    signal exception_if_reg   : std_logic;
    signal exception_id_reg   : std_logic;
    signal exception_exe_reg  : std_logic;
    signal exception_internal : std_logic;
    
    signal enable           : std_logic;
begin
 
  enable <= not Stall;

    -- EXE/MEM Register 
    EXE_MEM_register : exe_mem_reg
    port map(addr_branch_in => addr_branch_in,
             addr_branch_out=> addr_branch_reg,
             addr_in        => addr,
             addr_out       => addr_reg,
             write_data_in  => write_data_mem,
             write_data_out => write_data_mem_reg,
             addr_regw_in   => addr_regw_in,
             addr_regw_out  => addr_regw_reg,
             RegWrite_in    => RegWrite_in,             
             RegWrite_out   => RegWrite_reg,    
             Branch_in      => Branch,
             Branch_out     => Branch_reg,
             MemRead_in     => MemRead,
             MemRead_out    => MemRead_reg,
             MemWrite_in    => MemWrite,
             MemWrite_out   => MemWrite_reg,
             ByteAddress_in => ByteAddress,
             ByteAddress_out=> ByteAddress_reg,
             WordAddress_in => WordAddress,
             WordAddress_out=> WordAddress_reg,
             MemtoReg_in    => MemtoReg,
             MemtoReg_out   => MemtoReg_reg,
             Zero_in        => Zero,
             Zero_out       => Zero_reg,
             enable         => enable,
             clk            => clk,
             -- exception
             exception_if_in   => exception_if_in,
             exception_if_out  => exception_if_reg,
             exception_id_in   => exception_id_in,
             exception_id_out  => exception_id_reg,
             exception_exe_in  => exception_exe_in,
             exception_exe_out => exception_exe_reg);
    
    
    addr_branch_out  <= addr_branch_reg;
    addr_regw_out    <= addr_regw_reg;
    bypass_mem       <= addr_reg;
    
    -- Exception (to be fully implemented with virtual memory)
    exception_internal <= '0';
    
    -- Output the exception (and put exceptions through)
    exception_if_out <= exception_if_reg when NOP_to_WB = '0' else
                        '0';
    exception_id_out <= exception_id_reg when NOP_to_WB = '0' else
                        '0';
    exception_exe_out <= exception_exe_reg when NOP_to_WB = '0' else
                         '0';
    exception_mem <= exception_internal when NOP_to_WB = '0' else
                     '0';

    
    -- NOP
    RegWrite_out    <= '0' when NOP_to_WB = '1' or exception_internal = '1' else
                        RegWrite_reg;
                        
    -- 1 branch taken, 0 otherwise
    BranchTaken     <= '0' when NOP_to_WB = '1' or exception_internal = '1' else
                       Branch_reg and Zero_reg; 
                       
    PCSrc           <= '0' when NOP_to_WB = '1' or exception_internal = '1' else
                       Branch_reg and Zero_reg; 
    
    data_memory : data_mem
    port map(addr           => addr_reg,
             write_data     =>  write_data_mem_reg,
             read_data      =>  read_data_mem,
             clk            => clk,
             MemRead        => MemRead_reg,
             MemWrite       => MemWrite_reg,
             ByteAddress    => ByteAddress_reg,
             WordAddress    =>  WordAddress_reg);
                
    load_or_bypass <=   bypass_mem when MemtoReg_reg = '0' else
                        read_data_mem;
            
    write_data_rb   <= load_or_bypass;
    fwd_path_mem    <= load_or_bypass;          
end Structure;
