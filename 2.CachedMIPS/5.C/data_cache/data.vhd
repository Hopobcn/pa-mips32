library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity ddata is
    port (-- data buses
          index         : in  std_logic_vector(4 downto 0); -- 32 containers == 5 bits of index
          block_offset  : in  std_logic_vector(3 downto 0); -- offset inside a container (1 container == 4 words = 16 bytes)
          write_data    : in  std_logic_vector(31 downto 0);
          fill          : in  std_logic_vector(127 downto 0);
          read_data     : out std_logic_vector(31 downto 0);
          -- control signals
          WriteOrFill   : in  std_logic;
          WriteEnable   : in  std_logic);
end ddata;

architecture Structure of ddata is
    type ARRAY_DATA is array (2**5-1 downto 0) of std_logic_vector(127 downto 0);
    signal mem_data : ARRAY_DATA;

    signal cacheLine_128     : std_logic_vector(127 downto 0);
    signal cacheLine_up_128  : std_logic_vector(127 downto 0);
begin
    
    cacheLine_128      <= mem_data(to_integer(unsigned(index      )));
    cacheLine_up_128   <= mem_data(to_integer(unsigned(index+x"01")));
	 
    read_data <= cacheLine_128( 31 downto  0) when block_offset = "0000" else -- 0 ALIGNED
                 cacheLine_128( 39 downto  8) when block_offset = "0001" else -- 1
                 cacheLine_128( 47 downto 16) when block_offset = "0010" else -- 2
                 cacheLine_128( 55 downto 24) when block_offset = "0011" else -- 3
                 cacheLine_128( 63 downto 32) when block_offset = "0100" else -- 4 ALIGNED
                 cacheLine_128( 71 downto 40) when block_offset = "0101" else -- 5
                 cacheLine_128( 79 downto 48) when block_offset = "0110" else -- 6
                 cacheLine_128( 87 downto 56) when block_offset = "0111" else -- 7
                 cacheLine_128( 95 downto 64) when block_offset = "1000" else -- 8 ALIGNED
                 cacheLine_128(103 downto 72) when block_offset = "1001" else -- 9
                 cacheLine_128(111 downto 80) when block_offset = "1010" else --10
                 cacheLine_128(119 downto 88) when block_offset = "1011" else --11
                 cacheLine_128(127 downto 96) when block_offset = "1100" else --12 ALIGNED
                 -- This is not correct: we could be reading 'I' cache lines!!!!!!!! THING A BETTER WAY
                 cacheLine_up_128( 7 downto 0) & cacheLine_128(127 downto 104) when block_offset = "1101" else --13 two line caches
                 cacheLine_up_128(15 downto 0) & cacheLine_128(127 downto 112) when block_offset = "1110" else --14 two line caches
                 cacheLine_up_128(23 downto 0) & cacheLine_128(127 downto 120) when block_offset = "1111" else --15 two line caches
					  
                 x"DABEEFFF"; -- error (block_offset probably was shit)

    data_write : process(index,writeEnable,WriteOrFill)
    begin
        if (writeEnable = '1') then
            if (WriteOrFill = '0') then -- Write from the processor
                if (block_offset = "0000") then
                    mem_data(to_integer(unsigned(index))) <= cacheLine_128(127 downto 32) & write_data;
					 elsif (block_offset = "0001") then
                    mem_data(to_integer(unsigned(index))) <= cacheLine_128(127 downto 40) & write_data & cacheLine_128( 7 downto 0);
					 elsif (block_offset = "0010") then
                    mem_data(to_integer(unsigned(index))) <= cacheLine_128(127 downto 48) & write_data & cacheLine_128(15 downto 0);
					 elsif (block_offset = "0011") then
                    mem_data(to_integer(unsigned(index))) <= cacheLine_128(127 downto 56) & write_data & cacheLine_128(23 downto 0);
					 elsif (block_offset = "0100") then
                    mem_data(to_integer(unsigned(index))) <= cacheLine_128(127 downto 64) & write_data & cacheLine_128(31 downto 0);
					 elsif (block_offset = "0101") then
                    mem_data(to_integer(unsigned(index))) <= cacheLine_128(127 downto 72) & write_data & cacheLine_128(39 downto 0);
					 elsif (block_offset = "0110") then
                    mem_data(to_integer(unsigned(index))) <= cacheLine_128(127 downto 80) & write_data & cacheLine_128(47 downto 0);
					 elsif (block_offset = "0111") then
                    mem_data(to_integer(unsigned(index))) <= cacheLine_128(127 downto 88) & write_data & cacheLine_128(55 downto 0);
					 elsif (block_offset = "1000") then
                    mem_data(to_integer(unsigned(index))) <= cacheLine_128(127 downto 96) & write_data & cacheLine_128(63 downto 0);
					 elsif (block_offset = "1001") then
                    mem_data(to_integer(unsigned(index))) <= cacheLine_128(127 downto 104) & write_data & cacheLine_128(71 downto 0);
					 elsif (block_offset = "1010") then
                    mem_data(to_integer(unsigned(index))) <= cacheLine_128(127 downto 112) & write_data & cacheLine_128(79 downto 0);
					 elsif (block_offset = "1011") then
                    mem_data(to_integer(unsigned(index))) <= cacheLine_128(127 downto 120) & write_data & cacheLine_128(87 downto 0);
					 elsif (block_offset = "1100") then
                    mem_data(to_integer(unsigned(index))) <=                                 write_data & cacheLine_128(95 downto 0);
						  
                 -- This is not correct: we could be reading 'I' cache lines!!!!!!!! THING A BETTER WAY
					 elsif (block_offset = "1101") then 
                    mem_data(to_integer(unsigned(index      ))) <=                                  write_data(23 downto  0) & cacheLine_128(103 downto 0);
                    mem_data(to_integer(unsigned(index+x"01"))) <= cacheLine_up_128(127 downto 8) & write_data(31 downto 24);
					 elsif (block_offset = "1110") then
                    mem_data(to_integer(unsigned(index      ))) <=                                   write_data(15 downto  0) & cacheLine_128(111 downto 0);
                    mem_data(to_integer(unsigned(index+x"01"))) <= cacheLine_up_128(127 downto 16) & write_data(31 downto 16);
					 elsif (block_offset = "1111") then
                    mem_data(to_integer(unsigned(index      ))) <=                                   write_data( 7 downto 0) & cacheLine_128(119 downto 0);
                    mem_data(to_integer(unsigned(index+x"01"))) <= cacheLine_up_128(127 downto 23) & write_data(31 downto 8);
					 else
					     --error Do nothing
                end if;
            else
                mem_data(to_integer(unsigned(index))) <= fill;
            end if;
        end if;
    end process data_write;

end Structure;
