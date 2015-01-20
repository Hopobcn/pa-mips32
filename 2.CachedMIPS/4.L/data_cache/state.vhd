library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity state is
    port (-- data buses
          index         : in  std_logic_vector(4 downto 0); -- 32 containers == 5 bits of index
          nextState     : in  std_logic;
          state         : out std_logic; -- I (0) or V (1)
          -- control signals
          WriteEnable   : in  std_logic);
end state;

architecture Structure of state is
    type ARRAY_STATE is array (2**5-1 downto 0) of std_logic;
    signal mem_state : ARRAY_STATE;
begin
    
    read_state : process(index)
    begin
        state <= mem_state(to_integer(unsigned(index)));
    end process read_state;

    write_state : process(index)
    begin 
        if (WriteEnable = '1') then
            mem_state(to_integer(unsigned(index))) <= nextState;
        end if;
    end process write_state;

end Structure;
