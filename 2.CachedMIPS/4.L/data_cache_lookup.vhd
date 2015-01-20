library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_cache_lookup is
    port (addr        :  in  std_logic_vector(31 downto 0);
          -- control signals;
          Ready       :  out std_logic;
          WriteCache  :  out std_logic;
          -- periferics
          muxDataR    :  out std_logic;
          muxDataW    :  out std_logic;
          -- Interface with memory
          BusRd       :  out std_logic;
          BusWr       :  out std_logic;
          BusReady    :  in  std_logic);
end data_cache_lookup;

architecture Structure of data_cache_lookup is
    
    component cache_fields is
    port (-- data buses
	       tag           : in  std_logic_vector(24 downto 0);
          index         : in  std_logic_vector(4 downto 0);
          nextState     : in  std_logic;
          -- control signals
          WriteTags     : in  std_logic;
          WriteState    : in  std_logic;
          Hit           : out std_logic);
    end component;
     
    component cache_controller is
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
          BusReady      : in  std_logic);
    end component;
     
    signal WriteTags_wire   : std_logic;
    signal WriteState_wire  : std_logic;
    signal nextState_wire   : std_logic;
    signal Hit_wire         : std_logic;
     
begin

    FIELDS : cache_fields
    port map(tag            => addr(31 downto 7),
             index          => addr(6 downto 2),
             nextState      => nextState_wire,
             WriteTags      => WriteTags_wire,
             WriteState     => WriteState_wire,
             Hit            => Hit_wire);
     
     CONTROLLER : inst_cache_ctrl
     port map(PrRd          => '1',
              PrWr          => '0',
              Ready         => Ready,
              Hit           => Hit_wire,
              WriteTags     => WriteTags_wire,
              WriteState    => WriteState_wire,
              WriteCache    => WriteCache,
              nextState     => nextState_wire,
              muxDataR      => muxDataR,
              muxDataW      => muxDataW,
              BusRd         => BusRd,
              BusWr         => BusWr,
              BusReady      => BusReady);
     
                       
end Structure;
