library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_shifter is
	port(	-- buses
			a			:	in std_logic_vector(31 downto 0);
			shamt		:	in std_logic_vector(31 downto 0);
			res		:	out std_logic_vector(31 downto 0);
			-- control signals
			ALUOp		:	in	std_logic_vector(3 downto 0));
end alu_shifter;

architecture Structure of alu_shifter is

	--signal shift : natural;
begin
	--shift <= Natural(shamt);
	
   -- Each bit in the output vector has its own mux.
   -- Use the input word bit position as an "offset," to which the new
   -- position is subtracted, modulo the word size, to give the mux select.
	--barrelShifter : for bitpos in a'range generate
	--res(bitpos) <= a((bitpos - shift) mod (a'high + 1));
	
	shifter : process(a,shamt)
		variable shift : 	Integer;
		variable tmp	:	std_logic_vector(31 downto 0);
	begin
		shift := to_integer(unsigned(shamt));
		tmp	:= a;
		
		for i in 1 to 32 loop
			if i <= shift then
				tmp := tmp(30 downto 0) & '0';
			end if;
		end loop;
		res <= tmp;
	end process;
end Structure;