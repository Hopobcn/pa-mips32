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
	--signal bus_address : std_logic_vector(15 downto 0);
	type status is (reading,writing1,writing2);
	signal est : status := reading;
	signal mid : std_logic_vector (7 downto 0);
	signal count : integer :=0;
	signal my_dataToWrite :  std_logic_vector(15 downto 0);

	--senyals guardades
	signal my_address       : std_logic_vector(15 downto 0);
	signal  my_byte_m       :   std_logic;
	signal my_WR                :   std_logic;
	signal save :  std_logic := '0';
	signal debugcounter : std_logic_vector (15 downto 0):=(others=>'0');
begin

    process(clk)
    begin
        count <= count + 1;
        case est is
				when writing1 =>
					if count >= 6 then
						est <= writing2;
					end if;
            when writing2 =>
               if address = my_address and my_byte_m = byte_m and my_WR = WR then
               else
						if WR = '1' then
							est <= writing1;
                  else
							est <= reading;
                  end if;
               end if;
            when others =>
					if WR = '1' then
						est <= writing1;
                  count <= 0;
                  my_address <= address;
                  my_byte_m <= byte_m;
                  my_WR <= WR;
               else
						est <= reading;
               end if;
		end case;
    end process;

    mid <=  (others=>SRAM_DQ(7)) when address(0) = '0' else
            (others=>SRAM_DQ(15)) when address(0) = '1';

    SRAM_ADDR <= "000" & (address(15 downto 1 )); -- when (address>= X"C000") else "00"&address;
    with est select -- Signals are negated
        SRAM_WE_N <= '1' when reading,
                     '0' when writing1,
                     '1' when writing2,
                     'X' when others;

        SRAM_OE_N <= '0';

        SRAM_UB_N <= '0' when est=reading else
                     '1' when (est=writing1 or est=writing2) and byte_m='1' and address(0)='0' else
                     '0' when (est=writing1 or est=writing2) and byte_m='1' and address(0)='1' else
                     '0' when (est=writing1 or est=writing2) and byte_m='0';

        SRAM_LB_N <= '0' when est=reading else
                     '0' when (est=writing1 or est=writing2) and byte_m='1' and address(0)='0' else
                     '1' when (est=writing1 or est=writing2) and byte_m='1' and address(0)='1' else
                     '0' when (est=writing1 or est=writing2) and byte_m='0';


        dataReaded <= SRAM_DQ when byte_m='0' and est=reading else
                         mid&SRAM_DQ(7 downto 0) when byte_m='1' and address(0)='0'and est=reading else
                         mid&SRAM_DQ(15 downto 8)when byte_m='1' and address(0)='1'and est=reading else
                         "0000000000000000";

        my_dataToWrite <= dataToWrite(7 downto 0)&"00000000" when byte_m='1' and address(0)='1' else
                            dataToWrite;

        with est select
            SRAM_DQ<= my_dataToWrite when writing1,
                         my_dataToWrite when writing2,
                         (others=>'Z') when reading,
                         (others=>'Z') when others;

end behavior;
