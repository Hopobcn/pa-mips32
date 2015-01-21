library ieee;
use ieee.std_logic_1164.all;


entity exception_ctrl is
    port (-- Exception state at the MEMory stage
          exception_if        : in std_logic;
          exception_id        : in std_logic;
          exception_exe       : in std_logic;
          exception_lookup    : in std_logic;
          exception_cache     : in std_logic;
          -- If an interrupt-exception is "available"
          exception_interrupt : in std_logic;

          -- Exception flag
          exception_flag      : out std_logic; -- Exception-exception indicator
          exception_jump      : out std_logic; -- to IF, Force PC to jump to handler
         
          -- Signals for writeback
          wbexc_writeEPC      : out std_logic;
          wbexc_writeBadVAddr : out std_logic;
          wbexc_writeCause    : out std_logic); 
end exception_ctrl;

architecture Structure of exception_ctrl is
  signal exception_tmp : std_logic;
begin
    -- The internal exception indicator
    exception_tmp <= '1' when (exception_if='1' or exception_id='1' or exception_exe='1' or exception_lookup='1' or exception_cache = '1') else
                     '0';
                    
    exception_flag <= exception_tmp;
    exception_jump <= exception_tmp or exeption_interrupt;
	 
    -- The PC is are always used
    wbexc_writeEPC <= exception_tmp or exeption_interrupt;
	 -- The Cause is used on exception-exception, harcoded 01 on Interrupts
    wbexc_writeCause <= exception_tmp;
    -- MIPS deviation: we consider that the hardware interrupt is checked through another mechanism

    -- The memory-access stages may include BadVAddr
    wbexc_writeBadVAddr <= '1' when (exception_id='1' or exception_lookup='1' or exception_cache = '1') else
                           '0';
                         
end Structure;
