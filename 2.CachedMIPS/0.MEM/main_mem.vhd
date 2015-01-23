library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity main_mem is
    port (-- data buses
          addrIC       : in  std_logic_vector(31 downto 0); 
          write_dataIC : in  std_logic_vector(31 downto 0);
          read_dataIC  : out std_logic_vector(127 downto 0);
          addrDC       : in  std_logic_vector(31 downto 0); 
          write_dataDC : in  std_logic_vector(31 downto 0);
          read_dataDC  : out std_logic_vector(127 downto 0);
          -- control signals
          BusRdIC      : in  std_logic;
          BusWrIC      : in  std_logic;
          BusReadyIC   : out std_logic;
          BusRdDC      : in  std_logic;
          BusWrDC      : in  std_logic;
          BusReadyDC   : out std_logic;
          reset        : in  std_logic;
          clk          : in  std_logic);
end main_mem;

architecture Structure of main_mem is
    type ARRAY_MEM is array (2**8-1 downto 0) of std_logic_vector(7 downto 0);
    signal main_mem : ARRAY_MEM := (                       --- THIS IS CORRECT?
       -- Cache Line 0
        3 => x"20",  2 => x"04",  1 => x"00",  0 => x"04", --       addi R4,R0,4
        7 => x"20",  6 => x"05",  5 => x"00",  4 => x"00", --       addi R5,R0,0
       11 => x"8c", 10 => x"86",  9 => x"00",  8 => x"00", -- Loop: lw R6,0(R4) 
       15 => x"8c", 14 => x"57", 13 => x"00", 12 => x"04", --       lw R7,4(R4)
       -- Cache Line 1
       19 => x"00", 18 => x"c7", 17 => x"28", 16 => x"20", --       add  R5,R6,R7
       23 => x"20", 22 => x"a6", 21 => x"00", 20 => x"08", --       addi R6,R5,8 
       27 => x"ac", 26 => x"86", 25 => x"00", 24 => x"04", --       sw   R6,4(R4)
       31 => x"10", 30 => x"80", 29 => x"00", 28 => x"02", --       beq  R4,R0
		 -- Cache Line 2
       35 => x"08", 34 => x"00", 33 => x"00", 32 => x"02", --       j  Loop
       39 => x"00", 38 => x"00", 37 => x"00", 36 => x"00", -- nop
       43 => x"00", 42 => x"00", 41 => x"00", 40 => x"00", -- nop
       47 => x"00", 46 => x"00", 45 => x"00", 44 => x"00", -- nop
		  
        others => x"FF");
	 
    type latency is (IDLE,DATA_CACHE0,DATA_CACHE1,INST_CACHE0,INST_CACHE1);
    signal memCurrState, memNextState : latency;

    --	NOT Working ATM FIX THIS
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
            memCurrState <= IDLE;
        elsif (rising_edge(clk)) then
            memCurrState <= memNextState;
        end if;
    end process mem_state;

    mem_next_state : process(memCurrState,BusRdIC,BusWrIC,BusRdDC,BusWrDc)
    begin
        case memCurrState is
        when IDLE =>
		      if (BusRdDC = '1' or BusWrDC = '1') then -- Data Cache priority over IC
			       memNextState <= DATA_CACHE0;
            elsif (BusRdIC = '1' or BusWrIC = '1') then
                memNextState <= INST_CACHE0;
			   else
			       memNextState <= IDLE;
			   end if;
        when DATA_CACHE0 =>
		      memNextState <= DATA_CACHE1;
        when DATA_CACHE1 =>
		      memNextState <= IDLE;
				if (BusRdIC = '1' or BusWrIC = '1') then
                memNextState <= INST_CACHE0;
				end if;
        when INST_CACHE0 =>
		      memNextState <= INST_CACHE1;
		  when INST_CACHE1 =>
		      memNextState <= IDLE;
				if (BusRdDC = '1' or BusWrDC = '1') then
                memNextState <= DATA_CACHE0;
				end if;
        end case;
    end process mem_next_state;
	 
	
    mem_output_logic : process(memCurrState,BusRdIC,BusWrIC,BusRdDC,BusWrDc,addrIC,addrDC)
    begin

        if (reset = '1') then
            --Load_File_DataMem(main_mem); 
        end if;

         -- Comentades les senyals que no cal inicialitzar en cada Estat
        case memCurrState is
        when IDLE =>
		      BusReadyIC <= '1';
				BusReadyDC <= '1';
        when DATA_CACHE0 =>
            BusReadyIC <= '0';
            BusReadyDC <= '0';
        when DATA_CACHE1 =>
				BusReadyDC <= '1';
            if (BusRdDC = '1') then
                read_dataDC(  7 downto   0)  <= main_mem(to_integer(unsigned(addrDC      )));
                read_dataDC( 15 downto   8)  <= main_mem(to_integer(unsigned(addrDC+x"01")));
                read_dataDC( 23 downto  16)  <= main_mem(to_integer(unsigned(addrDC+x"02")));
                read_dataDC( 31 downto  24)  <= main_mem(to_integer(unsigned(addrDC+x"03")));
					 
                read_dataDC( 39 downto  32)  <= main_mem(to_integer(unsigned(addrDC+x"04")));
                read_dataDC( 47 downto  40)  <= main_mem(to_integer(unsigned(addrDC+x"05")));
                read_dataDC( 55 downto  48)  <= main_mem(to_integer(unsigned(addrDC+x"06")));
                read_dataDC( 63 downto  56)  <= main_mem(to_integer(unsigned(addrDC+x"07")));
					 
                read_dataDC( 71 downto  64)  <= main_mem(to_integer(unsigned(addrDC+x"08")));
                read_dataDC( 79 downto  72)  <= main_mem(to_integer(unsigned(addrDC+x"09")));
                read_dataDC( 87 downto  80)  <= main_mem(to_integer(unsigned(addrDC+x"0A")));
                read_dataDC( 95 downto  88)  <= main_mem(to_integer(unsigned(addrDC+x"0B")));
					 
                read_dataDC(103 downto  96)  <= main_mem(to_integer(unsigned(addrDC+x"0C")));
                read_dataDC(111 downto 104)  <= main_mem(to_integer(unsigned(addrDC+x"0D")));
                read_dataDC(119 downto 112)  <= main_mem(to_integer(unsigned(addrDC+x"0E")));
                read_dataDC(127 downto 120)  <= main_mem(to_integer(unsigned(addrDC+x"0F")));
            end if;
            if (BusWrDC = '1') then
                main_mem(to_integer(unsigned(addrDC      ))) <= write_dataDC(7 downto 0);
                main_mem(to_integer(unsigned(addrDC+x"01"))) <= write_dataDC(15 downto 8);
                main_mem(to_integer(unsigned(addrDC+x"02"))) <= write_dataDC(23 downto 16);
                main_mem(to_integer(unsigned(addrDC+x"03"))) <= write_dataDC(31 downto 24); 
            end if;
        when INST_CACHE0 =>
            BusReadyIC <= '0';
            BusReadyDC <= '0';
        when INST_CACHE1 =>
		      BusReadyIC <= '1';
            if (BusRdIC = '1') then
                read_dataIC(  7 downto   0)  <= main_mem(to_integer(unsigned(addrIC      )));
                read_dataIC( 15 downto   8)  <= main_mem(to_integer(unsigned(addrIC+x"01")));
                read_dataIC( 23 downto  16)  <= main_mem(to_integer(unsigned(addrIC+x"02")));
                read_dataIC( 31 downto  24)  <= main_mem(to_integer(unsigned(addrIC+x"03")));
					 
                read_dataIC( 39 downto  32)  <= main_mem(to_integer(unsigned(addrIC+x"04")));
                read_dataIC( 47 downto  40)  <= main_mem(to_integer(unsigned(addrIC+x"05")));
                read_dataIC( 55 downto  48)  <= main_mem(to_integer(unsigned(addrIC+x"06")));
                read_dataIC( 63 downto  56)  <= main_mem(to_integer(unsigned(addrIC+x"07")));
					 
                read_dataIC( 71 downto  64)  <= main_mem(to_integer(unsigned(addrIC+x"08")));
                read_dataIC( 79 downto  72)  <= main_mem(to_integer(unsigned(addrIC+x"09")));
                read_dataIC( 87 downto  80)  <= main_mem(to_integer(unsigned(addrIC+x"0A")));
                read_dataIC( 95 downto  88)  <= main_mem(to_integer(unsigned(addrIC+x"0B")));
					 
                read_dataIC(103 downto  96)  <= main_mem(to_integer(unsigned(addrIC+x"0C")));
                read_dataIC(111 downto 104)  <= main_mem(to_integer(unsigned(addrIC+x"0D")));
                read_dataIC(119 downto 112)  <= main_mem(to_integer(unsigned(addrIC+x"0E")));
                read_dataIC(127 downto 120)  <= main_mem(to_integer(unsigned(addrIC+x"0F")));
            end if;
            if (BusWrIC = '1') then
                main_mem(to_integer(unsigned(addrIC      ))) <= write_dataIC(7 downto 0);
                main_mem(to_integer(unsigned(addrIC+x"01"))) <= write_dataIC(15 downto 8);
                main_mem(to_integer(unsigned(addrIC+x"02"))) <= write_dataIC(23 downto 16);
                main_mem(to_integer(unsigned(addrIC+x"03"))) <= write_dataIC(31 downto 24); 
            end if;
        end case;
    end process mem_output_logic;


end Structure;
