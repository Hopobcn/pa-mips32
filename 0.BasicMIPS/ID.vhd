library ieee;
use ieee.std_logic_1164.all;

entity instruction_decode is
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
			ByteAddress 	:  out std_logic;								--to EXE,MEM
			WordAddress		:	out std_logic;								--to EXE,MEM
			MemtoReg			:	out std_logic;								--to EXE,MEM,WB
			RegDst			:	out std_logic;								--to EXE
			ALUOp				:	out std_logic_vector(2 downto 0);	--to EXE
			ALUSrc			:	out std_logic;								--to EXE
			RegWrite_in		:	in	std_logic);								--from WB
			
end instruction_decode;


architecture Structure of instruction_decode is

	component control_inst_decode is
	port (opcode 		: 	in std_logic_vector(5 downto 0);
			RegWrite		: 	out std_logic;
			Jump			:	out std_logic;
			Branch		:	out std_logic;
			MemRead		:	out std_logic;								
			MemWrite		:	out std_logic;	
			ByteAddress	:	out std_logic;
			WordAddress	:	out std_logic;
			MemtoReg		:	out std_logic;
			RegDst		:	out std_logic;	
			ALUOp			:	out std_logic_vector(2 downto 0);
			ALUSrc		:	out std_logic);	
	end component;
	
	component regfile is
	port (clk		:	in std_logic;
			addr_rs	:	in std_logic_vector(4 downto 0);
			addr_rt	:	in	std_logic_vector(4 downto 0);
			addr_rd	:	in	std_logic_vector(4 downto 0);
			rs			:	out std_logic_vector(31 downto 0);
			rt			: 	out std_logic_vector(31 downto 0);
			rd			:	in	std_logic_vector(31 downto 0);
			RegWrite	:	in	std_logic);
	end component;
	
	component seu is
	port (input	 :	in	std_logic_vector(15 downto 0);
			output :	out std_logic_vector(31 downto 0));
	end component;
	
begin
		--jump addres is PC+4[31-28]+Shift_left_2(Instruction[25-0])
	addr_jump	<= pc_up_in(31 downto 28) & instruction(25 downto 0) & "00";
	pc_up_out 	<= pc_up_in;
	opcode		<= instruction(31 downto 26);
	addr_rt 	 	<= instruction(20 downto 16);
	addr_rd		<=	instruction(15 downto 11);
	
	--logica de control enmascarada, aixi es mes facil gestionar-la
	control : control_inst_decode 
	port map(opcode 		=> instruction(31 downto 26),
				RegWrite 	=> RegWrite_out,
				Jump			=> Jump,
				Branch 		=> Branch,
				MemRead		=> MemRead,
				MemWrite		=> MemWrite,
				ByteAddress => ByteAddress,
				WordAddress	=> WordAddress,
				MemtoReg		=> MemtoReg,
				RegDst		=> RegDst,
				ALUOp			=> ALUOp,
				ALUSrc		=> ALUSrc);
				
	register_file	:	regfile
	port map(clk		=> clk,
				addr_rs	=>	instruction(25 downto 21),
				addr_rt	=> instruction(20 downto 16),
				addr_rd	=> addr_regw,
				rs			=> rs,
				rt			=> rt,
				rd			=> rd,
				RegWrite	=> RegWrite_in);
				
	sign_extend_unit	:	seu
	port map(input		=> instruction(15 downto 0),
				output 	=> sign_ext);
	
	zero_ext <= "0000000000000000" & instruction(15 downto 0);
	
end Structure;