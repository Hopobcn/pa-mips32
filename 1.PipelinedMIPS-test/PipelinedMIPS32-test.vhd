library ieee;
use ieee.std_logic_1164.all;

entity PipelinedMIPS32test is
end PipelinedMIPS32test;


architecture Structure of PipelinedMIPS32test is
	
	
  component PipelinedMIPS32 is
	port(	 clk	: in std_logic;
			   boot	: in std_logic;
			-- External interrupt
			external_interrupt : in std_logic);
			
  end component;
  
  signal clk : std_logic := '0';
  signal boot : std_logic;
  signal external_interrupt : std_logic;
  
begin
  
  clk       <= not clk after 50 ps;
	boot <= '1' after 50 ps, '0' after 150 ps;
	external_interrupt <= '0' after 20 ps, '1' after 520 ps, '0' after 620 ps;
  
  processor : PipelinedMIPS32
  port map (clk => clk,
            boot => boot,
            external_interrupt => external_interrupt);
            
end Structure;