library ieee;
use ieee.std_logic_1164.all;

entity lookup_cache_reg is
    port (-- buses
          addr_in              : in  std_logic_vector(31 downto 0);  --from LOOKUP
          addr_out             : out std_logic_vector(31 downto 0);  
          write_data_mem_in    : in  std_logic_vector(31 downto 0);  --from LOOKUP
          write_data_mem_out   : out std_logic_vector(31 downto 0);  
          addr_regw_in         : in  std_logic_vector(5 downto 0);   --from LOOKUP
          addr_regw_out        : out std_logic_vector(5 downto 0);   --to WB,ID
          busDataMem_in        : in  std_logic_vector(127 downto 0);  --from Main Memory
          busDataMem_out       : out std_logic_vector(127 downto 0);  --from Main Memory
          rob_addr_in      : in  std_logic_vector(2 downto 0);
          rob_addr_out     : out std_logic_vector(2 downto 0);
          -- control signals
          RegWrite_in          : in  std_logic;                      --from LOOKUP
          RegWrite_out         : out std_logic;                      --to WB, ID
          ByteAddress_in       : in  std_logic;                      --from LOOKUP
          ByteAddress_out      : out std_logic;                      
          WordAddress_in       : in  std_logic;                      --from LOOKUP
          WordAddress_out      : out std_logic;
          MemtoReg_in          : in  std_logic;                      --from LOOKUP
          MemtoReg_out         : out std_logic;
          FreeSlot_in          : in  std_logic;                 
          FreeSlot_out         : out std_logic;
          -- interface with data_cache data
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
      
end lookup_cache_reg;

architecture Structure of lookup_cache_reg is
begin

    lookup_cache_reg : process(clk)
    begin
        if (enable = '1') then
            if (rising_edge(clk)) then
                addr_out            <= addr_in;
                write_data_mem_out  <= write_data_mem_in;
                addr_regw_out       <= addr_regw_in;
                busDataMem_out      <= busDataMem_in;
                rob_addr_out        <= rob_addr_in;
                     
                RegWrite_out        <= RegWrite_in;
                ByteAddress_out     <= ByteAddress_in;
                WordAddress_out     <= WordAddress_in;
                MemtoReg_out        <= MemtoReg_in;     

					 FreeSlot_out        <= FreeSlot_in;
					 
                WriteCache_out      <= WriteCache_in;                  
                muxDataR_out        <= muxDataR_in;
                muxDataW_out        <= muxDataW_in;

                -- forward of exception identifier bits
                exception_if_out    <= exception_if_in;
                exception_id_out    <= exception_id_in;
                exception_exe_out   <= exception_exe_in;
                exception_lookup_out<= exception_lookup_in;
                -- forward of registers
                Exc_EPC_out         <= Exc_EPC_in;
                Exc_Cause_out       <= Exc_Cause_in;
                Exc_BadVAddr_out    <= Exc_BadVAddr_in;
            end if;
        end if;
    end process;    
    
end Structure;
            
