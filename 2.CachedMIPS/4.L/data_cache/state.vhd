library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity dstate is
    port (-- data buses
          index         : in  std_logic_vector(4 downto 0); -- 32 containers == 5 bits of index
          nextState     : in  std_logic;
          state         : out std_logic; -- I (0) or V (1)
          -- control signals
          WriteEnable   : in  std_logic);
end dstate;

architecture Structure of dstate is
    constant I    : std_logic := '0';
    constant V    : std_logic := '1';
	 
    type ARRAY_STATE is array (2**5-1 downto 0) of std_logic;
    signal mem_state : ARRAY_STATE := (others => I);
begin
    
    state <= mem_state(to_integer(unsigned(index)));

    write_state : process(index,nextState,WriteEnable)
    begin 
        if (WriteEnable = '1') then
            mem_state(to_integer(unsigned(index))) <= nextState;
        end if;
    end process write_state;

end Structure;
