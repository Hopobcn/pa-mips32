library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity SRAMController is 
    port (clk           : in  std_logic;  
            SRAM_ADDR   : out std_logic_vector(17 downto 0);
            SRAM_DQ     : inout std_logic_vector(15 downto 0);
            SRAM_UB_N   : out std_logic;
            SRAM_LB_N   : out std_logic;
            SRAM_CE_N   : out std_logic := '0';
            SRAM_OE_N   : out std_logic := '1';
            SRAM_WE_N   : out std_logic := '1';

            address     : in  std_logic_vector(15 downto 0) := "0000000000000000";
            dataReaded  : out std_logic_vector(15 downto 0);
            dataToWrite : in  std_logic_vector(15 downto 0);
            WR          : in  std_logic;
            byte_m      : in  std_logic := '0'
            );
end SRAMController;

architecture behavior of SRAMController is
type tipusestat is (E, R1, R2, R3, W1, W2, W3);
	--constant R1 	: integer := 0;
	--constant R2 	: integer := 1;
	--constant W1 	: integer := 2;
	--constant W2 	: integer := 2;
	signal estat : tipusestat := E;
	
	signal UB 	: std_logic;
	signal LB 	: std_logic;
	signal CE 	: std_logic := '0';
	signal OE 	: std_logic := '0';
	signal WE	: std_logic := '0';
	signal dataReaded_tmp : std_logic_vector(15 downto 0) := "0000000000000000";
begin
   SRAM_ADDR 	<= "000" & address(15 downto 1);
	SRAM_UB_N 	<= not(UB);
	SRAM_LB_N 	<= not(LB);
	SRAM_CE_N 	<= not(CE);
	SRAM_OE_N 	<= not(OE);
	SRAM_WE_N	<= not(WE);
	
	dataReaded  <= dataReaded_tmp;
				
	prox_estat : process(clk)
	begin
		if(rising_edge(clk)) then
			case estat is
				when R1 =>
					estat <= R2;
				when R2 =>
					estat <= R3;
				when R3 =>
					estat <= E;
				when W1 =>
					estat <= W2;
				when W2 =>
					estat <= W3;
				when W3 =>
					estat <= E;
				when E =>
					if (WR = '0') then
						estat <= R1;
					else
						estat <= W1;
					end if;
			end case;
		end if;
	end process prox_estat;
	--estat <= R1 when WR = '0' and (estat = R2 or estat = W2) else
	--			R2 when estat = R1 										else
	--			W1 when WR = '1' and (estat = R2 or estat = W2) else
	--			W2 when estat = W1										else
	--			R1;--Per aqui no hauria d'entrar perque estan tots els cassos coberts
	
	logica_sortida : process(clk)
	begin
		if(rising_edge(clk)) then
			case estat is
				when R1 =>
					CE <= '1';--Activem el xip
					WE <= '0';--Vull llegir
					OE <= '1';--Activo l'IO
					LB <= '1';
					UB <= '1';
					
					--SRAM_DQ <= "ZZZZZZZZZZZZZZZZ";
				when R2 =>
					if (byte_m = '0') then
						dataReaded_tmp <= SRAM_DQ;
					elsif (address(0) = '0') then
						dataReaded_tmp <= SRAM_DQ(7) &SRAM_DQ(7) &SRAM_DQ(7) &SRAM_DQ(7) &SRAM_DQ(7) &SRAM_DQ(7) &SRAM_DQ(7) &SRAM_DQ(7) &SRAM_DQ(7 DOWNTO 0);
					else
						dataReaded_tmp <= SRAM_DQ(15)&SRAM_DQ(15)&SRAM_DQ(15)&SRAM_DQ(15)&SRAM_DQ(15)&SRAM_DQ(15)&SRAM_DQ(15)&SRAM_DQ(15)&SRAM_DQ(15 DOWNTO 8);
					end if;
				when R3 =>
					--SRAM_DQ <= "ZZZZZZZZZZZZZZZZ";
				when W1 =>
					CE <= '1';
					OE <= '0';
					WE <= '1';
					if (byte_m = '0') then
						SRAM_DQ <= dataToWrite;
						UB <= '1';
						LB <= '1';
					elsif (address(0) = '0') then 
						SRAM_DQ <= "00000000" & dataToWrite(7 DOWNTO 0);
						UB <= '0';
						LB <= '1';-- es vol llegir el lowByte
					else
						--SRAM_DQ <= dataToWrite(7 DOWNTO 0) & "ZZZZZZZZ";
						SRAM_DQ <= dataToWrite(7 DOWNTO 0) & "00000000";
						UB <= '1';-- es vol llegir el highByte
						LB <= '0';
					end if;
				when W2 =>
					WE <= '0';--desactivo l'escriptura
					
					--SRAM_DQ <= "ZZZZZZZZZZZZZZZZ";
				when W3 =>
					--SRAM_DQ <= "ZZZZZZZZZZZZZZZZ";
				when E =>					
					--SRAM_DQ <= "ZZZZZZZZZZZZZZZZ";
			end case;
		end if;
	end process logica_sortida;	

end behavior;
