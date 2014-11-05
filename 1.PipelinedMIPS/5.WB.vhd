library ieee;
use ieee.std_logic_1164.all;

entity write_back is
    port (-- buses
            write_data_in   :   in std_logic_vector(31 downto 0);   --from MEM
            write_data_out  :   out std_logic_vector(31 downto 0);  --to IF
            addr_regw_in    :   in  std_logic_vector(4 downto 0);   --from MEM
            addr_regw_out   :   out std_logic_vector(4 downto 0);   --to IF
            -- control signals
            clk             :   in std_logic;
            RegWrite_in     :   in std_logic;
            RegWrite_out    :   out std_logic;
            -- Exception-related registers
            Exc_BadVAddr_in  : in std_logic_vector(31 downto 0);     --from previous stage (pipelined)
            Exc_BadVAddr_out : out std_logic_vector(31 downto 0);    --to coprocessor 0 register file
            Exc_Cause_in     : in std_logic_vector(31 downto 0);     --from previous stage (pipelined)
            Exc_Cause_out    : out std_logic_vector(31 downto 0);    --to coprocessor 0 register file
            Exc_EPC_in       : in std_logic_vector(31 downto 0);     --from previous stage (pipelined)
            Exc_EPC_out      : out std_logic_vector(31 downto 0);    --to coprocessor 0 register file
            -- Write enabling bits from exception control
            writeEPC_in       : in std_logic;       --from Exception Control
            writeEPC_out      : out std_logic;      --to coprocessor 0 register file
            writeBadVAddr_in  : in std_logic;       --from Exception Control
            writeBadVAddr_out : out std_logic;      --to coprocessor 0 register file
	          writeCause_in     : in std_logic;       --from Exception Control
 	          writeCause_out    : out std_logic       --to coprocessor 0 register file
	          );
            
end write_back;

architecture Structure of write_back is
    
    component mem_wb_reg is
    port (-- buses  
            write_data_in   :   in  std_logic_vector(31 downto 0);  
            write_data_out  :   out std_logic_vector(31 downto 0);
            addr_regw_in    :   in  std_logic_vector(4 downto 0);   
            addr_regw_out   :   out std_logic_vector(4 downto 0);   
            -- control signals
            RegWrite_in     :   in  std_logic;
            RegWrite_out    :   out std_logic;
            -- register control signals
            enable          :   in  std_logic;
            clk             :   in  std_logic;
            -- Exception-related registers
            Exc_BadVAddr_in  : in std_logic_vector(31 downto 0);
            Exc_BadVAddr_out : out std_logic_vector(31 downto 0);
            Exc_Cause_in     : in std_logic_vector(31 downto 0);
            Exc_Cause_out    : out std_logic_vector(31 downto 0);
            Exc_EPC_in       : in std_logic_vector(31 downto 0);
            Exc_EPC_out      : out std_logic_vector(31 downto 0);
            
            -- Write enabling bits from exception control
            writeEPC_in       : in std_logic;
            writeEPC_out      : out std_logic;
            writeBadVAddr_in  : in std_logic;
            writeBadVAddr_out : out std_logic;
            writeCause_in     : in std_logic;
	          writeCause_out    : out std_logic);

    end component;

    signal write_data_reg   :   std_logic_vector(31 downto 0);
    signal addr_regw_reg    :   std_logic_vector(4 downto 0);       
    signal RegWrite_reg     :   std_logic;
    signal MemtoReg_reg     :   std_logic;
    
    -- Exception buses
    signal Exc_BadVAddr_reg  : std_logic_vector(31 downto 0);
    signal Exc_Cause_reg     : std_logic_vector(31 downto 0);
    signal Exc_EPC_reg       : std_logic_vector(31 downto 0);
    -- Exception write enable bits
    signal writeEPC_reg      : std_logic;
    signal writeBadVAddr_reg : std_logic;
    signal writeCause_reg    : std_logic;
    
begin
    
    -- MEM/WB Register 
    MEM_WB_register : mem_wb_reg
    port map(write_data_in      => write_data_in,
                write_data_out  => write_data_reg,
                addr_regw_in    => addr_regw_in,
                addr_regw_out   => addr_regw_reg,
                RegWrite_in     => RegWrite_in,
                RegWrite_out    => RegWrite_reg,
                enable          => '1',
                clk             => clk,
                -- Exception buses
                Exc_BadVAddr_in   => Exc_BadVAddr_in,
                Exc_BadVAddr_out  => Exc_BadVAddr_reg,
                Exc_Cause_in      => Exc_Cause_in,
                Exc_Cause_out     => Exc_Cause_reg,
                Exc_EPC_in        => Exc_EPC_in,
                Exc_EPC_out       => Exc_EPC_reg,
                -- Exception bits (from control)
                writeEPC_in       => writeEPC_in,
                writeEPC_out      => writeEPC_reg,
                writeCause_in     => writeCause_in,
                writeCause_out    => writeCause_reg,
                writeBadVAddr_in  => writeBadVAddr_in,
                writeBadVAddr_out => writeBadVAddr_reg);
                
    addr_regw_out   <=  addr_regw_reg;
    
    RegWrite_out    <= RegWrite_reg;
    
    write_data_out  <= write_data_reg;
    
    -- Exception signals
    Exc_BadVAddr_out <= Exc_BadVAddr_reg;
    Exc_Cause_out <= Exc_Cause_reg;
    Exc_EPC_out <= Exc_EPC_in;
    writeEPC_out <= writeEPC_reg;
    writeCause_out <= writeCause_reg;
    writeBadVAddr_out <= writeBadVAddr_reg;    
        
end Structure;
