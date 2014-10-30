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
			Stall				:	out std_logic); 
end hazard_ctrl;

architecture Structure of hazard_ctrl is
begin

	Stall <= '1' when (Branch = '1' or 
	                   Jump = '1' or 
	                   (exeMemRead = '1' and (exeRegisterRt = idRegisterRs or exeRegisterRt = idRegisterRt) and not idMemWrite = '1')
	                   ) else
				'0';
				
end Structure;