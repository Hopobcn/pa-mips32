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
	signal xor_res : std_logic;
	signal less_or_xor : std_logic;
	
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
				
	xor_res	<= (not(a_tmp) and b_tmp) or (a_tmp and not(b_tmp));
			
	less_or_xor <= xor_res when Ainvert = '1' and Binvert = '1' else
	               less;
	               	
	res	<= and_res	when Operation = "00" else
				or_res	when Operation = "01" else
				add_res	when Operation = "10" else
				less_or_xor; --when Operation = "11";
	
end Structure;






