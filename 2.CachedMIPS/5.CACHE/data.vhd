library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity data is
    port (-- data buses
          index         : in std_logic_vector(4 downto 0); -- 32 containers == 5 bits of index
          block_offset  : in std_logic_vector(1 downto 0); -- offset inside a container (1 container == 4 words)
          write_data    : in std_logic_vector(31 downto 0);
          read_data     : out std_logic_vector(31 downto 0);
          -- control signals
          writeEnable   : in std_logic);
end data;

architecture Structure of data is
    type ARRAY_DATA is array (2**5-1 downto 0) of std_logic_vector(127 downto 0);
    signal mem_data : ARRAY_DATA;

    signal container_128 : std_logic_vector(127 downto 0);
begin
    
    data_read : process(index)
    begin
        container_128 <= mem_data(to_integer(unsigned(index)));

        if (block_offset = "00") then
            read_data <= container_128(31 downto 0);
        elsif (block_offset = "01") then
            read_data <= container_128(63 downto 32);
        elsif (block_offset = "10") then
            read_data <= container_128(95 downto 64);
        else
            read_data <= container_128(127 downto 96);
        end if;
    end process data_read;

    data_write : process(index)
    begin
        if (writeEnable = '1') then
            mem_data(to_integer(unsigned(index))) <= write_data;
        end if;
    end process data_write;

end Structure;
