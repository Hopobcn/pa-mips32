library ieee;
use ieee.std_logic_1164.all;


entity hazard_ctrl is
	port (idRegisterRs	: 	in std_logic_vector(4 downto 0);  --consumidor
			idRegisterRt	:	in	std_logic_vector(4 downto 0);  --consumidor
			exeRegisterRt	:	in	std_logic_vector(4 downto 0);  --productor
			idMemWrite  	: 	in std_logic;
			exeMemRead		:	in std_logic;
			Branch			:	in	std_logic;
			Jump				:	in	std_logic;
			
			-- control signals
			Stall : 	out std_logic;
			clk	:	in	std_logic;
			boot	:	in	std_logic);
end hazard_ctrl;

architecture Structure of hazard_ctrl is
	 -- Register for avoiding feedback loop
	signal Stall_tmp : std_logic;
	signal Stall_machine_branch : std_logic_vector(1 downto 0);
	signal Stall_machine_jump   : std_logic;
	
	signal Stall_by_branch : std_logic;
	signal Stall_by_jump   : std_logic;
begin
                
  Stall_tmp  <= '1' when --- FIXME: if it is the zero register, should it be tested in addition to the other comparisons?
   	             (exeMemRead = '1' and (exeRegisterRt = idRegisterRs or exeRegisterRt = idRegisterRt) and not idMemWrite = '1')
 	               else
				       '0';
  Stall_by_branch <= Stall_machine_branch(0) or Stall_machine_branch(1);
  Stall_by_jump   <= Stall_machine_jump;
				       
	stall_register : process(clk)
	begin			
    if (falling_edge(clk)) then
      Stall <= Stall_tmp or Stall_by_branch or Stall_by_jump;
      Stall_machine_branch <= Stall_machine_branch(0) & Branch;
      Stall_machine_jump <= Jump;
    end if;
    if (rising_edge(clk)) then
      Stall <= Stall_by_branch or Stall_by_jump;
    end if;
  end process;

end Structure;