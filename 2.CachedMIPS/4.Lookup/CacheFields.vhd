library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity cache_fields is
    port (-- data buses
          index         : in std_logic_vector(4 downto 0);
          tag           : in std_logic_vector(25 downto 0);
          State         : out std_logic_vector(1 downto 0);
          nextState     : in std_logic_vector(1 downto 0);
          -- control signals
          WriteTags     : in std_logic;
          WriteState    : in std_logic;
          Hit           : out std_logic);
end cache_fields;

architecture Structure of cache_fields is
    constant I : std_logic_vector := x"00";
begin 

    component tags is
    port (-- data buses
          index         : in std_logic_vector(4 downto 0); -- 32 containers == 5 bits of index
          tagWrite      : in std_logic_vector(25 downto 0);
          tagRead       : out std_logic_vector(25 downto 0);
          -- control signals
          WriteEnable   : in std_logic);
    end component;

    component state is
    port (-- data buses
          index         : in std_logic_vector(4 downto 0); -- 32 containers == 5 bits of index
          nextState     : in std_logic_vector(1 downto 0);
          state         : out std_logic_vector(1 downto 0);
          -- control signals
          WriteEnable   : in std_logic);
    end component;

    signal tagRead      : std_logic_vector(25 downto 0);
    signal currentState : std_logic_vector(1 downto 0);
    signal tag_compare  : std_logic;
begin

    TAGS : tags
    port map(index       => index,
             tagWrite    => tag,
             tagRead     => tagRead,
             WriteEnable => WriteTags);

    STATE : state
    port map(index       => index,
             nextState   => nextState,
             state       => currentState,
             WriteEnable => WriteState);

    State <= currentState;

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
            Hit <= '0'; --if Invalid always miss
        else
            Hit <= tag_compare;
        end if;
    end process is_hit;

end Structure;

