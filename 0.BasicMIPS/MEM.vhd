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

	addr_jump_out 	 <= addr_jump_in;
	addr_branch_out <= addr_branch_in;
	addr_regw_out 	 <= addr_regw_in;
	bypass_mem		 <= addr;
	
	RegWrite_out	<= RegWrite_in;
	Jump_out			<= Jump_in;
	MemtoReg_out	<=	MemtoReg_in;
	PCSrc				<= Branch and Zero; 
	
	data_memory	: data_mem
	port map(addr			=> addr,
				write_data	=>	write_data,
				read_data	=>	read_data,
				clk			=> clk,
				MemRead		=> MemRead,
				MemWrite		=> MemWrite);
				
end Structure;