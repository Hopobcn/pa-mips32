library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity ddata is
    port (-- data buses
          index         : in  std_logic_vector(4 downto 0); -- 32 containers == 5 bits of index
          block_offset  : in  std_logic_vector(1 downto 0); -- offset inside a container (1 container == 4 words)
          write_data    : in  std_logic_vector(31 downto 0);
          read_data     : out std_logic_vector(31 downto 0);
          -- control signals
          WriteEnable   : in  std_logic);
end ddata;

architecture Structure of ddata is
    type ARRAY_DATA is array (2**5-1 downto 0) of std_logic_vector(127 downto 0);
    signal mem_data : ARRAY_DATA;

    signal container_128 : std_logic_vector(127 downto 0);
begin
    
    container_128 <= mem_data(to_integer(unsigned(index)));

    read_data <= container_128( 31 downto  0) when block_offset = "00" else
	              container_128( 63 downto 32) when block_offset = "01" else
					  container_128( 95 downto 64) when block_offset = "10" else
					  container_128(127 downto 96);

    data_write : process(index)
    begin
        if (writeEnable = '1') then
            mem_data(to_integer(unsigned(index)))(31 downto 0) <= write_data;
        end if;
    end process data_write;

end Structure;
