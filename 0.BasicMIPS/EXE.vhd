library ieee;
use ieee.std_logic_1164.all;

entity execute is
	port (-- buses
			pc_up				:	in	std_logic_vector(31 downto 0);	--from ID
			rs					:	in std_logic_vector(31 downto 0);	--from ID
			rt					:	in std_logic_vector(31 downto 0);	--from ID
			sign_ext 		:	in std_logic_vector(31 downto 0);	--from ID
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
			ALUOp				:	in std_logic_vector(1 downto 0);		--from ID
			ALUSrc			:	in std_logic;								--from ID
			Zero				:	out std_logic);							--to MEM
			
end execute;

architecture Structure of execute is

	component alu_control is
	port (input 	: in std_logic_vector(5 downto 0); 
			ALUOp_in : in std_logic_vector(1 downto 0);
			ALUOp_out: out std_logic_vector(3 downto 0));
	end component;
	
	component alu is
	port (a			:	in std_logic_vector(31 downto 0);
			b			:	in std_logic_vector(31 downto 0);
			res		:	out std_logic_vector(31 downto 0);
			Zero		:	out std_logic;
			--Overflow	: 	out std_logic;
			--CarryOut	:	out std_logic;
			ALUOp		:	in	std_logic_vector(3 downto 0));
	end component;
	
	component mux is
	port (a	:	in	std_logic_vector(31 downto 0);
			b	:	in std_logic_vector(31 downto 0);
			c	:	out std_logic_vector(31 downto 0);
			s	:	in	std_logic);
	end component;
	
	component adder_branch is
	port (pc_up			:	in std_logic_vector(31 downto 0);
			offset		:	in	std_logic_vector(31 downto 0);
			addr_branch	:	out std_logic_vector(31 downto 0));
	end component;
	
	signal rt_mux 			: 	std_logic_vector(31 downto 0);
	signal ALUOp_control	:	std_logic_vector(3 downto 0);
	
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
	port map(input 		=> sign_ext(5 downto 0), --only 6 bits
				ALUOp_in 	=> ALUOp,
				ALUOp_out 	=> ALUOp_control);
				
	integer_alu	: alu
	port map(a		=> rs,
				b		=> rt_mux,
				res	=> alu_res,
				Zero	=>	Zero,
			 --Overflow	=>
			 --CarryOut	=>
				ALUOp	=> ALUOp_control); 
	
	mux_operand2_alu : mux
	port map(a	=> rt,
				b	=> sign_ext,
				c	=> rt_mux,
				s	=> ALUSrc);
	
	--mux_addr_regwrite	: mux
	--port map(a	=> addr_rt, PROBLEM:32bit-mux & 4bit-InputOutput
	--			b	=>	addr_rd,
	--			c	=>	addr_regw,
	--			s	=>	RegDst);
				
	addr_regw <= addr_rt when RegDst = '1' else
					 addr_rd;
					 
	branches_pc_relative	:	adder_branch
	port map(pc_up			=> pc_up,
				offset		=> sign_ext(29 downto 0)&"00", --shift-left-2
				addr_branch	=>	addr_branch);
				
				
end Structure;