library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity dcache_controller is
    port (-- Interface with the Processor
          PrRd          : in  std_logic;
          PrWr          : in  std_logic;
          Ready         : out std_logic;
          -- Interface with cache_fields
          Hit           : in  std_logic;
          State         : in  std_logic;
          WriteTags     : out std_logic;
          WriteState    : out std_logic;
          WriteCache    : out std_logic;
          nextState     : out std_logic;
          -- periferics
          muxDataR      : out std_logic;
          muxDataW      : out std_logic;
          -- Interface with memory
          BusRd         : out std_logic;
          BusWr         : out std_logic;
          BusReady      : in  std_logic;
          clk           : in  std_logic;
          reset         : in  std_logic);

end dcache_controller;

architecture Structure of dcache_controller is
    type proc_state_type is (PROC_IDLE,PROC_LOAD_MISS_WAIT,PROC_STORE_HIT_WAIT,PROC_STORE_MISS_WAIT);
    signal procCurrState, procNextState : proc_state_type;

    constant I : std_logic := '0';
    constant V : std_logic := '1';
begin

    -- Processor state machine
    processor_state : process(clk,reset)
    begin
        if (reset = '1') then
            procCurrState <= PROC_IDLE;
        elsif (rising_edge(clk)) then
            procCurrState <= procNextState;
        end if;
    end process processor_state;


    proc_next_state : process(procCurrState,PrRd,PrWr,Hit,BusReady)
    begin
        case procCurrState is
        when PROC_IDLE =>
            if (PrRd = '1') then
                if (Hit = '1') then
                    procNextState <= PROC_IDLE;             -- Read HIT  : 1cycle
                else
                    procNextState <= PROC_LOAD_MISS_WAIT;   -- Read MISS : fill from memory
                end if;
            elsif (PrWr = '1') then
                if (Hit = '1') then
                    procNextState <= PROC_STORE_HIT_WAIT;   -- Write HIT : write into DRAM (not going to happen in Instruction cache..)
                else
                    procNextState <= PROC_STORE_MISS_WAIT;  -- Write MISS: fill from DRAM
                end if;
            end if;
        when PROC_LOAD_MISS_WAIT =>
            if (BusReady = '1') then
                procNextState <= PROC_IDLE;
            else
                procNextState <= PROC_LOAD_MISS_WAIT;
            end if;
        when PROC_STORE_HIT_WAIT =>
            if (BusReady = '1') then
                procNextState <= PROC_IDLE;
            else
                procNextState <= PROC_STORE_HIT_WAIT;
            end if;
        when PROC_STORE_MISS_WAIT =>
            if (BusReady = '1') then
                procNextState <= PROC_IDLE;
            else
                procNextState <= PROC_STORE_MISS_WAIT;
            end if;
        end case;
    end process proc_next_state;

    proc_output_logic : process(procCurrState,PrRd,PrWr,Hit,BusReady)
    begin
        Ready      <= '0';
        --BusRd      <= '0';
        --BusWr      <= '0';
        WriteTags  <= '0';
        WriteState <= '0';
        WriteCache <= '0';
        muxDataR   <= '0';
        muxDataW   <= '0';
         -- Comentades les senyals que no cal inicialitzar en cada Estat
        case procCurrState is
        when PROC_IDLE =>
            if (BusReady = '1') then
                Ready      <= (not PrWr) and ((Hit and PrRd) or (not PrRd));
                BusRd      <= PrRd and not Hit;
                BusWr      <= PrWr;
                WriteTags  <= '0';
                WriteState <= '0';
                WriteCache <= '0';
                --nextState  <=  I;
                     
                muxDataR   <= '0';
                --muxDataW   <= '0';
            end if;
        when PROC_LOAD_MISS_WAIT =>
            if (BusReady = '1') then
                Ready      <= '1';
                BusRd      <= '0';
                BusWr      <= '0';
                WriteTags  <= '1';
                WriteState <= '1';
                WriteCache <= '1';
                nextState  <=  V;
                     
                muxDataR   <= '1';
                muxDataW   <= '1';
            else
                BusRd <= PrRd and not Hit;
					 BusWr <= PrWr;
            end if;
        when PROC_STORE_HIT_WAIT =>
            if (BusReady = '1') then
                Ready      <= '1';
                BusRd      <= '0';
                BusWr      <= '0';
                WriteTags  <= '1';
                WriteState <= '0';
                WriteCache <= '0';
                --nextState  <=  I;
                     
                --muxDataR   <= '0';
                muxDataW   <= '0';
            end if;
        when PROC_STORE_MISS_WAIT =>
            if (BusReady = '1') then
                Ready      <= '1';
                BusRd      <= '0';
                BusWr      <= '0';
                WriteTags  <= '0';
                WriteState <= '0';
                WriteCache <= '0';
                --nextState  <=  I;
                     
                --muxDataR   <= '0';
                --muxDataW   <= '0';
            end if;
        end case;
    end process proc_output_logic;


            
end Structure;
