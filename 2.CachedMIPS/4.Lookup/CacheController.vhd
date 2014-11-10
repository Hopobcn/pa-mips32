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
          State         : in std_logic_vector(1 downto 0);
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
    type proc_state_type is (PROC_IDLE,READ_MISS,WRITE_MISS);
    signal procCurrState, procNextState : proc_state_type;

    type obs_state_type is (OBS_IDLE,OBS_READ);
    signal obsCurrState, obsNextState : obs_state_type;

    constant I : std_logic_vector := x"00";
    constant E : std_logic_vector := x"01";
    constant S : std_logic_vector := x"10";
    constant M : std_logic_vector := x"11";

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
            procCurrState <= PROC_IDLE;
        elsif (rising_clock(clk)) then
            procCurrState <= procNextState;
        end if;
    end process processor_state;


    proc_next_state : process(procCurrState,PrRd,PrWr,Hit,busReady)
    begin
        case procCurrState is
        when PROC_IDLE =>
            if (PrRd == '1') then
                if (Hit == '1') then
                    procNextState <= PROC_IDLE; -- Read HIT  : 1cycle
                else
                    procNextState <= READ_MISS; -- Read MISS : Broadcast Read
                end if;
            elsif (PrWr == '1') then
                if (Hit == '1') then
                    procNextState <= PROC_IDLE; -- Write HIT : (M)Broadcast Invalidate OR (E,S)nothing
                else
                    procNextState <= WRITE_MISS; -- Write MISS: Broadcast RWITM
                end if;
            end if;
        when READ_MISS =>
            if (busReady == '1') then
                procNextState <= PROC_IDLE;
            else
                procNextState <= READ_MISS;
            end if;
        when WRITE_MISS =>
            if (busReady == '1') then
                procNextState <= PROC_IDLE;
            else
                procNextState <= WRITE_MISS;
            end if;
        end case;
    end process next_state_logic;

    proc_output_logic : process(procCurrState,PrRd,PrWr,Hit,busReady)
    begin
        case procCurrState is
        when PROC_IDLE =>
            muxIndex <= '0';
            Ready    <= '0';
            if (PrRd == '1') then
                if (Hit == '1') then
                    muxDataR <= '0'; -- Read from cache
                    Ready    <= '1'; -- Ready
                else
                    busRd    <= '1'; -- Start a BusRd petition
                end if;
            elsif (PrWr == '1') then
                if (Hit == '1') then
                    if (State == M or State == E) then
                        muxDataW <= '0'; -- Write proc->cache
                        Ready    <= '1';
                    else -- State == S => Broadcast Invalidate
                        busMOD <= '1'; -- if othrers processors see MOD & addr&Hit S->I
                    end if;
                else
                    BusRdX <= '1'; -- Write Miss: Broadcast RWITM
                end if;
            end if;
        when READ_MISS =>
            if (busReady == '1') then
                WriteTags  <= '1';
                WriteState <= '1';
                if (obsS == '1')
                    nextState <= S;
                else
                    nextState <= E;
                end if;
            end if;
        when WRITE_MISS =>
            if (busReady == '1') then
                WriteTags  <= '1';
                WriteState <= '1';
                WriteCache <= '1';
                nextState  <= M;
            end if;
        end case;
    end process output_logic_state;


    -- Observer state machine
    observer_state : process(clk,reset)
    begin
        if (reset == '1') then
            obsCurrState <= OBS_IDLE;
        elsif (rising_clock(clk)) then
            obsCurrState <= obsNextState;
        end if;
    end process observer_state;

    obs_next_state : process(obsCurrState,obsBusRd,obsBusRdX,obsS,obsMOD,Hit,busReady)
    begin
        case obsCurrState is
        when OBS_IDLE =>
            if (obsBusRd == '1' and Hit == '1' and State == M) then
                obsNextState <= OBS_READ;
            else
                obsNextState <= OBS_IDLE;
            end if;
        end case;
    end process obs_next_state;

    obs_output_logic : process(obsCurrState,obsBusRd,obsBusRdX,obsS,obsMOD,Hit,MemRead)
    begin
        case obsCurrState is
        when OBS_IDLE =>
            if (obsBusRd == '1') then
                if (Hit == '1') then
                    if (State == M) then
                        -- Put data in bus + Update Main Memory
                        muxDataR <= '0';
                        BusWr    <= '1';
                    else
                        muxDataR <= '0';
                    end if;
                else
                    -- Observation miss, do nothing
                end if;
            elsif (obsBusRdx == '1') then
                if (Hit == '1') then
                    nextState <= I;
                end if;
            end if;
        when OBS_READ =>
            if (busReady == '1') then
                Ready <= '0';
            else
                Ready <= '0';
            end if;
        end case;
    end process obs_output_logic;
            
end Structure;
