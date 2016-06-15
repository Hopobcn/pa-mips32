library ieee;
use ieee.std_logic_1164.all;

entity reg_pc is
	port (-- buses
			pc_up	:	in	std_logic_vector(31 downto 0);
			pc 	:	out std_logic_vector(31 downto 0);
			-- control signals
			Stall : 	in std_logic;
			clk	:	in	std_logic;
			boot	:	in	std_logic);
end reg_pc;

architecture Structure of reg_pc is
   type tipusestat is (BOOT_STATE, STALL_STATE, NORMAL_STATE);
	signal estat : tipusestat := BOOT_STATE;
	
	signal pc_tmp		: std_logic_vector(31 downto 0);
begin

   prox_estat : process(clk)
	begin
		if(rising_edge(clk)) then
			case estat is
				when BOOT_STATE =>
					if boot = '1' then
						estat <= BOOT_STATE;
					elsif Stall = '1' then
						estat <= STALL_STATE;
					else 
						estat <= NORMAL_STATE;
					end if;
				when STALL_STATE =>
					if boot = '1' then
						estat <= BOOT_STATE;
					elsif Stall = '1' then
						estat <= STALL_STATE;
					else 
						estat <= NORMAL_STATE;
					end if;
				when NORMAL_STATE =>
					if boot = '1' then
						estat <= BOOT_STATE;
					elsif Stall = '1' then
						estat <= STALL_STATE;
					else 
						estat <= NORMAL_STATE;
					end if;
			end case;
		end if;
	end process prox_estat;
	
	logica_sortida : process(clk)
	begin
		if(rising_edge(clk)) then
			case estat is
				when BOOT_STATE =>
					pc <=  x"00000000";
				when STALL_STATE =>
				   ---pc <= pc;
					null;
				when NORMAL_STATE =>
				   pc <= pc_up;
			end case;
		end if;
	end process logica_sortida;
	
--	pc <= pc_tmp;
--	
--	instruction_register : process(clk, pc_tmp)
--	begin
--		if (rising_edge(clk)) then
--			if (boot = '1') then
--				pc_tmp <= x"00000000";
--			elsif (Stall = '1') then
--				pc_tmp <= pc_tmp;
--			else
--				pc_tmp <= pc_up;
--			end if;
--		end if;
--	end process;
end Structure;
