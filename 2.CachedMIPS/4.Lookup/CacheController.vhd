library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity cache_controller is
    port (-- Interface with the Processor
          PrRd          : in std_logic;
          PrWr          : in std_logic;
          Ready         : out std_logic;
          -- Interface with cache_fields
          Hit           : in std_logic;
          WriteTags     : out std_logic;
          WriteState    : out std_logic;
          WriteCache    : out std_logic;
          nextState     : out std_logic_vector(1 downto 0);
          -- periferics
          muxIndex      : out std_logic;
          muxDataR      : out std_logic;
          muxDataW      : out std_logic;
          -- Interface with memory
          BusRd         : out std_logic;
          BusRdX        : out std_logic;
          BusWr         : out std_logic;
          busReady      : in std_logic;
          busS          : out std_logic;
          busMOD        : out std_logic;
          -- Interface with observation bus
          obsBusRd      : in std_logic;
          obsBusRdX     : in std_logic;
          obsBusWr      : in std_logic;
          obsS          : in std_logic;
          obsMOD        : in std_logic);

end cache_controller;

architecture Structure of cache_controller is
    type proc_state_type is (READY,BREAD,BINV,BRWITM);
    signal procCurrState, procNextState : proc_state_type;

    type obs_state_type is (RO,O);
    signal obsCurrState, obsNextState : obs_state_type;

    signal WriteTags_proc  : std_logic := '1';
    signal WriteState_proc : std_logic := '1';
    signal WriteCache_proc : std_logic := '1';
    signal WriteTags_obs   : std_logic := '0';
    signal WriteState_obs  : std_logic := '0';
    signal WriteCache_obs  : std_logic := '0';
    signal nextState_proc  : std_logic_vector := x"00";
    signal nextState_obs   : std_logic_vector := x"00";
begin

    -- Processor state machine
    processor_state : process(clk,reset)
    begin
        if (reset == '1') then
            procCurrState <= READY;
        elsif (rising_clock(clk)) then
            procCurrState <= procNextState;
        end if;
    end process processor_state;


    proc_next_state : process(procCurrState,PrRd,PrWr,Hit,busReady,reset)
    begin
        case procCurrState is
        when READY =>
            if (PrRd == '1') then
                if (Hit == '1') then
                    procNextState <= READY; -- Read HIT  : 1cycle
                else
                    procNextState <= BREAD; -- Read MISS : Broadcast Read
                end if;
            elsif (PrWr == '1') then
                if (Hit == '1') then
                    procNextState <= BINV; -- Write HIT : Broadcast Invalidate
                else
                    procNextState <= BRWITM; -- Write MISS: Broadcast RWITM
                end if;
            end if;
        when BREAD =>
            if (busReady == '1') then
                procNextState <= READY;
            else
                procNextState <= BREAD;
            end if;
        when BINV =>
            procNextState <= READY;
        when BRWITM =>
            if (busReady <= '1') then
                procNextState <= READY;
            else 
                procNextState <= BRWITM;
            end if;
        end case;
    end process next_state_logic;

    proc_output_logic : process(procCurrState,PrRd,PrWr,Hit,memReady,reset)
    begin
        case procCurrState is
        when READY =>
            Ready <= '0';
            if (PrRd == '1') then
                if (Hit == '1') then
                    muxDataR    <= '0';
                    Ready       <= '1';
                else
                    BusRd <= '1';
                end if;
            elsif (PrWr == '1') then
                if (Hit == '1') then
                    busMOD     <= '1'; -- invalidate other caches by putting MOD=1 & addr in bus
                    muxDataW   <= '0';
                    Ready     <= '1';
                else 
                    BusRdX <= '1';
                end if;
            end if;
        when  =>
 
        end case;
    end process output_logic_state;


    -- Observer state machine
    observer_state : process(clk,reset)
    begin
        if (reset == '1') then
            obsCurrState <= R0;
        elsif (rising_clock(clk)) then
            obsCurrState <= obsNextState;
        end if;
    end process observer_state;

    obs_next_state : process(obsCurrState,obsBusRd,obsBusRdX,obsS,obsMOD,Hit,memReady)
    begin
        case obsCurrState is
        when R0 =>
            if (Hit == '0') then
                obsNextState <= R0;
            elsif (Hit == '1' and obsBusRd == '1') then
                obsNextState <= O1;
            elsif (Hit == '1' and obsBusRdX == '1') then
                obsNextState <= O2;
            elsif (Hit == '1' and obsBusWr == '1') then
                obsNextState <= O3;
            end if;
        when O1 =>
        end case;
    end process obs_next_state;

    obs_output_logic : process(obsCurrState,obsBusRd,obsBusRdX,obsS,obsMOD,Hit,MemRead)
    begin
        case obsCurrState is
        when R0 =>
            WriteState_obs <= '0';
            nextState_obs  <= x"00";
            if () then
        when O =>

        end case;
    end process obs_output_logic;
            
end Structure;
