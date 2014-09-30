library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity execute is
	port (-- buses
			pc_up				:	in	std_logic_vector(31 downto 0);	--from ID
			opcode			:	in	std_logic_vector(5 downto 0);		--from ID
			rs					:	in std_logic_vector(31 downto 0);	--from ID
			rt					:	in std_logic_vector(31 downto 0);	--from ID
			sign_ext 		:	in std_logic_vector(31 downto 0);	--from ID
			zero_ext			:	in std_logic_vector(31 downto 0);	--from ID
			addr_rt			:	in std_logic_vector(4 downto 0);		--from ID
			addr_rd			:	in std_logic_vector(4 downto 0);		--from ID
			addr_jump_in	:	in	std_logic_vector(31 downto 0);	--from ID
			addr_jump_out	:	out std_logic_vector(31 downto 0);	--to MEM,IF
			addr_branch		:	out std_logic_vector(31 downto 0);	--to MEM,then IF
			alu_res			:	out std_logic_vector(31 downto 0);	--to MEM
			write_data		:	out std_logic_vector(31 downto 0);	--to MEM
			addr_regw		:	out std_logic_vector(4 downto 0);	--to MEM,WB, then IF
			-- control signals
			RegWrite_in		:	in std_logic;								--from ID
			RegWrite_out	:	out std_logic;								--to MEM,WB, then ID
			Jump_in			:	in std_logic;								--from ID
			Jump_out			:	out std_logic;								--to MEM,IF
			Branch_in		:	in std_logic;								--from ID
			Branch_out		:	out std_logic;								--to MEM
			MemRead_in		:	in std_logic;								--from ID 
			MemRead_out		:	out std_logic;								--to MEM
			MemWrite_in		:	in std_logic;								--from ID  
			MemWrite_out	:	out std_logic;								--to MEM		
			MemtoReg_in		:	in std_logic;								--from EXE
			MemtoReg_out	:	out std_logic;								--to MEM,WB
			RegDst			:	in std_logic;								--from ID
			ALUOp				:	in std_logic_vector(2 downto 0);		--from ID
			ALUSrc			:	in std_logic;								--from ID
			Zero				:	out std_logic);							--to MEM
			
end execute;

architecture Structure of execute is

	component alu_control is
	port (opcode	: in std_logic_vector(5 downto 0);
			funct 	: in std_logic_vector(5 downto 0); 
			ALUOp_in : in std_logic_vector(2 downto 0);
			ALUOp_out: out std_logic_vector(3 downto 0);
			SignedSrc: out std_logic;
			ShiftSrc	: out std_logic);
	end component;
	
	component alu is
	port (a			:	in std_logic_vector(31 downto 0);
			b			:	in std_logic_vector(31 downto 0);
			res		:	out std_logic_vector(31 downto 0);
			Zero		:	out std_logic;
			--Overflow	: 	out std_logic;
			--CarryOut	:	out std_logic;
			funct		:	in std_logic_vector(5 downto 0);
			ALUOp		:	in	std_logic_vector(3 downto 0));
	end component;
	
	signal shamt			:	std_logic_vector(31 downto 0);
	signal sign_immed_mux:	std_logic_vector(31 downto 0);
	signal alusrc_mux		:	std_logic_vector(31 downto 0);
	signal shiftsrc_mux	: 	std_logic_vector(31 downto 0);
	signal ALUOp_control	:	std_logic_vector(3 downto 0);
	signal sign_ext_sh2	: 	std_logic_vector(31 downto 0);
	
	signal SignedSrc		:  std_logic;
	signal ShiftSrc		: 	std_logic;
begin

	addr_jump_out	<= addr_jump_in;
	write_data 		<= rt;

	RegWrite_out	<= RegWrite_in;
	Jump_out			<= Jump_in;
	Branch_out		<= Branch_in;
	MemRead_out		<= MemRead_in;
	MemWrite_out	<= MemWrite_in;
	MemtoReg_out	<=	MemtoReg_in;
	
	control : alu_control
	port map(opcode		=> opcode,
				funct 		=> sign_ext(5 downto 0), --only 6 bits
				ALUOp_in 	=> ALUOp,
				ALUOp_out 	=> ALUOp_control,
				SignedSrc   => SignedSrc,
				ShiftSrc		=> ShiftSrc);
				
	integer_alu	: alu
	port map(a		=> rs,
				b		=> shiftsrc_mux,
				res	=> alu_res,
				Zero	=>	Zero,
			 --Overflow	=>
			 --CarryOut	=>
				funct	=> sign_ext(5 downto 0),
				ALUOp	=> ALUOp_control); 
				
	shamt <= "000000000000000000000000000" & zero_ext(10 downto 6);
	
	sign_immed_mux <= zero_ext 	when SignedSrc = '0' else
							sign_ext;
	
	alusrc_mux 		<= rt        	when ALUSrc = '0' else
							sign_immed_mux;          

	shiftsrc_mux	<=	alusrc_mux	when ShiftSrc = '0' else
							shamt;
	
	
	addr_regw <= addr_rt 			when RegDst = '0' else
					 addr_rd;	

				

	sign_ext_sh2	<= sign_ext(29 downto 0)&"00";
			
	addr_branch <= pc_up + sign_ext_sh2;		 

				
				
end Structure;