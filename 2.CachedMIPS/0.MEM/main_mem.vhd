library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity main_mem is
    port (-- data buses
          addr         : in  std_logic_vector(31 downto 0); 
          write_data   : in  std_logic_vector(31 downto 0);
          read_data    : out std_logic_vector(127 downto 0);
          -- control signals
          Rd           : in  std_logic;
          Wr           : in  std_logic;
          Ready        : out std_logic;
          reset        : in  std_logic;
          clk          : in  std_logic);
end main_mem;

architecture Structure of main_mem is
    type ARRAY_MEM is array (2**8-1 downto 0) of std_logic_vector(7 downto 0);
    signal main_mem : ARRAY_MEM := (                       --- THIS IS CORRECT?
       -- Cache Line 0
        3 => x"20",  2 => x"04",  1 => x"00",  0 => x"03", -- addi R4,R0,4
        7 => x"20",  6 => x"05",  5 => x"00",  4 => x"04", -- addi R5,R0,0
       11 => x"34", 10 => x"06",  9 => x"00",  8 => x"00", -- lw R6,0(R4)
       15 => x"34", 14 => x"06", 13 => x"00", 12 => x"00", -- lw R7,0(R4)
		 -- Cache Line 1
       19 => x"00", 18 => x"85", 17 => x"38", 16 => x"22", -- add R5,R6,R7
       23 => x"20", 22 => x"05", 21 => x"00", 20 => x"04",
       27 => x"34", 26 => x"06", 25 => x"00", 24 => x"00",
       31 => x"34", 30 => x"06", 29 => x"00", 28 => x"00",
		  
        others => x"FF");
	 
    type latency is (ONE,TWO,THREE);
    signal memCurrState, memNextState : latency;

    --	FIX THIS
    procedure Load_File_DataMem(signal memory : inout ARRAY_MEM) is
        file        romfile	    :text open read_mode is "contingut.memoria.hexa.rom";
        variable    lbuf        :line;
        variable    i           :integer := 0; -- x"C000" adreça inicial
        variable    byte0       :std_logic_vector(7 downto 0);
        variable    byte1       :std_logic_vector(7 downto 0);
        variable    byte2       :std_logic_vector(7 downto 0);
        variable    byte3       :std_logic_vector(7 downto 0);
    begin
        while i < 2**8-1 loop --not endfile(romfile) loop
            readline(romfile, lbuf);
            hread(lbuf, byte0);
            hread(lbuf, byte1);
            hread(lbuf, byte2);
            hread(lbuf, byte3);			
            -- Big Endian
            --memory(i  ) <= byte0;	
            --memory(i+1) <= byte1;	
            --memory(i+2) <= byte2;	
            --memory(i+3) <= byte3;
            -- Little Endian			
            memory(i  ) <= byte3;	
            memory(i+1) <= byte2;	
            memory(i+2) <= byte1;	
            memory(i+3) <= byte0;
            i := i+4;
            exit when endfile(romfile);
        end loop;
    end procedure;
	
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

        if (reset = '1') then
            Load_File_DataMem(main_mem);
        end if;

         -- Comentades les senyals que no cal inicialitzar en cada Estat
        case memCurrState is
        when ONE =>
            if (Rd = '1' or Wr = '1') then
                Ready <= '1';
            else
                Ready <= '1';
            end if;
        when TWO =>
            Ready <= '0';
        when THREE =>
            Ready <= '0';
            if (Rd = '1') then
                read_data(  7 downto   0)  <= main_mem(to_integer(unsigned(addr      )));
                read_data( 15 downto   8)  <= main_mem(to_integer(unsigned(addr+x"01")));
                read_data( 23 downto  16)  <= main_mem(to_integer(unsigned(addr+x"02")));
                read_data( 31 downto  24)  <= main_mem(to_integer(unsigned(addr+x"03")));
					 
                read_data( 39 downto  32)  <= main_mem(to_integer(unsigned(addr+x"04")));
                read_data( 47 downto  40)  <= main_mem(to_integer(unsigned(addr+x"05")));
                read_data( 55 downto  48)  <= main_mem(to_integer(unsigned(addr+x"06")));
                read_data( 63 downto  56)  <= main_mem(to_integer(unsigned(addr+x"07")));
					 
                read_data( 71 downto  64)  <= main_mem(to_integer(unsigned(addr+x"08")));
                read_data( 79 downto  72)  <= main_mem(to_integer(unsigned(addr+x"09")));
                read_data( 87 downto  80)  <= main_mem(to_integer(unsigned(addr+x"0A")));
                read_data( 95 downto  88)  <= main_mem(to_integer(unsigned(addr+x"0B")));
					 
                read_data(103 downto  96)  <= main_mem(to_integer(unsigned(addr+x"0C")));
                read_data(111 downto 104)  <= main_mem(to_integer(unsigned(addr+x"0D")));
                read_data(119 downto 112)  <= main_mem(to_integer(unsigned(addr+x"0E")));
                read_data(127 downto 120)  <= main_mem(to_integer(unsigned(addr+x"0F")));
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
