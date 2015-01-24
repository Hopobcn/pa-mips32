library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_cache_lookup is
    port (addr        :  in  std_logic_vector(31 downto 0);
          busAddrDC   :  out std_logic_vector(31 downto 0);
          -- control signals;
          PrRd        :  in  std_logic;
          PrWr        :  in  std_logic;
          Ready       :  out std_logic;
          WriteCache  :  out std_logic;
          -- periferics
          muxDataR    :  out std_logic;
          muxDataW    :  out std_logic;
          -- Interface with memory
          BusRd       :  out std_logic;
          BusWr       :  out std_logic;
          BusReady    :  in  std_logic;
          clk         :  in  std_logic;
          reset       :  in  std_logic);
end data_cache_lookup;

architecture Structure of data_cache_lookup is
    
    component dcache_fields is
    port (-- data buses
	       tag           : in  std_logic_vector(22 downto 0);
          index         : in  std_logic_vector(4 downto 0);
          nextState     : in  std_logic;
          -- control signals
          WriteTags     : in  std_logic;
          WriteState    : in  std_logic;
          Hit           : out std_logic;
          State         : out std_logic);
    end component;
     
    component dcache_controller is
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
    end component;
     
    signal WriteTags_wire   : std_logic;
    signal WriteState_wire  : std_logic;
    signal nextState_wire   : std_logic;
    signal Hit_wire         : std_logic;
    signal State_wire       : std_logic;

begin

    FIELDS : dcache_fields
    port map(tag            => addr(31 downto 9),
             index          => addr(8 downto 4),
             nextState      => nextState_wire,
             WriteTags      => WriteTags_wire,
             WriteState     => WriteState_wire,
             Hit            => Hit_wire,
             State          => State_wire);
     
     CONTROLLER : dcache_controller
     port map(PrRd          => PrRd,
              PrWr          => PrWr,
              Ready         => Ready,
              Hit           => Hit_wire,
              State         => State_wire,
              WriteTags     => WriteTags_wire,
              WriteState    => WriteState_wire,
              WriteCache    => WriteCache,
              nextState     => nextState_wire,
              muxDataR      => muxDataR,
              muxDataW      => muxDataW,
              BusRd         => BusRd,
              BusWr         => BusWr,
              BusReady      => BusReady,
              clk           => clk,
              reset         => reset);
     
     -- Ask for the CacheLine or pass the addres for writing into mem
     BusAddrDC <= addr(31 downto 4) & "0000" when PrRd = '1' else
                  addr;
                       
end Structure;
