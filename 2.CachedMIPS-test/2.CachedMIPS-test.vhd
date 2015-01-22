library ieee;
use ieee.std_logic_1164.all;

entity CachedMIPS32test is
end CachedMIPS32test;


architecture Structure of CachedMIPS32test is
	
	
    component CachedMIPS32 is
	 port(clk                : in std_logic;
         boot               : in std_logic;
         external_interrupt : in std_logic);
			
    end component;
  
    signal clk        : std_logic := '0';
    signal boot       : std_logic;
	 signal interrupt  : std_logic;
begin
  
    clk       <= not clk after 50 ps;
	 boot <= '1' after 5 ps, '0' after 55 ps;

	 interrupt <= '0' after 20 ps, '1' after 1520 ps, '0' after 1620 ps;
  
    processor : CachedMIPS32
    port map (clk                => clk,
              boot               => boot,
				  external_interrupt => interrupt);
            
end Structure;