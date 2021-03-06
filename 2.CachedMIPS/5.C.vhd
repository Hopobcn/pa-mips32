library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cache is
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
          BusReady             : in  std_logic;                      --from L
          WriteCache           : in  std_logic;                      --to CACHE
          muxDataR             : in  std_logic;                      --to CACHE
          muxDataW             : in  std_logic;                      --to CACHE 
          -- interface with Hazard Control
          NOP_to_WB            : in  std_logic;                      --from Hazard Control
          -- interface with ROB
          MemComplete_in       : in  std_logic;
          MemComplete_out      : out std_logic;
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
          Exc_EPC_out          : out std_logic_vector(31 downto 0));   --to coprocessor 0 register file);          

end cache;

architecture Structure of cache is

    component lookup_cache_reg is
     port (-- buses
           addr_in              : in  std_logic_vector(31 downto 0);  --from LOOKUP
           addr_out             : out std_logic_vector(31 downto 0);  
           write_data_mem_in    : in  std_logic_vector(31 downto 0);  --from LOOKUP
           write_data_mem_out   : out std_logic_vector(31 downto 0);  
           addr_regw_in         : in  std_logic_vector(5 downto 0);   --from LOOKUP
           addr_regw_out        : out std_logic_vector(5 downto 0);   --to WB,ID
           busDataMem_in        : in  std_logic_vector(127 downto 0);  --from Main Memory
           busDataMem_out       : out std_logic_vector(127 downto 0);  --from Main Memory
           rob_addr_in          : in  std_logic_vector(2 downto 0);
           rob_addr_out         : out std_logic_vector(2 downto 0);
           -- control signals
           RegWrite_in          : in  std_logic;                      --from LOOKUP
           RegWrite_out         : out std_logic;                      --to WB, ID
           ByteAddress_in       : in  std_logic;                      --from LOOKUP
           ByteAddress_out      : out std_logic;                      
           WordAddress_in       : in  std_logic;                      --from LOOKUP
           WordAddress_out      : out std_logic;
           MemtoReg_in          : in  std_logic;                      --from LOOKUP
           MemtoReg_out         : out std_logic;                      --from LOOKUP
           FreeSlot_in          : in  std_logic;                 
           FreeSlot_out         : out std_logic; 
           MemComplete_in       : in  std_logic;
           MemComplete_out      : out std_logic;
           -- interface with data_cache data
			 BusReady_in          : in  std_logic;
			 BusReady_out         : out std_logic;
           WriteCache_in        : in  std_logic;                      --to CACHE
           WriteCache_out       : out std_logic;                    
           muxDataR_in          : in  std_logic;                      --to CACHE
           muxDataR_out         : out std_logic;                   
           muxDataW_in          : in  std_logic;                      --to CACHE 
           muxDataW_out         : out std_logic;   
           -- register control signals
           enable               : in  std_logic;
           clk                  : in  std_logic;                
           -- exception bits
          exception_if_in      : in  std_logic;
          exception_if_out     : out std_logic;
          exception_id_in      : in  std_logic;
          exception_id_out     : out std_logic;
          exception_exe_in     : in  std_logic;
          exception_exe_out    : out std_logic;
          exception_lookup_in  : in std_logic;
          exception_lookup_out : out std_logic;
          -- Exception-related registers
          Exc_BadVAddr_in      : in  std_logic_vector(31 downto 0);    --from previous stage (pipelined)
          Exc_BadVAddr_out     : out std_logic_vector(31 downto 0);    --to coprocessor 0 register file
          Exc_Cause_in         : in  std_logic_vector(31 downto 0);    --from previous stage (pipelined)
          Exc_Cause_out        : out std_logic_vector(31 downto 0);    --to coprocessor 0 register file
          Exc_EPC_in           : in  std_logic_vector(31 downto 0);    --from previous stage (pipelined)
          Exc_EPC_out          : out std_logic_vector(31 downto 0));
    end component;

     component data_cache_data is
    port (addr          : in     std_logic_vector(31 downto 0);
          busDataMem    : in     std_logic_vector(127 downto 0);
          write_data    : in     std_logic_vector(31 downto 0);
          read_data     : out    std_logic_vector(31 downto 0);
          -- control signals
             ByteAddress   : in     std_logic;                      
          WordAddress   : in     std_logic; 
             muxDataR      : in     std_logic;                 
          muxDataW      : in     std_logic;
          WriteEnable   : in     std_logic);
    end component;

    signal addr_reg          : std_logic_vector(31 downto 0); 
    signal write_data_mem_reg: std_logic_vector(31 downto 0); 
     signal busDataMem_reg    : std_logic_vector(127 downto 0); 
     signal load_data         : std_logic_vector(31 downto 0);
    signal addr_regw_reg     : std_logic_vector(5 downto 0);
    signal rob_addr_reg      : std_logic_vector(2 downto 0);
    signal RegWrite_reg      : std_logic;
    signal ByteAddress_reg   : std_logic;                 
    signal WordAddress_reg   : std_logic;    
    signal MemtoReg_reg      : std_logic;   
	 signal BusReady_reg      : std_logic; 
    signal WriteCache_reg    : std_logic;
    signal muxDataR_reg      : std_logic;
    signal muxDataW_reg      : std_logic; 
            
    signal exception_if_reg   : std_logic;
    signal exception_id_reg   : std_logic;
    signal exception_exe_reg  : std_logic;
     signal exception_lookup_reg : std_logic;
    signal exception_internal : std_logic;
    -- Exception buses
    signal Exc_BadVAddr_reg  : std_logic_vector(31 downto 0);
    signal Exc_Cause_reg     : std_logic_vector(31 downto 0);
    signal Exc_EPC_reg       : std_logic_vector(31 downto 0);
    
    signal enable            : std_logic;
begin
 
    enable <= '1'; -- Aquesta etapa mai fa Stall, com a molt posem NOPS

    -- EXE/MEM Register 
    LOOKUP_CACHE_register : lookup_cache_reg
    port map(addr_in              => addr,
             addr_out             => addr_reg,
             write_data_mem_in    => write_data_mem,
             write_data_mem_out   => write_data_mem_reg,
             addr_regw_in         => addr_regw_in,
             addr_regw_out        => addr_regw_reg,
             rob_addr_in          => rob_addr_in,
             rob_addr_out         => rob_addr_reg,
             busDataMem_in        => busDataMem,
             busDataMem_out       => busDataMem_reg,
             RegWrite_in          => RegWrite_in,
             RegWrite_out         => RegWrite_reg,
             ByteAddress_in       => ByteAddress,
             ByteAddress_out      => ByteAddress_reg,
             WordAddress_in       => WordAddress,
             WordAddress_out      => WordAddress_reg,
             MemtoReg_in          => MemtoReg,
             MemtoReg_out         => MemtoReg_reg,
             FreeSlot_in          => FreeSlot_in,
             FreeSlot_out         => FreeSlot_out,
             MemComplete_in       => MemComplete_in,
             MemComplete_out      => MemComplete_out,
             BusReady_in          => BusReady,
             BusReady_out         => BusReady_reg,
             WriteCache_in        => WriteCache,
             WriteCache_out       => WriteCache_reg,
             muxDataR_in          => muxDataR,
             muxDataR_out         => muxDataR_reg,
             muxDataW_in          => muxDataW,
             muxDataW_out         => muxDataW_reg,
             enable               => enable,
             clk                  => clk,
                -- exception bits
             exception_if_in      => exception_if_in,
             exception_if_out     => exception_if_reg,
             exception_id_in      => exception_id_in,
             exception_id_out     => exception_id_reg,
             exception_exe_in     => exception_exe_in,
             exception_exe_out    => exception_exe_reg,
             exception_lookup_in  => exception_lookup_in,
             exception_lookup_out => exception_lookup_reg,
             -- Exception-related registers
             Exc_BadVAddr_in      => Exc_BadVAddr_in,
             Exc_BadVAddr_out     => Exc_BadVAddr_reg,
             Exc_Cause_in         => Exc_Cause_in,
             Exc_Cause_out        => Exc_Cause_reg,
             Exc_EPC_in           => Exc_EPC_in,
             Exc_EPC_out          => Exc_EPC_reg);
             
     addr_regw_out <= addr_regw_reg;
     
     rob_addr_out <= rob_addr_reg;
     
     write_data_reg <= addr_reg    when MemtoReg_reg = '0' else
                       load_data;
        
    fwd_path_cache <= addr_reg    when MemtoReg_reg = '0' else
                       load_data;
     
     -- NOP
    RegWrite_out    <= '0' when NOP_to_WB = '1' or exception_internal = '1' else
                        RegWrite_reg;
        
    DATA_CACHE : data_cache_data
    port map(addr        => addr_reg,
             busDataMem  => busDataMem_reg,
             write_data  => write_data_mem_reg,
             read_data   => load_data,
             ByteAddress => ByteAddress_reg,
             WordAddress => WordAddress_reg,
             muxDataR    => muxDataR_reg,
             muxDataW    => muxDataW_reg,
             WriteEnable => WriteCache_reg);

	  
    -- Exception (to be fully implemented with virtual memory)
    exception_internal <= '0';
    
    -- Output the exception (and put exceptions through)
    exception_if_out  <= exception_if_reg when NOP_to_WB = '0' else
                        '0';
    exception_id_out  <= exception_id_reg when NOP_to_WB = '0' else
                        '0';
    exception_exe_out <= exception_exe_reg when NOP_to_WB = '0' else
                        '0';
    exception_lookup_out  <= exception_lookup_reg when NOP_to_WB = '0' else
                             '0';
    exception_cache   <= exception_internal when NOP_to_WB = '0' else
                          '0';
                                 
    -- Output the exception registers, change when needed
    Exc_BadVaddr_out <= addr_reg when exception_internal = '1' else
                        Exc_BadVAddr_reg;
    Exc_EPC_out <= Exc_EPC_reg;
    -- ToDo Appendix A-35 something better
    Exc_Cause_out <= x"00000001" when exception_internal = '1' else
                     Exc_Cause_reg;
             
     
    
end Structure;
