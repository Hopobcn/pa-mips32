library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_cache_data is
    port (addr          : in  std_logic_vector(31 downto 0);
          busDataMem    : in  std_logic_vector(31 downto 0);
          write_data    : in  std_logic_vector(31 downto 0);
          read_data     : out std_logic_vector(31 downto 0);
          -- control signals
			 ByteAddress   : in  std_logic;                      
          WordAddress   : in  std_logic; 
			 muxDataR      : in  std_logic;                 
          muxDataW      : in     std_logic;
          WriteEnable   : in    std_logic);
end data_cache_data;

architecture Structure of data_cache_data is
    
    component data is
    port (-- data buses
          index         : in  std_logic_vector(4 downto 0); -- 32 containers == 5 bits of index
          block_offset  : in  std_logic_vector(1 downto 0); -- offset inside a container (1 container == 4 words)
          write_data    : in  std_logic_vector(31 downto 0);
          read_data     : out std_logic_vector(31 downto 0);
          -- control signals
          WriteEnable   : in  std_logic);
    end component;
	 
    signal readCache        : std_logic_vector(31 downto 0);
    signal writeCache       : std_logic_vector(31 downto 0);
	 
	 signal readByte         : std_logic_vector(31 downto 0);
begin

    DATA : data
    port map(index        <= addr(6 downto 2)),
             block_offset <= addr(1 downto 0),; 
             write_data   <= writeCache,
             read_data    <= readCache,
             WriteEnable  <= WriteEnable)
			 
    writeCache <= write_data when muxDataW = '0' else
                  busDataMem;
            
    mux_word_half_byte : process(readCache,busDataMem,ByteAddress,WordAddress)
    begin
	     if (muxDataR = '0') then
            if (ByteAddress = '1') then
                read_data <= x"0000" & readCache(7 downto 0); 
            elsif (ByteAddress = '0' and WordAddress = '1') then
                read_data <= x"0000" & readCache(15 downto 0);
            else
                read_data <= readCache;		  
            end if;
        else
            if (ByteAddress = '1') then
                read_data <= x"0000" & busDataMem(7 downto 0); 
            elsif (ByteAddress = '0' and WordAddress = '1') then
                read_data <= x"0000" & busDataMem(15 downto 0);
            else
                read_data <= busDataMem;		  
            end if;
    end process mux_word_half_byte;				
						
end Structure;
