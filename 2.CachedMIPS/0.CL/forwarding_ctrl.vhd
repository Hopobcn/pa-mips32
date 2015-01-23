library ieee;
use ieee.std_logic_1164.all;


entity forwarding_ctrl is
    port (idRegisterRs      : in  std_logic_vector(5 downto 0);  --consumer
          idRegisterRt      : in  std_logic_vector(5 downto 0);  --consumer
          exeRegisterRd     : in  std_logic_vector(5 downto 0);  --producer
          exeRegisterRt     : in  std_logic_vector(5 downto 0);  --producer
          tagRegisterRd     : in  std_logic_vector(5 downto 0);  --producer "tag -> LOOKUP stage"
			 dcaRegisterRd     : in  std_logic_vector(5 downto 0);  --producer "dca == data cache -> CACHE stage"
          exeRegWrite       : in  std_logic;
          tagRegWrite       : in  std_logic;
			 dcaRegWrite       : in  std_logic;
          idMemWrite        : in  std_logic;
          exeMemWrite       : in  std_logic;
          fwd_aluRs         : out std_logic_vector(1 downto 0);
          fwd_aluRt         : out std_logic_vector(1 downto 0);
          fwd_alu_regmem    : out std_logic_vector(1 downto 0);
          fwd_lookup_regmem : out std_logic;
			 fwd_cache_regmem  : out std_logic); 
end forwarding_ctrl;

architecture Structure of forwarding_ctrl is
begin

    fwd_aluRs <= "11" when (         exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRs ) else  -- fwd from ALU to ID 
                 "10" when (         tagRegWrite = '1' and tagRegisterRd /= "000000" and tagRegisterRd = idRegisterRs
                            and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRs)) else  -- fwd from LOOKUP to ID 
                 "01" when (         dcaRegWrite = '1' and dcaRegisterRd /= "000000" and dcaRegisterRd = idRegisterRs
					             and not (tagRegWrite = '1' and tagRegisterRd /= "000000" and tagRegisterRd = idRegisterRs)
                            and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRs)) else  -- fwd from CACHE to ID 
                 "00";                                                                                                       -- (don't fwd) typical path 
    
    fwd_aluRt <= "11" when (         exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt ) else  -- fwd from ALU to ID 
                 "10" when (         tagRegWrite = '1' and tagRegisterRd /= "000000" and tagRegisterRd = idRegisterRt         -- fwd from LOOKUP to ID 
                            and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt)) else  -- priority for newest value(alu)
                 "01" when (         dcaRegWrite = '1' and dcaRegisterRd /= "000000" and dcaRegisterRd = idRegisterRt
					             and not (tagRegWrite = '1' and tagRegisterRd /= "000000" and tagRegisterRd = idRegisterRt)
                            and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt)) else  -- fwd from CACHE to ID 
                 "00";                                                                                                       -- (don't fwd) typical path
    
    fwd_alu_regmem <= "11" when (         exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt and idMemWrite = '1')  else -- fwd from ALU to ID (ALU-STORE)
                      "10" when (         tagRegWrite = '1' and tagRegisterRd /= "000000" and tagRegisterRd = idRegisterRt and idMemWrite = '1'        
                                 and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt and idMemWrite = '1')) else -- fwd from MEM to ID (ALU-STORE from LOOKUP)
                      "01" when (         dcaRegWrite = '1' and dcaRegisterRd /= "000000" and dcaRegisterRd = idRegisterRt and idMemWrite = '1'
					                  and not (tagRegWrite = '1' and tagRegisterRd /= "000000" and tagRegisterRd = idRegisterRt and idMemWrite = '1')
                                 and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt and idMemWrite = '1')) else  -- fwd from CACHE to ID (LOAD-STORE)
                      "00";
                            
    fwd_lookup_regmem <= '1' when (tagRegWrite = '1' and tagRegisterRd /= "000000" and tagRegisterRd = exeRegisterRt and exeMemWrite = '1') else -- PRODUCER(LOOKUP)-CONSUMER(ALU)in next cycle
                         '0';
    fwd_cache_regmem  <= '1' when (dcaRegWrite = '1' and dcaRegisterRd /= "000000" and dcaRegisterRd = exeRegisterRt and exeMemWrite = '1') else -- PRODUCER(CACHE)-CONSUMER(ALU)
                         '0';    
end Structure;
