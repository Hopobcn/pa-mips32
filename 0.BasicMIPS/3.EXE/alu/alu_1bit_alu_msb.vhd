library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ALU implementation from Patterson/Hennesy 5th ed. Appendix B. p B-27 to B-37.

entity alu_1bit_alu_msb is
	port(	-- buses
			a			:	in std_logic;
			b			:	in std_logic;
			less		:	in	std_logic;
			carryIn	:	in	std_logic;
			res		:	out std_logic;
			set 		: 	out std_logic;
			overflow : 	out std_logic;
			-- control signals
			Ainvert	: 	in std_logic;
			Binvert	:	in	std_logic;
			Operation:	in	std_logic_vector(1 downto 0));
end alu_1bit_alu_msb;

architecture Structure of alu_1bit_alu_msb is
	
	component alu_1bit_adder is
	port(	a			:	in std_logic;
			b			:	in std_logic;
			carryIn	:	in	std_logic;
			res		:	out std_logic;
			carryOut	:	out std_logic);
	end component;
	
	component alu_1bit_overflow_detection is
	port(	a			:	in std_logic;
			b			:	in std_logic;
			carryOut	:	in	std_logic;
			res		:	in std_logic;
			overflow	:	out std_logic;
			Binvert	:	in	std_logic);
	end component;
			
	signal a_tmp	:	std_logic;
	signal b_tmp	:	std_logic;
	signal and_res	:	std_logic;
	signal or_res	:	std_logic;
	signal add_res	:	std_logic;
	
	signal carryOut: 	std_logic;
	signal overflow_tmp	: std_logic;
	
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
				
	set 	<= add_res xor overflow_tmp; -- LT for ca2 must consider signs
	
	--overflow detection here
	Overflow_detector : alu_1bit_overflow_detection 
	port map(a			=> a_tmp,
				b			=>	b_tmp,
				carryOut	=>	carryOut,
				res 		=> add_res,
				overflow => overflow_tmp,
				Binvert 	=> Binvert);	
				
	overflow <= overflow_tmp;
	
end Structure;




