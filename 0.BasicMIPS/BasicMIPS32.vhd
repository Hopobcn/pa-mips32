library ieee;
use ieee.std_logic_1164.all;

entity BasicMIPS32 is
	port(	clk	: in std_logic;
			boot	: in std_logic);
			
end BasicMIPS32;

architecture Structure of BasicMIPS32 is
	
	component instruction_fetch is
	port (-- buses
			addr_jump		:	in	std_logic_vector(31 downto 0);	--from MEM
			addr_branch		:	in	std_logic_vector(31 downto 0); 	--from MEM
			pc_up				:	out std_logic_vector(31 downto 0);  --to stage ID
			instruction		: 	out std_logic_vector(31 downto 0);	--to stage ID
			-- control signals
			clk				:	in std_logic;
			boot				:	in std_logic;
			Jump				:	in std_logic;								--from MEM
			PCSrc				:	in std_logic);								--from MEM
	end component;
	
	component instruction_decode is
	port (-- buses
			instruction		: 	in std_logic_vector(31 downto 0);	--from IF
			addr_jump		:	out std_logic_vector(31 downto 0);	--to EXE,MEM,IF
			pc_up_in			:	in	std_logic_vector(31 downto 0);	--from IF
			pc_up_out		:	out std_logic_vector(31 downto 0);	--to EXE
			opcode			:	out std_logic_vector(5 downto 0);	--to EXE
			rs					:	out std_logic_vector(31 downto 0);	--to EXE
			rt					:	out std_logic_vector(31 downto 0);	--to EXE
			rd					:	in	std_logic_vector(31 downto 0);	--from WB			
			sign_ext 		:	out std_logic_vector(31 downto 0);	--to EXE
			zero_ext			:	out std_logic_vector(31 downto 0);	--to EXE
			addr_rt			:	out std_logic_vector(4 downto 0);	--to EXE
			addr_rd			:	out std_logic_vector(4 downto 0);	--to EXE
			addr_regw		:	in	std_logic_vector(4 downto 0);		--from WB
			-- control signals
			clk				:	in std_logic;
			RegWrite_out	:	out std_logic;								--to EXE,MEM,WB and then ID
			Jump				:	out std_logic;								--to EXE,MEM,IF
			Branch			:	out std_logic;								--to EXE,MEM
			MemRead			:	out std_logic;								--to EXE,MEM
			MemWrite			:	out std_logic;								--to EXE,MEM
			MemtoReg			:	out std_logic;								--to EXE,MEM,WB
			RegDst			:	out std_logic;								--to EXE
			ALUOp				:	out std_logic_vector(2 downto 0);	--to EXE
			ALUSrc			:	out std_logic;								--to EXE
			RegWrite_in		:	in	std_logic);								--from WB		
	end component;

	component execute is
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
	end component;
			
	component mem is
	port (-- buses
			addr_jump_in	:	in	std_logic_vector(31 downto 0);	--from EXE
			addr_jump_out	:	out std_logic_vector(31 downto 0);	--to IF
			addr_branch_in	:	in std_logic_vector(31 downto 0);	--from MEM
			addr_branch_out:	out std_logic_vector(31 downto 0);	--to IF
			addr				:	in std_logic_vector(31 downto 0);	--from EXE --named alu_res in EXE
			write_data		:	in std_logic_vector(31 downto 0);	--from EXE
			read_data		:	out std_logic_vector(31 downto 0);	--to WB
			bypass_mem		:	out std_logic_vector(31 downto 0); 	--to WB
			addr_regw_in	: 	in	std_logic_vector(4 downto 0);		--from EXE
			addr_regw_out	:	out std_logic_vector(4 downto 0);	--to WB, then IF
			-- control signals
			clk				:	in std_logic;
			RegWrite_in		:	in std_logic;								--from EXE
			RegWrite_out	:	out std_logic;								--to WB, then ID
			Jump_in			:	in std_logic;								--from EXE
			Jump_out			:	out std_logic;								--to IF
			Branch			:	in std_logic;								--from EXE
			PCSrc				:	out std_logic;								--to ID
			MemRead			:	in std_logic;								--from EXE
			MemWrite			:	in std_logic;								--from EXE
			MemtoReg_in		:	in std_logic;								--from MEM
			MemtoReg_out	:	out std_logic;								--to WB
			Zero				:	in std_logic);								--from EXE
	end component;
		
	component write_back is
	port (-- buses
			read_data		:	in std_logic_vector(31 downto 0);	--from MEM
			bypass_mem		:	in std_logic_vector(31 downto 0); 	--from MEM
			write_data		:	out std_logic_vector(31 downto 0);	--to IF
			addr_regw_in	:	in	std_logic_vector(4 downto 0);	--from MEM
			addr_regw_out	:	out std_logic_vector(4 downto 0);	--to IF
			-- control signals
			RegWrite_in		:	in std_logic;
			RegWrite_out	:	out std_logic;
			MemtoReg			:	in	std_logic);
	end component;
	
	-- buses
	signal addr_jump_2to3	:	std_logic_vector(31 downto 0);
	signal addr_jump_3to4	:	std_logic_vector(31 downto 0);
	signal addr_jump_4to1	:	std_logic_vector(31 downto 0);
	
	signal addr_branch_3to4	:	std_logic_vector(31 downto 0);
	signal addr_branch_4to1	:	std_logic_vector(31 downto 0);
	
	signal pc_up_1to2			:	std_logic_vector(31 downto 0);
	signal pc_up_2to3			:	std_logic_vector(31 downto 0);
	
	signal instruction_1to2	:	std_logic_vector(31 downto 0);
	signal opcode_2to3		:	std_logic_vector(5 downto 0);
	
	signal register_s_2to3	:	std_logic_vector(31 downto 0);
	signal register_t_2to3	:	std_logic_vector(31 downto 0);
	signal register_d_5to2	:	std_logic_vector(31 downto 0);
	
	signal sign_ext_2to3		:	std_logic_vector(31 downto 0);
	signal zero_ext_2to3		: 	std_logic_vector(31 downto 0);
	
	signal alu_res_3to4		:	std_logic_vector(31 downto 0);
	
	signal write_data_3to4	:	std_logic_vector(31 downto 0);
	signal read_data_4to5	:	std_logic_vector(31 downto 0);
	signal bypass_mem_4to5	:	std_logic_vector(31 downto 0);
	
	signal addr_rt_2to3		:	std_logic_vector(4 downto 0);
	signal addr_rd_2to3		:	std_logic_vector(4 downto 0);
	signal addr_regw_3to4	: 	std_logic_vector(4 downto 0);
	signal addr_regw_4to5	: 	std_logic_vector(4 downto 0);
	signal addr_regw_5to2	: 	std_logic_vector(4 downto 0);
	
	-- control signals
	signal PCSrc_4to1			:	std_logic;
	
	signal RegWrite_2to3		:	std_logic;
	signal RegWrite_3to4		:	std_logic;
	signal RegWrite_4to5		:	std_logic;
	signal RegWrite_5to2		:	std_logic;
	
	signal Jump_2to3			:	std_logic;
	signal Jump_3to4			:	std_logic;
	signal Jump_4to1			:	std_logic;
	
	signal Branch_2to3		:	std_logic;
	signal Branch_3to4		:	std_logic;
	
	signal RegDst_2to3		:	std_logic;
	signal ALUOp_2to3			:	std_logic_vector(2 downto 0);
	signal ALUSrc_2to3		:	std_logic;
	
	signal MemRead_2to3		:	std_logic;
	signal MemRead_3to4		:	std_logic;
	
	signal MemWrite_2to3		:	std_logic;
	signal MemWrite_3to4		:	std_logic;
			
	signal MemtoReg_2to3		:	std_logic;
	signal MemtoReg_3to4		:	std_logic;
	signal MemtoReg_4to5		:	std_logic;
	
	signal Zero_3to4			:	std_logic;
	
begin

	first_stage	:	instruction_fetch
	port map(addr_jump	=> addr_jump_4to1,
				addr_branch	=>	addr_branch_4to1,
				pc_up			=> pc_up_1to2,
				instruction	=> instruction_1to2,
				clk			=> clk,
				boot			=> boot,
				Jump			=> Jump_4to1,
				PCSrc			=> PCSrc_4to1);

	second_stage	:	instruction_decode 
	port map(instruction	=> instruction_1to2,
				addr_jump	=> addr_jump_2to3,
				pc_up_in		=> pc_up_1to2,
				pc_up_out	=> pc_up_2to3,
				opcode		=> opcode_2to3,
				rs				=> register_s_2to3,
				rt				=> register_t_2to3,
				rd				=> register_d_5to2,
				sign_ext 	=> sign_ext_2to3,
				zero_ext		=> zero_ext_2to3,
				addr_rt		=> addr_rt_2to3,
				addr_rd		=> addr_rd_2to3,
				addr_regw	=> addr_regw_5to2,
				clk			=> clk,
				RegWrite_out=> RegWrite_2to3,
				Jump			=> Jump_2to3,
				Branch		=> Branch_2to3,
				MemRead		=>	MemRead_2to3,
				MemWrite		=>	MemWrite_2to3,
				MemtoReg		=> MemtoReg_2to3,
				RegDst		=> RegDst_2to3,
				ALUOp			=> ALUOp_2to3,
				ALUSrc		=> ALUSrc_2to3,
				RegWrite_in => RegWrite_5to2);
	
	third_stage	:	execute
	port map(pc_up			=> pc_up_2to3,
				opcode		=> opcode_2to3,
				rs				=> register_s_2to3,
				rt				=> register_t_2to3,
				sign_ext 	=> sign_ext_2to3,
				zero_ext		=> zero_ext_2to3,
				addr_rt		=> addr_rt_2to3,
				addr_rd		=> addr_rd_2to3,
				addr_jump_in =>addr_jump_2to3,
				addr_jump_out=>addr_jump_3to4,
				addr_branch	=> addr_branch_3to4,
				alu_res		=> alu_res_3to4,
				write_data	=> write_data_3to4,
				addr_regw	=> addr_regw_3to4,
				RegWrite_in => RegWrite_2to3,
				RegWrite_out=> RegWrite_3to4,
				Jump_in		=>	Jump_2to3,
				Jump_out		=>	Jump_3to4,
				Branch_in	=> Branch_2to3,
				Branch_out	=> Branch_3to4,
				MemRead_in	=>	MemRead_2to3,
				MemRead_out	=>	MemRead_3to4,
				MemWrite_in	=> MemWrite_2to3,
				MemWrite_out=> MemWrite_3to4,
				MemtoReg_in	=> MemtoReg_2to3,
				MemtoReg_out=> MemtoReg_3to4,
				RegDst		=> RegDst_2to3,
				ALUOp			=> ALUOp_2to3,
				ALUSrc		=> ALUSrc_2to3,
				Zero			=> Zero_3to4);
				
	fourth_stage	:	mem
	port map(
				addr_jump_in 		=> addr_jump_3to4,
				addr_jump_out		=> addr_jump_4to1,
				addr_branch_in		=> addr_branch_3to4,
				addr_branch_out	=>	addr_branch_4to1,
				addr					=> alu_res_3to4,
				write_data			=> write_data_3to4,
				read_data			=> read_data_4to5,
				bypass_mem			=> bypass_mem_4to5,
				addr_regw_in		=> addr_regw_3to4,
				addr_regw_out		=> addr_regw_4to5,
				clk					=> clk,
				RegWrite_in			=> RegWrite_3to4,
				RegWrite_out		=> RegWrite_4to5,
				Jump_in				=>	Jump_3to4,
				Jump_out				=>	Jump_4to1,
				Branch				=> Branch_3to4,
				PCSrc					=> PCSrc_4to1,
				MemRead				=> MemRead_3to4,
				MemWrite				=> MemWrite_3to4,
				MemtoReg_in			=> MemtoReg_3to4,
				MemtoReg_out		=> MemtoReg_4to5,
				Zero					=> Zero_3to4);
	
	fifth_stage	:	write_back
	port map(read_data		=> read_data_4to5,
				bypass_mem		=> bypass_mem_4to5,
				write_data		=> register_d_5to2,
				addr_regw_in	=> addr_regw_4to5,
				addr_regw_out	=> addr_regw_5to2,
				RegWrite_in		=> RegWrite_4to5,
				RegWrite_out	=> RegWrite_5to2,
				MemtoReg			=>	MemtoReg_4to5);
			
end Structure;