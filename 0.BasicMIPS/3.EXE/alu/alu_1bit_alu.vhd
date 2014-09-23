library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ALU implementation from Patterson/Hennesy 5th ed. Appendix B. p B-27 to B-37.

entity alu_1bit_alu is
	port(	-- buses
			a			:	in std_logic;
			b			:	in std_logic;
			less		:	in	std_logic;
			carryIn	:	in	std_logic;
			res		:	out std_logic;
			carryOut	:	out std_logic;
			-- control signals
			Ainvert	: 	in std_logic;
			Binvert	:	in	std_logic;
			Operation:	in	std_logic_vector(1 downto 0));
end alu_1bit_alu;

architecture Structure of alu_1bit_alu is
	
	component alu_1bit_adder is
	port(	a			:	in std_logic;
			b			:	in std_logic;
			carryIn	:	in	std_logic;
			res		:	out std_logic;
			carryOut	:	out std_logic);
	end component;
	
	signal a_tmp	:	std_logic;
	signal b_tmp	:	std_logic;
	signal and_res	:	std_logic;
	signal or_res	:	std_logic;
	signal add_res	:	std_logic;
	
begin

	a_tmp <= a	when Ainvert = '0' else
				not a;
				
	b_tmp <= b when Binvert = '0' else
				not b;
	
	-- OPERATIONS
	and_res	<= a_tmp and b_tmp;

	or_res	<= a_tmp or b_tmp;
	
	adder : alu_1bit_adder
	port map(a			=> a_tmp,
				b			=>	b_tmp,
				carryIn	=> carryIn,
				res		=>	add_res,
				carryOut	=>	carryOut);
				
				
	res	<= and_res	when Operation = "00" else
				or_res	when Operation = "01" else
				add_res	when Operation = "10" else
				less		when Operation = "11";
				
	--res	<= (x & y) when ALUOp = "0000" else -- AND
	--			(x | y)	when ALUOp = "0001" else -- OR
	--			x + y when ALUOp = "0010" else -- ADD
	--			x - y when ALUOp = "0110" else -- SUB
	--		  (x > y)when ALUOp = "0111" else -- SetOnLessThan  	--acabar d'implementar be
	--		 !(x + y)when ALUOp = "1100";								--acabar d'implementar be
		  
	
end Structure;






