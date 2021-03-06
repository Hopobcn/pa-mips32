library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity inst_cache is
    port (addr        :  in  std_logic_vector(31 downto 0);
          instruction :  out std_logic_vector(31 downto 0);
          busDataMem  :  in  std_logic_vector(127 downto 0);
          -- control signal
          BusRd       :  out std_logic;
          BusWr       :  out std_logic;
          BusReady    :  in  std_logic;
          Ready       :  out std_logic;
          clk         :  in  std_logic;
          reset       :  in  std_logic);
end inst_cache;

architecture Structure of inst_cache is
    
    component icache_fields is
    port (-- data buses
          write_data    : in  std_logic_vector(127 downto 0);
          read_data     : out std_logic_vector(31 downto 0);
          tag           : in  std_logic_vector(22 downto 0);
          index         : in  std_logic_vector(4 downto 0);
          block_offset  : in  std_logic_vector(1 downto 0);
          nextState     : in  std_logic;
          -- control signals
          WriteTags     : in  std_logic;
          WriteState    : in  std_logic;
          WriteCache    : in  std_logic;
          Hit           : out std_logic);
    end component;
     
    component icache_controller is
    port (-- Interface with the Processor
          PrRd          : in  std_logic;
          PrWr          : in  std_logic;
          Ready         : out std_logic;
          -- Interface with cache_fields
          Hit           : in  std_logic;
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
    end component;
     
     signal WriteTags_wire   : std_logic;
     signal WriteState_wire  : std_logic;
     signal WriteCache_wire  : std_logic;
     signal nextState_wire   : std_logic;
     signal Hit_wire         : std_logic;
     
     signal muxDataR         : std_logic;
     signal muxDataW         : std_logic;
     
     signal writeProc        : std_logic_vector(127 downto 0) := x"00000000000000000000000000000000";
     signal readCache        : std_logic_vector(31 downto 0);
     signal writeCache       : std_logic_vector(127 downto 0);
begin

    FIELDS : icache_fields
    port map(write_data     => writeCache,
             read_data      => readCache,
             tag            => addr(31 downto 9),
             index          => addr(8 downto 4),
             block_offset   => addr(3 downto 2),
             nextState      => nextState_wire,
             WriteTags      => WriteTags_wire,
             WriteState     => WriteState_wire,
             WriteCache     => WriteCache_wire,
             Hit            => Hit_wire);
     
     CONTROLLER : icache_controller
     port map(PrRd          => '1',
              PrWr          => '0', --INST CACHE always makes read request !
              Ready         => Ready,
              Hit           => Hit_wire,
              WriteTags     => WriteTags_wire,
              WriteState    => WriteState_wire,
              WriteCache    => WriteCache_wire,
              nextState     => nextState_wire,
              muxDataR      => muxDataR,
              muxDataW      => muxDataW,
              BusRd         => BusRd,
              BusWr         => BusWr,
              BusReady      => BusReady,
              clk           => clk,
              reset         => reset);
     
     writeCache <= writeProc when muxDataW = '0' else
                   busDataMem;
                              
     instruction <= readCache when muxDataR = '0' else
                    busDataMem(31 downto 0);
end Structure;
