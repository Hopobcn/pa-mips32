library ieee;
use ieee.std_logic_1164.all;


entity forwarding_ctrl is
	port (idRegisterRs	: 	in std_logic_vector(5 downto 0);  --consumidor
			idRegisterRt 	:	in	std_logic_vector(5 downto 0);  --consumidor
			exeRegisterRd	:	in	std_logic_vector(5 downto 0);  --productor
			exeRegisterRt	:	in	std_logic_vector(5 downto 0);
			memRegisterRd	: 	in std_logic_vector(5 downto 0);  --productor
			exeRegWrite		:	in std_logic;
			memRegWrite		:	in	std_logic;
			idMemWrite		:	in std_logic;
			exeMemWrite		:	in	std_logic;
			fwd_aluRs		:	out std_logic_vector(1 downto 0);
			fwd_aluRt		:	out std_logic_vector(1 downto 0);
			fwd_alu_regmem	: 	out std_logic_vector(1 downto 0);
			fwd_mem_regmem	:	out std_logic); 
end forwarding_ctrl;

architecture Structure of forwarding_ctrl is
begin

	fwd_aluRs <= "11" when (			exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRs ) else 	-- fwd from ALU to ID 
					 "10" when (			memRegWrite = '1' and memRegisterRd /= "000000" and memRegisterRd = idRegisterRs
									and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRs)) else	-- fwd from MEM to ID 
					 "00";																																	-- (don't fwd) typical path 
	
	fwd_aluRt <= "11" when (			exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt ) else	-- fwd from ALU to ID 
					 "10" when (			memRegWrite = '1' and memRegisterRd /= "000000" and memRegisterRd = idRegisterRt			-- fwd from MEM to ID 
									and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt)) else 	-- priority for newest value(alu)
					 "00";																																	-- (don't fwd) typical path
	
	fwd_alu_regmem <= "11" when (			 exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt and idMemWrite = '1') else -- fwd from ALU to ID (ALU-STORE)
							"10" when (			 memRegWrite = '1' and memRegisterRd /= "000000" and memRegisterRd = idRegisterRt and idMemWrite = '1'			-- fwd from MEM to ID (LOAD-STORE)
										  and not(exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt and idMemWrite = '1')) else-- priority for newest value(alu) not mem
							"00";
							
	fwd_mem_regmem <= '1' when (memRegWrite = '1' and memRegisterRd /= "000000" and memRegisterRd = exeRegisterRt and exeMemWrite = '1') else -- PRODUCER(MEM)-CONSUMER(MEM)in next cycle
							'0';
	
end Structure;