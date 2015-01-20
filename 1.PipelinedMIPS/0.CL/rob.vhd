library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rob_ctrl is
    port (clk : in std_logic;
      boot : in std_logic;

      -- The valid flag, for a certain finished operation
      valid_flag : in std_logic;
      valid_addr : in std_logic_vector(2 downto 0);

      -- The exception flag, for a certain exception operation
      except_flag : in std_logic;
      except_addr : in std_logic_vector(2 downto 0);
      
      -- The value flag, for storing an intermediate value
      value_flag : in std_logic;
      value_addr : in std_logic_vector(2 downto 0);
      value_val  : in std_logic_vector(31 downto 0);

      ready : out std_logic;  -- If head == tail and !empty, then we are full
      tail  : out std_logic_vector(2 downto 0)
      );
end rob_ctrl;

architecture Structure of rob_ctrl is
    type ROB_DATA is array (7 downto 0) of std_logic_vector(38 downto 0);
    -- *** Data inside the structure (each std_logic_Vector) ***
    -- Bit 38 Valid
    -- Bit 37 Exception
    -- Bits 36..32 Register address
    -- Bits 31..0 Value
    signal data : ROB_DATA;

    signal i_head : std_logic_vector(2 downto 0);
    signal i_tail : std_logic_vector(2 downto 0);

    signal empty : std_logic;
begin
    -- Do logic on clk edge
    basic_logic : process(clk, boot)
    begin
        if (rising_edge(clk)) then
            if (boot = '1') then
                i_head <= "000";
                i_tail <= "000";
                empty <= '0';
            else
                if (valid_flag = '1') then
                    data(to_integer(unsigned(valid_addr)))(38) <= '1';
                end if;
                if (except_flag = '1') then
                    data(to_integer(unsigned(except_addr)))(37) <= '1';
                end if;
                if (value_flag = '1') then
                    data(to_integer(unsigned(value_addr)))(31 downto 0) <= value_val;
              end if;
            end if;
        end if;
    end process;

    ready <= '0' when i_head /= i_tail else
             '0' when empty = '1' else
             '1';

    tail <= i_tail;
end Structure;
