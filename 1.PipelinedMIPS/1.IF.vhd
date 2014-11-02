library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity instruction_fetch is
	port (-- buses
			addr_jump		:	in	std_logic_vector(31 downto 0);	--from MEM
			addr_branch		:	in	std_logic_vector(31 downto 0); 	--from MEM
			pc_up				:	out std_logic_vector(31 downto 0);  --to stage ID
			instruction		: 	out std_logic_vector(31 downto 0);	--to stage ID
			-- control signals
			clk				:	in std_logic;
			boot				:	in std_logic;
			Jump				:	in std_logic;								--from MEM
			PCSrc				:	in std_logic;								--from MEM
			Stall				:	in std_logic); 		
			
end instruction_fetch;

architecture Structure of instruction_fetch is
	
	component reg_pc is
	port (pc_up	:	in	std_logic_vector(31 downto 0);
			pc 	:	out std_logic_vector(31 downto 0);
			Stall : 	in std_logic;
			clk	:	in	std_logic;
			boot	:	in	std_logic);
	end component;
	
	component inst_mem is
	port (addr			:	in std_logic_vector(31 downto 0);
			instruction	:	out std_logic_vector(31 downto 0);
			clk			:	in std_logic;
			boot			:	in std_logic);
	end component;
	
	signal first_mux_res : std_logic_vector(31 downto 0);
	signal pc_up_tmp		:	std_logic_vector(31 downto 0);
	signal pc_up_tmp2		:	std_logic_vector(31 downto 0);
	signal pc_tmp			:	std_logic_vector(31 downto 0);
	
	signal Jump_tmp  : std_logic;
begin
	Jump_tmp			<= Jump when boot = '0' else
							'0';

	first_mux_res 	<= addr_branch 	when PCSrc = '1' else
							pc_up_tmp2;
		
	pc_up_tmp	<= first_mux_res when Jump_tmp = '0' else
						addr_jump;
	
	program_counter	:	reg_pc
	port map(pc_up	=>	pc_up_tmp,
				pc		=> pc_tmp,
				Stall	=> Stall,
				clk	=> clk,
				boot	=> boot);
				
		
	pc_up_tmp2 <= pc_tmp + x"00000004";
	
	instruction_memory	:	inst_mem
	port map(addr 			=> pc_tmp,
				instruction => instruction,
				clk			=> clk,
				boot			=> boot);
	
	pc_up <= pc_up_tmp2;
	
end Structure;