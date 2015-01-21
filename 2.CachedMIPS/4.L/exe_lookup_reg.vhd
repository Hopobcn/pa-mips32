library ieee;
use ieee.std_logic_1164.all;

entity exe_lookup_reg is
    port (-- buses
          addr_branch_in   : in  std_logic_vector(31 downto 0);  
          addr_branch_out  : out std_logic_vector(31 downto 0);
          addr_in          : in  std_logic_vector(31 downto 0);  
          addr_out         : out std_logic_vector(31 downto 0);
          write_data_in    : in  std_logic_vector(31 downto 0);
          write_data_out   : out std_logic_vector(31 downto 0);  
          addr_regw_in     : in  std_logic_vector(5 downto 0);       
          addr_regw_out    : out std_logic_vector(5 downto 0);
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
      
end exe_lookup_reg;

architecture Structure of exe_lookup_reg is
begin

    exe_lookup_reg : process(clk)
    begin
        if (enable = '1') then
            if (rising_edge(clk)) then
                addr_branch_out     <= addr_branch_in;
                addr_out            <= addr_in;
                write_data_out      <= write_data_in;
                addr_regw_out       <= addr_regw_in;
                RegWrite_out        <= RegWrite_in;
                Branch_out          <= Branch_in;
                MemRead_out         <= MemRead_in;
                MemWrite_out        <= MemWrite_in;
                ByteAddress_out     <= ByteAddress_in;
                WordAddress_out     <= WordAddress_in;
                MemtoReg_out        <= MemtoReg_in;
                Zero_out            <= Zero_in;         
                -- forward of exception identifier bits
                exception_if_out    <= exception_if_in;
                exception_id_out    <= exception_id_in;
                exception_exe_out   <= exception_exe_in;
                -- forward of registers
                Exc_EPC_out         <= Exc_EPC_in;
                Exc_Cause_out       <= Exc_Cause_in;
                Exc_BadVAddr_out    <= Exc_BadVAddr_in;

            end if;
        end if;
    end process;    
    
end Structure;
            
