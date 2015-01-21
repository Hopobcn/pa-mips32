library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity main_mem is
    port (-- data buses
          addr         : in  std_logic_vector(31 downto 0); 
          write_data   : in  std_logic_vector(31 downto 0);
          read_data    : out std_logic_vector(31 downto 0);
          -- control signals
			 Rd           : in  std_logic;
			 Wr           : in  std_logic;
          Ready        : out std_logic;
			 reset        : in  std_logic;
			 clk          : in  std_logic);
end main_mem;

architecture Structure of main_mem is
    type ARRAY_MEM is array (2**8-1 downto 0) of std_logic_vector(7 downto 0);
    signal main_mem : ARRAY_MEM;
	 
	 type latency is (ONE,TWO,THREE);
	 signal memCurrState, memNextState : latency;
begin

    mem_state : process(clk,reset)
    begin
        if (reset = '1') then
            memCurrState <= ONE;
        elsif (rising_edge(clk)) then
            memCurrState <= memNextState;
        end if;
    end process mem_state;

    mem_next_state : process(memCurrState,Rd,Wr)
    begin
        case memCurrState is
        when ONE =>
		      if (Rd = '1' or Wr = '1') then
			       memNextState <= TWO;
			   else
			       memNextState <= ONE;
			   end if;
        when TWO =>
		      memNextState <= THREE;
		  when THREE =>
		      memNextState <= ONE;
        end case;
    end process mem_next_state;
	 
	 
	 mem_output_logic : process(memCurrState,Rd,Wr)
    begin
         -- Comentades les senyals que no cal inicialitzar en cada Estat
        case memCurrState is
        when ONE =>
            Ready <= '1';
		  when TWO =>
		      Ready <= '0';
		  when THREE =>
		      Ready <= '0';
				if (Rd = '1') then
                read_data(7 downto 0)    <= main_mem(to_integer(unsigned(addr      )));
                read_data(15 downto 8)   <= main_mem(to_integer(unsigned(addr+x"01")));
                read_data(23 downto 16)  <= main_mem(to_integer(unsigned(addr+x"02")));
                read_data(31 downto 24)  <= main_mem(to_integer(unsigned(addr+x"03")));
            end if;
		      if (Wr = '1') then
                main_mem(to_integer(unsigned(addr      ))) <= write_data(7 downto 0);
                main_mem(to_integer(unsigned(addr+x"01"))) <= write_data(15 downto 8);
                main_mem(to_integer(unsigned(addr+x"02"))) <= write_data(23 downto 16);
                main_mem(to_integer(unsigned(addr+x"03"))) <= write_data(31 downto 24); 
            end if;
        end case;
    end process mem_output_logic;

end Structure;
