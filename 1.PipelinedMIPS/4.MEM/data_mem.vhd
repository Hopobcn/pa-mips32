library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_mem is
    port ( -- data buses
            addr        :   in std_logic_vector(31 downto 0);
            write_data  :   in std_logic_vector(31 downto 0);
            read_data   :   out std_logic_vector(31 downto 0);
            -- control signals
            clk         :   in std_logic;
            MemRead     :   in std_logic;
            MemWrite    :   in std_logic;
            ByteAddress :   in std_logic;
            WordAddress :   in std_logic;
				-- 
				SRAM_ADDR   : out std_logic_vector(17 downto 0);
            SRAM_DQ     : inout std_logic_vector(15 downto 0);
            SRAM_UB_N   : out std_logic;
            SRAM_LB_N   : out std_logic;
            SRAM_CE_N   : out std_logic := '1';
            SRAM_OE_N   : out std_logic := '1';
            SRAM_WE_N   : out std_logic := '1'
				);
end data_mem;

architecture Structure of data_mem is
    component MemoryController is 
    port (addr          : in  std_logic_vector(15 downto 0);
            wr_data     : in  std_logic_vector(15 downto 0);
            rd_data     : out std_logic_vector(15 downto 0);
            we          : in  std_logic;
            byte_m      : in  std_logic;

            clk          : in  std_logic;

            SRAM_ADDR   : out std_logic_vector(17 downto 0);
            SRAM_DQ     : inout std_logic_vector(15 downto 0);
            SRAM_UB_N   : out std_logic;
            SRAM_LB_N   : out std_logic;
            SRAM_CE_N   : out std_logic := '1';
            SRAM_OE_N   : out std_logic := '1';
            SRAM_WE_N   : out std_logic := '1'
            );
    end component;
	 signal data_out: std_logic_vector(15 downto 0);
begin
	 read_data <= x"0000" & data_out;
	 
    mem: MemoryController
    port map( addr => addr(15 downto 0),
				  wr_data => write_data(15 downto 0),
				  rd_data => data_out,
				  we => MemWrite,
				  byte_m => ByteAddress,
				  clk => clk,
				  
				  SRAM_ADDR  => SRAM_ADDR,
				  SRAM_DQ    => SRAM_DQ,
              SRAM_UB_N  => SRAM_UB_N,
              SRAM_LB_N  => SRAM_LB_N,
              SRAM_CE_N  => SRAM_CE_N,
              SRAM_OE_N  => SRAM_OE_N,
              SRAM_WE_N  => SRAM_WE_N
				  );
				  
 
--    data_mem_read : process(clk)
--    begin
--        if (falling_edge(clk)) then
--            if (MemRead = '1') then
--                if (ByteAddress = '1' and WordAddress = '0') then
--                    read_data(7 downto 0)   <= mem(to_integer(unsigned(addr)));
--                    read_data(31 downto 8)  <=  x"000000";    -- LB should sign ext and LBU should put Zeros
--                elsif (ByteAddress = '0' and WordAddress = '0') then
--                    read_data(7 downto 0)   <= mem(to_integer(unsigned(addr)));
--                    read_data(15 downto 8)  <= mem(to_integer(unsigned(addr)));
--                    read_data(31 downto 16) <=  x"0000";
--                else 
--                    read_data(7 downto 0)   <= mem(to_integer(unsigned(addr)));
--                    read_data(15 downto 8)  <= mem(to_integer(unsigned(addr)));
--                    read_data(23 downto 16) <= mem(to_integer(unsigned(addr)));
--                    read_data(31 downto 24) <= mem(to_integer(unsigned(addr)));
--                end if;
--            end if;
--        end if;
--    end process data_mem_read;
--
--    data_mem_write : process(clk)
--    begin
--        if (falling_edge(clk)) then
--            if (MemWrite = '1') then
--                if (ByteAddress = '1' and WordAddress = '0') then
--                    mem(to_integer(unsigned(addr      ))) <= write_data(7 downto 0);
--                elsif (ByteAddress = '0' and WordAddress = '0') then
--                    mem(to_integer(unsigned(addr      ))) <= write_data(7 downto 0);
--                    mem(to_integer(unsigned(addr+x"01"))) <= write_data(15 downto 8);
--                else
--                    mem(to_integer(unsigned(addr      ))) <= write_data(7 downto 0);
--                    mem(to_integer(unsigned(addr+x"01"))) <= write_data(15 downto 8);
--                    mem(to_integer(unsigned(addr+x"02"))) <= write_data(23 downto 16);
--                    mem(to_integer(unsigned(addr+x"03"))) <= write_data(31 downto 24);
--                end if;
--            end if;
--        end if;
--    end process data_mem_write;

end Structure;
