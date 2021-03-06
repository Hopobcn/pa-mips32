Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity seu is
    port(input  :  in  std_logic_vector(15 downto 0);
         output :  out std_logic_vector(31 downto 0));
end seu;

architecture Structure of seu is
begin

    output <= input(15) & 
              input(15) &
              input(15) &
              input(15) &
              input(15) &
              input(15) &
              input(15) &
              input(15) &
              input(15) &
              input(15) &
              input(15) &
              input(15) &
              input(15) &
              input(15) &
              input(15) &
              input(15) &                 
              input(15 downto 0);
end Structure;
