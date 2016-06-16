library ieee;
use ieee.std_logic_1164.all;


entity exception_ctrl is
	port (
	     -- Exception state at the MEMory stage
	     exception_if   : in std_logic;
	     exception_id   : in std_logic;
	     exception_exe  : in std_logic;
	     exception_mem  : in std_logic;
	     
	     -- Exception flag
	     exception_flag : out std_logic;
	     
	     -- Signals for writeback
	     wbexc_writeEPC      : out std_logic;
	     wbexc_writeBadVAddr : out std_logic;
	     wbexc_writeCause    : out std_logic); 
end exception_ctrl;

architecture Structure of exception_ctrl is
  signal exception_tmp : std_logic;
begin
  -- The internal exception indicator
  exception_tmp <= '1' when (exception_if='1' or exception_id='1' or exception_exe='1' or exception_mem='1') else
                    '0';
                    
  exception_flag <= exception_tmp;
  
  -- The PC and Cause are always used
  wbexc_writeEPC <= exception_tmp;
  wbexc_writeCause <= exception_tmp;

  -- The memory-access stages may include BadVAddr
  wbexc_writeBadVAddr <= '1' when (exception_id='1' or exception_mem='1') else
                         '0';
                         
end Structure;