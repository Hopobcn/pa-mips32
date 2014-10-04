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
				
	-- "0000" and | andi         [core]
	-- "0001" or  | ori          [core]
	-- "0010" add | addi | addiu [core]
	-- "0011" sll                [shifter]
	-- "0100" srl                [shifter]
	-- "0101" sra                [shifter]
	-- "0110" sub          			[core]
	-- "0111" slt | slti | sltiu [core]
	-- "1000" 
	-- "1001"   
	-- "1010" mult               [multiplier]
	-- "1011" div                [multiplier]
	-- "1100" nor                [core]
	-- "1101"
	-- "1110" 
	-- "1111" xor | xori         [core]
				
	res <= result_shifter 	when (ALUOp = "0011" or 		--sll
											ALUOp = "0100" or 		--srl
											ALUOp = "0101") else		--sra
			 result_core	 	when (ALUOp = "0000" or			--and | andi 
											ALUOp = "0001" or			--or  | ori
											ALUOp = "0010" or			--add | addi | addiu
											ALUOp = "0110" or			--sub
											ALUOp = "0111" or			--slt | slti | sltiu
											ALUOp = "1100" or			--nor
											ALUOp = "1111") else 	--xor | xori
			 result_multiLo	when (ALUOp = "1010" or			--mult 
											ALUOp = "1011") else 	--divu
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