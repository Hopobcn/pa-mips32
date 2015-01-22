library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rob_ctrl is
    port (clk : in std_logic;
      boot : in std_logic;

      -- The exception flag, for a certain exception operation
      except_flag : in std_logic;
      except_addr : in std_logic_vector(2 downto 0);

      -- The value flag, for storing an intermediate value
      value_flag : in std_logic;
      value_addr : in std_logic_vector(2 downto 0);
      value_alu  : in std_logic_vector(31 downto 0);
      -- ... and the memory address for stores
      value_mem  : in std_logic_vector(31 downto 0);

      -- To-RegisterFile signals
      rf_write   : out std_logic;
      rf_addr    : out std_logic_vector(4 downto 0);
      rf_val     : out std_logic_vector(31 downto 0);

      -- New entries (from decode stage)
      newentry_flag  : in std_logic; -- UB if using this while full
      newentry_store : in std_logic;

      ready : out std_logic;  -- If head == tail and !empty, then we are full
      tail  : out std_logic_vector(2 downto 0)
      );
end rob_ctrl;

architecture Structure of rob_ctrl is
    type ROB_DATA is array (7 downto 0) of std_logic_vector(104 downto 0);
    -- *** Data inside the structure (each std_logic_Vector) ***
    -- Bit 104 ValidData
    -- Bit 103 ReadyToStore
    -- Bit 102 Exception
    -- Bits 101..97 Register address
    -- Bit 96 Store bit
    -- Bits 95..64 PC
    -- Bits 63..32 Memory location (for stores)
    -- Bits 31..0 Value to store
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
          empty <= '1';
        else
          if (except_flag = '1') then
            data(to_integer(unsigned(except_addr)))(102) <= '1';
          end if;          
          
          if (value_flag = '1') then
            if (data(to_integer(unsigned(value_addr)))(96) = '1') then
              data(to_integer(unsigned(value_addr)))(63 downto 32) <= value_alu;
              data(to_integer(unsigned(value_addr)))(103) <= '1'; -- store ready
            else
              data(to_integer(unsigned(value_addr)))(31 downto 0) <= value_alu;
              data(to_integer(unsigned(value_addr)))(104) <= '1'; -- value ready
            end if;
          end if;
          
          -- Here, the commit-to-register-file part
          if (data(to_integer(unsigned(i_head)))(38) = '1') then
            -- proceed to commit a value to the register file
            rf_write <= '1';
            rf_addr <= data(to_integer(unsigned(i_head)))(36 downto 32);
            rf_val <= data(to_integer(unsigned(i_head)))(31 downto 0);
  
            i_head <= std_logic_vector(unsigned(i_head) + 1);
            if (i_head = i_tail) then
              empty <= '1';
            end if;
          else
            rf_write <= '0';
          end if;
  
          -- Here, the add-a-member part
          if (newentry_flag = '1') then
            data(to_integer(unsigned(i_tail)))(104 downto 0) <= (others => '0');
            i_tail <= std_logic_vector(unsigned(i_tail) + 1 );
            empty <= '0';
          end if;
        end if;
    end if;
    end process;

    ready <= '1' when i_head /= i_tail else
             '1' when empty = '1' else
             '0';

    tail <= i_tail;
end Structure;
