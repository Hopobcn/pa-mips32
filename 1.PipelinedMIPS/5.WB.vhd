library ieee;
use ieee.std_logic_1164.all;

entity write_back is
	port (-- buses
			read_data		:	in std_logic_vector(31 downto 0);	--from MEM
			bypass_mem		:	in std_logic_vector(31 downto 0); 	--from MEM
			write_data		:	out std_logic_vector(31 downto 0);	--to IF
			addr_regw_in	:	in	std_logic_vector(4 downto 0);	--from MEM
			addr_regw_out	:	out std_logic_vector(4 downto 0);	--to IF
			-- control signals
			clk				:	in std_logic;
			RegWrite_in		:	in std_logic;
			RegWrite_out	:	out std_logic;
			MemtoReg			:	in	std_logic);
			
end write_back;

architecture Structure of write_back is
	
	component mem_wb_reg is
	port (-- buses
			read_data_in	:	in 	std_logic_vector(31 downto 0);	
			read_data_out	:	out 	std_logic_vector(31 downto 0);	
			bypass_mem_in	:	in 	std_logic_vector(31 downto 0);	
			bypass_mem_out	:	out 	std_logic_vector(31 downto 0);
			addr_regw_in	:	in		std_logic_vector(4 downto 0);	
			addr_regw_out	:	out 	std_logic_vector(4 downto 0);	
			-- control signals
			RegWrite_in		:	in 	std_logic;
			RegWrite_out	:	out 	std_logic;
			MemtoReg_in		:	in		std_logic;	
			MemtoReg_out	:	out 	std_logic;
			-- register control signals
			enable			:	in 	std_logic;
			clk				:	in 	std_logic);
	end component;

	signal read_data_reg	:	std_logic_vector(31 downto 0);	
	signal bypass_mem_reg:	std_logic_vector(31 downto 0);
	signal addr_regw_reg	:	std_logic_vector(4 downto 0);		
	signal RegWrite_reg	:	std_logic;
	signal MemtoReg_reg	:	std_logic;	
	
begin
	
	-- MEM/WB Register 
	MEM_WB_register : mem_wb_reg
	port map(read_data_in	=> read_data,
				read_data_out	=> read_data_reg,
				bypass_mem_in	=> bypass_mem,
				bypass_mem_out	=> bypass_mem_reg,
				addr_regw_in	=> addr_regw_in,
				addr_regw_out	=> addr_regw_reg,
				RegWrite_in		=> RegWrite_in,
				RegWrite_out	=> RegWrite_reg,
				MemtoReg_in		=> MemtoReg,
				MemtoReg_out	=> MemtoReg_reg,
				enable			=> '1',
				clk				=> clk);


	addr_regw_out 	<=	addr_regw_reg;
	
	RegWrite_out	<= RegWrite_reg;
	
		
	write_data 		<= bypass_mem_reg when MemtoReg_reg = '0' else
							read_data_reg;
		
end Structure;