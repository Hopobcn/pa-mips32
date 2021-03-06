library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity icache_fields is
    port (-- data buses
          write_data    : in  std_logic_vector(127 downto 0);
          read_data     : out std_logic_vector(31 downto 0);
          tag           : in  std_logic_vector(22 downto 0);
          index         : in  std_logic_vector(4 downto 0);
          block_offset  : in  std_logic_vector(1 downto 0);
          nextState     : in  std_logic;
          -- control signals
          WriteTags     : in  std_logic;
          WriteState    : in  std_logic;
          WriteCache    : in  std_logic;
          Hit           : out std_logic);
end icache_fields;

architecture Structure of icache_fields is
    constant I    : std_logic := '0';
    constant MISS : std_logic := '0';

    component itags is
    port (-- data buses
          index         : in  std_logic_vector(4 downto 0); -- 32 containers == 5 bits of index
          tagWrite      : in  std_logic_vector(22 downto 0);
          tagRead       : out std_logic_vector(22 downto 0);
          -- control signals
          WriteEnable   : in  std_logic);
    end component;

    component istate is
    port (-- data buses
          index         : in  std_logic_vector(4 downto 0); -- 32 containers == 5 bits of index
          nextState     : in  std_logic;
          state         : out std_logic;
          -- control signals
          WriteEnable   : in  std_logic);
    end component;

    component idata is
    port (-- data buses
          index         : in  std_logic_vector(4 downto 0); -- 32 containers == 5 bits of index
          block_offset  : in  std_logic_vector(1 downto 0); -- offset inside a container (1 container == 4 words)
          write_data    : in  std_logic_vector(127 downto 0);
          read_data     : out std_logic_vector(31 downto 0);
          -- control signals
          WriteEnable   : in  std_logic);
    end component;
    
    signal tagRead      : std_logic_vector(22 downto 0);
    signal currentState : std_logic;
    signal tag_compare  : std_logic;
begin

    TAGS : itags
    port map(index         => index,
             tagWrite      => tag,
             tagRead       => tagRead,
             WriteEnable   => WriteTags);

    STATE : istate
    port map(index         => index,
             nextState     => nextState,
             state         => currentState,
             WriteEnable   => WriteState);

     DATA : idata
     port map(index        => index,
              block_offset => block_offset,
              write_data   => write_data,
              read_data    => read_data,
              WriteEnable  => WriteCache);
                 
    tag_comparator : process(tag, tagRead)
    begin
        if (tag = tagRead) then
            tag_compare <= '1';
        else
            tag_compare <= '0';
        end if;
    end process tag_comparator;

    is_hit : process(tag_compare, currentState)
    begin
        if (currentState = I) then
            Hit <= MISS; --if Invalid always miss
        else
            Hit <= tag_compare;
        end if;
    end process is_hit;

end Structure;

