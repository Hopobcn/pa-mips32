library ieee;
use ieee.std_logic_1164.all;

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
			PCSrc				:	in std_logic);								--from MEM
	
end instruction_fetch;

architecture Structure of instruction_fetch is

	component mux is
	port (a	:	in	std_logic_vector(31 downto 0);
			b	:	in std_logic_vector(31 downto 0);
			c	:	out std_logic_vector(31 downto 0);
			s	:	in	std_logic);
	end component;
	
	component adder is
	port (pc		: 	in	std_logic_vector(31 downto 0);
			four	:	in	std_logic_vector(2 downto 0);
			pc_up	:	out std_logic_vector(31 downto 0));
	end component;
	
	component reg_pc is
	port (clk	:	in	std_logic;
			pc_up	:	in	std_logic_vector(31 downto 0);
			pc 	:	out std_logic_vector(31 downto 0));
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
begin

	mux_pc_or_branch	:	mux
	port map(a	=> pc_up_tmp2,
				b	=>	addr_branch,
				c	=> first_mux_res,
				s	=> PCSrc);
			
	mux_mux_or_jump	:	mux
	port map(a	=> first_mux_res,
				b	=>	addr_jump,
				c	=> pc_up_tmp,
				s	=> Jump);
	
	program_counter	:	reg_pc
	port map(clk	=> clk,
				pc_up	=>	pc_up_tmp,
				pc		=> pc_tmp);
				
	increment_pc_unit	:	adder
	port map(pc		=> pc_tmp,
				four	=> "100",
				pc_up => pc_up_tmp2);
				
	instruction_memory	:	inst_mem
	port map(addr 			=> pc_tmp,
				instruction => instruction,
				clk			=> clk,
				boot			=> boot);
	
	pc_up <= pc_up_tmp2; --comprovar que sigui correcte
	
end Structure;