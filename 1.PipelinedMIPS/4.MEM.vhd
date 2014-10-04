library ieee;
use ieee.std_logic_1164.all;

entity mem is
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
			MemWrite			:	in std_logic;								--from EXE;
			ByteAddress 	:  in std_logic;								--from EXE
			WordAddress		:	in	std_logic;								--from EXE
			MemtoReg_in		:	in std_logic;								--from MEM
			MemtoReg_out	:	out std_logic;								--to WB
			Zero				:	in std_logic);								--from EXE
			
end mem;

architecture Structure of mem is
	
	component exe_mem_reg is
	port (-- buses
			addr_jump_in	:	in		std_logic_vector(31 downto 0);	
			addr_jump_out	:	out 	std_logic_vector(31 downto 0);	
			addr_branch_in	:	in 	std_logic_vector(31 downto 0);	
			addr_branch_out:	out 	std_logic_vector(31 downto 0);
			addr_in			:	in 	std_logic_vector(31 downto 0);	
			addr_out			:	out 	std_logic_vector(31 downto 0);
			write_data_in	:	in 	std_logic_vector(31 downto 0);
			write_data_out	:	out 	std_logic_vector(31 downto 0);	
			addr_regw_in	: 	in		std_logic_vector(4 downto 0);		
			addr_regw_out	:	out 	std_logic_vector(4 downto 0);
			-- control signals
			RegWrite_in		:	in 	std_logic;								
			RegWrite_out	:	out 	std_logic;							
			Jump_in			:	in 	std_logic;							
			Jump_out			:	out 	std_logic;	
			Branch_in		:	in 	std_logic;		
			Branch_out		:	out 	std_logic;		
			MemRead_in		:	in 	std_logic;	
			MemRead_out		:	out 	std_logic;	
			MemWrite_in		:	in 	std_logic;	
			MemWrite_out	:	out 	std_logic;	
			ByteAddress_in	:  in 	std_logic;	
			ByteAddress_out:  out 	std_logic;	
			WordAddress_in	:	in		std_logic;	
			WordAddress_out:	out	std_logic;
			MemtoReg_in		:	in 	std_logic;		
			MemtoReg_out	:	out 	std_logic;
			Zero_in			:	in 	std_logic;
			Zero_out			:	out 	std_logic;	
			-- register control signals
			enable			:	in std_logic;
			clk				:	in std_logic);
	end component;

	signal addr_jump_reg		:	std_logic_vector(31 downto 0);	
	signal addr_branch_reg	:	std_logic_vector(31 downto 0);	
	signal addr_reg			:	std_logic_vector(31 downto 0);	
	signal write_data_reg	:	std_logic_vector(31 downto 0);
	signal addr_regw_reg		: 	std_logic_vector(4 downto 0);	
	signal RegWrite_reg		:	std_logic;							
	signal Jump_reg			:	std_logic;		
	signal Branch_reg			:	std_logic;		
	signal MemRead_reg		:	std_logic;	
	signal MemWrite_reg		:	std_logic;	
	signal ByteAddress_reg	:  std_logic;	
	signal WordAddress_reg	:	std_logic;	
	signal MemtoReg_reg		:	std_logic;		
	signal Zero_reg			:	std_logic;
			
	component data_mem is
	port (addr			:	in std_logic_vector(31 downto 0);
			write_data	:	in std_logic_vector(31 downto 0);
			read_data	:	out std_logic_vector(31 downto 0);
			clk			:	in std_logic;
			MemRead		:	in std_logic;
			MemWrite		:	in	std_logic;
			ByteAddress :  in std_logic;
			WordAddress	:	in	std_logic);
	end component;
	
begin

	-- EXE/MEM Register 
	EXE_MEM_register : exe_mem_reg
	port map(addr_jump_in	=> addr_jump_in,
				addr_jump_out	=> addr_jump_reg,
				addr_branch_in	=> addr_branch_in,
				addr_branch_out=> addr_branch_reg,
				addr_in			=> addr,
				addr_out			=> addr_reg,
				write_data_in	=> write_data,
				write_data_out	=> write_data_reg,
				addr_regw_in	=> addr_regw_in,
				addr_regw_out	=> addr_regw_reg,
				RegWrite_in		=> RegWrite_in,				
				RegWrite_out	=> RegWrite_reg,	
				Jump_in			=> Jump_in,
				Jump_out			=> Jump_reg,
				Branch_in		=> Branch,
				Branch_out		=> Branch_reg,
				MemRead_in		=> MemRead,
				MemRead_out		=> MemRead_reg,
				MemWrite_in		=> MemWrite,
				MemWrite_out	=> MemWrite_reg,
				ByteAddress_in	=> ByteAddress,
				ByteAddress_out=> ByteAddress_reg,
				WordAddress_in	=> WordAddress,
				WordAddress_out=> WordAddress_reg,
				MemtoReg_in		=> MemtoReg_in,
				MemtoReg_out	=> MemtoReg_reg,
				Zero_in			=> Zero,
				Zero_out			=> Zero_reg,
				enable			=> '1',
				clk				=> clk);
	
	
	addr_jump_out 	 <= addr_jump_reg;
	addr_branch_out <= addr_branch_reg;
	addr_regw_out 	 <= addr_regw_reg;
	bypass_mem		 <= addr_reg;
	
	RegWrite_out	<= RegWrite_reg;
	Jump_out			<= Jump_reg;
	MemtoReg_out	<=	MemtoReg_reg;
	PCSrc				<= Branch_reg and Zero_reg; 
	
	data_memory	: data_mem
	port map(addr			=> addr_reg,
				write_data	=>	write_data_reg,
				read_data	=>	read_data,
				clk			=> clk,
				MemRead		=> MemRead_reg,
				MemWrite		=> MemWrite_reg,
				ByteAddress => ByteAddress_reg,
				WordAddress	=>	WordAddress_reg);
				
end Structure;