library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity tags is
    port (-- data buses
          index         : in std_logic_vector(4 downto 0); -- 32 containers == 5 bits of index
          tagWrite      : in std_logic_vector(25 downto 0);
          tagRead       : out std_logic_vector(25 downto 0);
          -- control signals
          WriteEnable   : in std_logic);
end tags;

architecture Structure of tags is
    type ARRAY_TAGS is array (2**5-1 downto 0) of std_logic_vector(25 downto 0);
    signal mem_tags : ARRAY_TAGS;
begin
    
    read_tags : process(index)
    begin
        tagRead <= mem_tags(to_integer(unsigned(index)));
    end process read_tags;

    write_tags : process(index)
    begin
        if (WriteEnable = '1') then
            mem_tags(to_integer(unsigned(index))) <= tagWrite;
        end if;
    end process write_tags;

end Structure;
