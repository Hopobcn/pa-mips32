library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ALU implementation from Patterson/Hennesy 5th ed. Appendix B. p B-27 to B-37.

entity alu is
	port(	-- buses
			a			:	in std_logic_vector(31 downto 0);
			b			:	in std_logic_vector(31 downto 0);
			res		:	out std_logic_vector(31 downto 0);
			-- control signals
			Zero		:	out std_logic;
			Overflow	: 	out std_logic;
		 --CarryOut	: 	out std_logic;
			funct		:	in std_logic_vector(5 downto 0);
			ALUOp		:	in	std_logic_vector(3 downto 0));
end alu;

architecture Structure of alu is

	component alu_core is
	port(	a			:	in std_logic_vector(31 downto 0);
			b			:	in std_logic_vector(31 downto 0);
			res		:	out std_logic_vector(31 downto 0);
			Zero		:	out std_logic;
			Overflow	: 	out std_logic;
		 --CarryOut	: 	out std_logic;
			ALUOp		:	in	std_logic_vector(3 downto 0));
	end component;

	component alu_shifter is
	port( a			:	in std_logic_vector(31 downto 0);
			shamt		:	in std_logic_vector(31 downto 0);
			res		:	out std_logic_vector(31 downto 0);
			ALUOp		:	in	std_logic_vector(3 downto 0));
	end component;
	
	component alu_multiplier is
	port( a			:	in std_logic_vector(31 downto 0);
			b			:	in std_logic_vector(31 downto 0);
			resHi		:	out std_logic_vector(31 downto 0);
			resLo		:	out std_logic_vector(31 downto 0);
			Overflow	: 	out std_logic;
		 --CarryOut	: 	out std_logic;
			ALUOp		:	in	std_logic_vector(3 downto 0));
	end component;
	
	signal result_core 		: std_logic_vector(31 downto 0);
	signal result_shifter 	: std_logic_vector(31 downto 0);
	signal result_multiHi 	: std_logic_vector(31 downto 0);
	signal result_multiLo 	: std_logic_vector(31 downto 0);
	
	signal Zero_core			: std_logic;
	signal Overflow_core		: std_logic;
	signal Overflow_multiplier : std_logic;
begin
	
	basic_ops_unit : alu_core
	port map(a			=> a,
				b			=> b,
				res		=> result_core,
				Zero		=> Zero_core,
				Overflow	=> Overflow_core,
				ALUOp		=> ALUOp);
	
	shift_unit : alu_shifter
	port map(a			=> a,
				shamt		=> b,
				res		=> result_shifter,
				ALUOp		=> ALUOp);
				
	mult_div_unit : alu_multiplier
	port map(a			=> a,
				b			=> b,
				resHi		=> result_multiHi,
				resLo		=> result_multiLo,
				Overflow	=> Overflow_multiplier,
				ALUOp		=> ALUOp);
				
	res <= result_core 		when (funct = "000000" or 		--sll
											funct = "000010" or 		--srl
											funct = "000011" or 		--sra
											funct = "000100" or 		--sllv
											funct = "000110" or 		--srlv
											funct = "000111") else 	--srav
			 result_shifter 	when (funct = "100000" or 		--add
											funct = "100001" or 		--addu
											funct = "100010" or 		--sub
											funct = "100011" or 		--subu
											funct = "100100" or 		--and
											funct = "100101" or 		--or
											funct = "100110" or 		--xor
											funct = "100111" or 		--nor
											funct = "101010" or 		--slt
											funct = "101011") else 	--sltu
			 result_multiLo	when (funct = "011000" or 		--mult
											funct = "011001" or		--multu
											funct = "011010" or		--div
											funct = "011011") else  --divu
			 result_multiHi;
			 
	Zero 		<= Zero_core;
						--CHECK OPERATIONS THAT THROW OVERFLOWS
	Overflow <= Overflow_core 			when (funct = "100000" or 		--add
														funct = "100010" or 		--sub
														funct = "100100" or 		--and
														funct = "100101" or 		--or
														funct = "100110" or 		--xor
														funct = "100111" or 		--nor
														funct = "101010") else 	--slt
					Overflow_multiplier 	when (funct = "011000" or 		--mult
														funct = "011010") else  --div
					'0';
						
				
end Structure;