library ieee;
use ieee.std_logic_1164.all;


entity hazard_ctrl is
	port (idRegisterRs	: 	in std_logic_vector(4 downto 0);  --consumidor
			idRegisterRt	:	in	std_logic_vector(4 downto 0);  --consumidor
			exeRegisterRt	:	in	std_logic_vector(4 downto 0);  --productor (load)
			exeMemRead		:	in std_logic;
			Branch		   :	in	std_logic;                     -- from MEM stage (1=branch taken)
			Jump			   :	in	std_logic;							 -- from EXE stage
			Exception		:  in std_logic;							 -- from Exception Ctrl (MEM stage) --wait until instruction is the oldest ``alive''
			Interrupt		:  in std_logic;                     -- from Interrupt Ctrl (any point)
			IC_Ready       :  in std_logic;                     -- from IF (means Instruction Cache Ready (1 when hit) if 0 stall)
			DC_Ready       :  in std_logic;                     -- from MEM (means Data Cache Ready (1 when hit)
			-- control signals
			Stall_PC 		: out std_logic;
			Stall_IF_ID 	: out std_logic;
			Stall_ID_EXE	: out std_logic;
			Stall_EXE_MEM	: out std_logic;
			NOP_to_ID 		: out std_logic;
			NOP_to_EXE		: out std_logic;
			NOP_to_MEM		: out std_logic;
			NOP_to_WB		: out std_logic);
end hazard_ctrl;

architecture Structure of hazard_ctrl is
	
begin
                
  
				       
	stall_logic : process(idRegisterRs,idRegisterRt,exeRegisterRt,exeMemRead,Branch,Jump,Exception,Interrupt,IC_Ready,DC_Ready)
	begin
		Stall_PC 		<= '0';
		Stall_IF_ID 	<= '0';
		Stall_ID_EXE	<= '0';
		Stall_EXE_MEM	<= '0';
		NOP_to_ID 		<= '0';
		NOP_to_EXE		<= '0';
		NOP_to_MEM		<= '0';
		NOP_to_WB		<= '0';
		if (Interrupt = '1') then
			NOP_to_ID 		<= '1';
			NOP_to_EXE		<= '1';
			NOP_to_MEM		<= '1';
			NOP_to_WB		<= '1';
		elsif (Exception = '1') then
		  NOP_to_ID 		<= '1';
			NOP_to_EXE		<= '1';
			NOP_to_MEM		<= '1';
			--NOP_to_WB		<= '1'; --do not clear the memory stage
			-- because the memory stage is the one with the exception
	  elsif (not DC_Ready = '1') then
			Stall_PC 		<= '1';
			Stall_IF_ID 	<= '1';
			Stall_ID_EXE	<= '1';
			Stall_EXE_MEM	<= '1';
			NOP_to_WB		<= '0';
		elsif (Branch = '1') then 
			NOP_to_ID 		<= '1';
			NOP_to_EXE		<= '1';
			NOP_to_MEM		<= '1';
		elsif (Jump = '1') then
			NOP_to_ID 	<= '1';
			NOP_to_EXE 	<= '1';
		elsif ((idRegisterRs = exeRegisterRt or idRegisterRt = exeRegisterRt) and exeMemRead = '1') then
			Stall_PC		<= '1';
			Stall_IF_ID <= '1';
			NOP_to_EXE 	<= '1';
		elsif (not IC_Ready = '1') then
			Stall_PC 	<= '1';
			NOP_to_ID 	<= '1';
		end if;
  end process;

end Structure;