library ieee;
use ieee.std_logic_1164.all;


entity hazard_ctrl is
	port (idRegisterRs	: 	in std_logic_vector(4 downto 0);  --consumidor
			idRegisterRt	:	in	std_logic_vector(4 downto 0);  --consumidor
			exeRegisterRt	:	in	std_logic_vector(4 downto 0);  --productor
			idMemWrite  	: 	in std_logic;
			exeMemRead		:	in std_logic;
			Branch_2			:	in	std_logic;
      Branch_3			:	in	std_logic;
      Branch_4   : in std_logic;
			Jump_2				:	in	std_logic;
			Jump_3    : in std_logic;
			Jump_4    : in std_logic;
			
			-- control signals
			Stall : 	out std_logic;
			clk	:	in	std_logic;
			boot	:	in	std_logic);
end hazard_ctrl;

architecture Structure of hazard_ctrl is
  	-- Internal for branches and jumps
	signal Branch_tmp			:	std_logic;
	signal Jump_tmp     : std_logic;
	 -- Register for avoiding feedback loop
	signal Stall_tmp : std_logic;
begin
  
  Branch_tmp <= '0' when (Branch_2='1' and Branch_3='1' and Branch_4='1') else
                '1' when (Branch_2='1') else
                '0';
                
  Jump_tmp <= '0' when (Jump_2='1' and Jump_3='1' and Jump_4='1') else
              '1' when (Jump_2='1') else
              '0';
              
  Stall_tmp  <= '1' when (Branch_tmp = '1' or 
	                Jump_tmp = '1' or
	                 --- FIXME: if it is the zero register, should it be tested in addition to the other comparisons?
   	             (exeMemRead = '1' and (exeRegisterRt = idRegisterRs or exeRegisterRt = idRegisterRt) and not idMemWrite = '1'))
 	               else
				       '0';

	stall_register : process(clk)
	begin			
    if (falling_edge(clk)) then
      Stall <= Stall_tmp;
    end if;
  end process;

end Structure;