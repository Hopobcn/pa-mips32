library ieee;
use ieee.std_logic_1164.all;

entity BasicMIPS32test is
end BasicMIPS32test;


architecture Structure of BasicMIPS32test is
	
	
  component BasicMIPS32 is
	port(	 clk	: in std_logic;
			   boot	: in std_logic);
			
  end component;
  
  signal clk : std_logic := '0';
  signal boot : std_logic;
  
begin
  
  clk       <= not clk after 50 ps;
	boot <= '1' after 50 ps, '0' after 150 ps;

  
  processor : BasicMIPS32
  port map (clk => clk,
            boot => boot);
            
end Structure;