library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity lookup is
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
          rob_addr_in        : in  std_logic_vector(2 downto 0);   --from EXE (ReOrderBuffer-related)
          rob_addr_out       : out std_logic_vector(2 downto 0);
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
            
end lookup;

architecture Structure of lookup is
    component exe_lookup_reg is
    port (-- buses
          addr_branch_in   : in  std_logic_vector(31 downto 0);  
          addr_branch_out  : out std_logic_vector(31 downto 0);
          addr_in          : in  std_logic_vector(31 downto 0);  
          addr_out         : out std_logic_vector(31 downto 0);
          write_data_in    : in  std_logic_vector(31 downto 0);
          write_data_out   : out std_logic_vector(31 downto 0);  
          addr_regw_in     : in  std_logic_vector(5 downto 0);       
          addr_regw_out    : out std_logic_vector(5 downto 0);
          rob_addr_in      : in  std_logic_vector(2 downto 0);
          rob_addr_out     : out std_logic_vector(2 downto 0);
          -- control signals
          RegWrite_in      : in  std_logic;                              
          RegWrite_out     : out std_logic;      
          Branch_in        : in  std_logic;      
          Branch_out       : out std_logic;      
          MemRead_in       : in  std_logic;  
          MemRead_out      : out std_logic;  
          MemWrite_in      : in  std_logic;  
          MemWrite_out     : out std_logic;  
          ByteAddress_in   : in  std_logic;  
          ByteAddress_out  : out std_logic;  
          WordAddress_in   : in  std_logic;  
          WordAddress_out  : out std_logic;
          MemtoReg_in      : in  std_logic;      
          MemtoReg_out     : out std_logic;
          Zero_in          : in  std_logic;
          Zero_out         : out std_logic;  
          -- register control signals
          enable           : in  std_logic;
          clk              : in  std_logic;
          -- exception identifier bits
          exception_if_in  : in  std_logic;
          exception_if_out : out std_logic;
          exception_id_in  : in  std_logic;
          exception_id_out : out std_logic;
          exception_exe_in : in  std_logic;
          exception_exe_out: out std_logic;
          -- exception registers
          Exc_EPC_in       : in  std_logic_vector(31 downto 0);
          Exc_EPC_out      : out std_logic_vector(31 downto 0);
          Exc_Cause_in     : in  std_logic_vector(31 downto 0);
          Exc_Cause_out    : out std_logic_vector(31 downto 0);
          Exc_BadVAddr_in  : in  std_logic_vector(31 downto 0);
          Exc_BadVAddr_out : out std_logic_vector(31 downto 0));

    end component;

    signal addr_branch_reg      :   std_logic_vector(31 downto 0);  
    signal addr_reg             :   std_logic_vector(31 downto 0);  
    signal write_data_mem_reg   :   std_logic_vector(31 downto 0);
    signal addr_regw_reg        :   std_logic_vector(5 downto 0);   
    signal rob_addr_reg         :   std_logic_vector(2 downto 0);
    signal RegWrite_reg         :   std_logic;
    signal Branch_reg           :   std_logic;
    signal MemRead_reg          :   std_logic;
    signal MemWrite_reg         :   std_logic;
    signal ByteAddress_reg      :   std_logic;
    signal WordAddress_reg      :   std_logic;
    signal MemtoReg_reg         :   std_logic;
    signal Zero_reg             :   std_logic;
    
    signal WriteCache_reg       :   std_logic;
    
    component data_cache_lookup is
    port (addr        :  in  std_logic_vector(31 downto 0);
          -- control signals;
          PrRd        :  in  std_logic;
          PrWr        :  in  std_logic;
          Ready       :  out std_logic;
          WriteCache  :  out std_logic;
          -- periferics
          muxDataR    :  out std_logic;
          muxDataW    :  out std_logic;
          -- Interface with memory
          BusRd       :  out std_logic;
          BusWr       :  out std_logic;
          BusReady    :  in  std_logic;
          clk         :  in  std_logic;
          reset       :  in  std_logic);
    end component;    
          
    signal exception_if_reg   : std_logic;
    signal exception_id_reg   : std_logic;
    signal exception_exe_reg  : std_logic;
    signal exception_internal : std_logic;
    -- Exception buses
    signal Exc_BadVAddr_reg  : std_logic_vector(31 downto 0);
    signal Exc_Cause_reg     : std_logic_vector(31 downto 0);
    signal Exc_EPC_reg       : std_logic_vector(31 downto 0);
    
    signal enable            : std_logic;
begin
 
    enable <= not Stall;

    -- EXE/LOOKUP Register 
    EXE_LOOKUP_register : exe_lookup_reg
    port map(addr_branch_in => addr_branch_in,
             addr_branch_out=> addr_branch_reg,
             addr_in        => addr_in,
             addr_out       => addr_reg,
             write_data_in  => write_data_mem_in,
             write_data_out => write_data_mem_reg,
             addr_regw_in   => addr_regw_in,
             addr_regw_out  => addr_regw_reg,
             rob_addr_in    => rob_addr_in,
             rob_addr_out   => rob_addr_reg,
             RegWrite_in    => RegWrite_in,             
             RegWrite_out   => RegWrite_reg,    
             Branch_in      => Branch,
             Branch_out     => Branch_reg,
             MemRead_in     => MemRead,
             MemRead_out    => MemRead_reg,
             MemWrite_in    => MemWrite,
             MemWrite_out   => MemWrite_reg,
             ByteAddress_in => ByteAddress_in,
             ByteAddress_out=> ByteAddress_reg,
             WordAddress_in => WordAddress_in,
             WordAddress_out=> WordAddress_reg,
             MemtoReg_in    => MemtoReg_in,
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
             exception_exe_out => exception_exe_reg,
             -- Exception buses
             Exc_BadVAddr_in   => Exc_BadVAddr_in,
             Exc_BadVAddr_out  => Exc_BadVAddr_reg,
             Exc_Cause_in      => Exc_Cause_in,
             Exc_Cause_out     => Exc_Cause_reg,
             Exc_EPC_in        => Exc_EPC_in,
             Exc_EPC_out       => Exc_EPC_reg);
    
    
    addr_branch_out    <= addr_branch_reg;
    addr_out           <= addr_reg;
    write_data_mem_out <= write_data_mem_reg;
    addr_regw_out      <= addr_regw_reg;
    rob_addr_out       <= rob_addr_reg;
    fwd_path_lookup    <= addr_reg; 

     TAGS_AND_STATE : data_cache_lookup
    port map(addr       => addr_reg,
             PrRd       => MemRead_reg,
             PrWr       => MemWrite_reg,
             Ready      => DC_Ready,
             WriteCache => WriteCache_reg,
             muxDataR   => muxDataR,
             muxDataW   => muxDataW,
             BusRd      => BusRd,
             BusWr      => BusWr,
             BusReady   => BusReady,
             clk        => clk,
             reset      => boot );
             
     -- NOP
    RegWrite_out    <= '0' when NOP_to_C = '1' or exception_internal = '1' else
                        RegWrite_reg;
                        
    -- 1 branch taken, 0 otherwise
    BranchTaken     <= '0' when NOP_to_C = '1' or exception_internal = '1' else
                       Branch_reg and Zero_reg; 
                       
    PCSrc           <= '0' when NOP_to_C = '1' or exception_internal = '1' else
                       Branch_reg and Zero_reg; 
    
    ByteAddress_out <= ByteAddress_reg;
    WordAddress_out <= WordAddress_reg;
    MemtoReg_out    <=  MemtoReg_reg;
     
    WriteCache      <= '0' when NOP_to_C = '1' or exception_internal = '1' else
                         WriteCache_reg;

     
    -- Exception (to be fully implemented with virtual memory)
    exception_internal <= '0';
    
    -- Output the exception (and put exceptions through)
    exception_if_out  <= exception_if_reg when NOP_to_C = '0' else
                        '0';
    exception_id_out  <= exception_id_reg when NOP_to_C = '0' else
                        '0';
    exception_exe_out <= exception_exe_reg when NOP_to_C = '0' else
                        '0';
    exception_lookup  <= exception_internal when NOP_to_C = '0' else
                        '0';
    -- Output the exception registers, change when needed
    Exc_BadVaddr_out <= addr_reg when exception_internal = '1' else
                        Exc_BadVAddr_reg;
    Exc_EPC_out      <= Exc_EPC_reg;
    -- ToDo Appendix A-35 something better
    Exc_Cause_out    <= x"00000001" when exception_internal = '1' else
                        Exc_Cause_reg;
        
end Structure;
