library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- BUG 4 ? In Documentation a normal execution is: F D A Wrob Wrf  and We are doing: F D AWrob Wrf . We are doing A+Wrob in the same cycle
entity rob_ctrl is
    port (clk : in std_logic;
      boot : in std_logic;

      -- The exception flag, for a certain exception operation
      except_flag : in std_logic;
      except_addr : in std_logic_vector(2 downto 0);

      -- The value flag, for storing an intermediate value
      value_flag : in std_logic;
      value_addr : in std_logic_vector(2 downto 0);   -- BUG Nº2 this isn't the register address in the Register file. It's the position on the ROB
      value_alu  : in std_logic_vector(31 downto 0);
      -- ... and the memory address for stores
      value_mem  : in std_logic_vector(31 downto 0);  -- BUG Nº1 value_mem not used

      -- To-RegisterFile signals
      rf_write   : out std_logic;
      rf_addr    : out std_logic_vector(4 downto 0);   -- BUG Nº3 We are commiting 'rf_addr' of uninitialized values!!! Solve this and ROB will work
      rf_val     : out std_logic_vector(31 downto 0);

      -- New entries (from decode stage)
      newentry_flag  : in std_logic; -- UB if using this while full
      newentry_store : in std_logic;

      ready : out std_logic;  -- If head == tail and !empty, then we are full
      tail  : out std_logic_vector(2 downto 0)
      );
end rob_ctrl;

architecture Structure of rob_ctrl is
    type ROB_DATA is array (7 downto 0) of std_logic_vector(105 downto 0);
    -- *** Data inside the structure (each std_logic_Vector) ***
    -- Bit 105 ValidData
    -- Bit 104 ReadyToMem
    -- Bit 103 Exception
    -- Bit 102 Load flag
    -- Bit 101 Store flag
    -- Bits 100..96 Register address
    -- Bits 95..64 PC
    -- Bits 63..32 Memory location (for loads/stores)
    -- Bits 31..0 Value to store
    signal data : ROB_DATA;

    signal i_head : std_logic_vector(2 downto 0);
    signal i_tail : std_logic_vector(2 downto 0);

    signal did_push : std_logic;
    signal did_pop  : std_logic;
    signal keep_empty : std_logic;
    
begin
    -- Do logic on clk edge
    basic_logic : process(clk, boot)
    begin
      if (rising_edge(clk)) then
        if (boot = '1') then
          i_head <= "000";
          i_tail <= "000";
          keep_empty <= '1';
          rf_write <= '0';
          data(0)(105 downto 0) <= (others => '0');
          data(0)(99 downto 68) <= x"DABBAD00";
        else
          if (did_pop = '1' AND i_head = i_tail) then
            keep_empty <= '1';
          end if;
          
          did_push <= '0';
          did_pop  <= '0';
          
          if (except_flag = '1') then
            data(to_integer(unsigned(except_addr)))(103) <= '1';
          end if;
          
          if (value_flag = '1') then
            if (data(to_integer(unsigned(value_addr)))(101) = '1' OR
                data(to_integer(unsigned(value_addr)))(102) = '1') then
              data(to_integer(unsigned(value_addr)))(63 downto 32) <= value_alu;
              data(to_integer(unsigned(value_addr)))(105) <= '1'; -- mem operation ready
            else
              data(to_integer(unsigned(value_addr)))(31 downto 0) <= value_alu;
              data(to_integer(unsigned(value_addr)))(105) <= '1'; -- value ready
            end if;
          end if;
          
          -- Here, the commit-to-register-file part
          if (data(to_integer(unsigned(i_head)))(105) = '1') then
            if (data(to_integer(unsigned(i_head)))(102) = '0') then
                -- proceed to commit a value to the register file
                rf_write <= '1';
                rf_addr <= data(to_integer(unsigned(i_head)))(100 downto 96); -- BUG 3: Bits 100 downto 96 never initialized!!! This bug prevents any write to RegisterFIle to be successful 
                rf_val <= data(to_integer(unsigned(i_head)))(31 downto 0);
  
                i_head <= std_logic_vector(unsigned(i_head) + 1);
            end if;
            
            data(to_integer(unsigned(i_head)))(105 downto 0)  <= (others => '0');
            data(to_integer(unsigned(i_head)))(99 downto 68) <= x"DEADBEEF";
            did_pop <= '1';
            keep_empty <= '1';
          else
            rf_write <= '0';
          end if;
  
          -- Here, the add-a-member part
          if (newentry_flag = '1') then
            data(to_integer(unsigned(i_tail)))(105 downto 0)  <= (others => '0');
            i_tail <= std_logic_vector(unsigned(i_tail) + 1 );
            did_push <= '1';
            keep_empty <= '0';
          end if;
        end if;
    end if;
    end process;
    
    ready <= '1' when i_head /= i_tail else
             '1' when keep_empty = '1' else
             '0';

    tail <= i_tail;
end Structure;
