library ieee;
use ieee.std_logic_1164.all;


entity forwarding_ctrl is
    port (idRegisterRs      : in  std_logic_vector(5 downto 0);  --consumer
          idRegisterRt      : in  std_logic_vector(5 downto 0);  --consumer
          exeRegisterRd     : in  std_logic_vector(5 downto 0);  --producer
          exeRegisterRt     : in  std_logic_vector(5 downto 0);  --producer
          tagRegisterRd     : in  std_logic_vector(5 downto 0);  --producer "tag -> LOOKUP stage"
			 dcaRegisterRd     : in  std_logic_vector(5 downto 0);  --producer "dca == data cache -> CACHE stage"
          robRegisterRd0    : in  std_logic_vector(5 downto 0);  --producer ROB entrada 0 
          robRegisterRd1    : in  std_logic_vector(5 downto 0);  --producer ROB entrada 1 
          robRegisterRd2    : in  std_logic_vector(5 downto 0);  --producer ROB entrada 2 
          robRegisterRd3    : in  std_logic_vector(5 downto 0);  --producer ROB entrada 3 
          robRegisterRd4    : in  std_logic_vector(5 downto 0);  --producer ROB entrada 4 
          robRegisterRd5    : in  std_logic_vector(5 downto 0);  --producer ROB entrada 5 
          robRegisterRd6    : in  std_logic_vector(5 downto 0);  --producer ROB entrada 6 
          robRegisterRd7    : in  std_logic_vector(5 downto 0);  --producer ROB entrada 7 
			 robMatchIdRs_out  : out std_logic_vector(2 downto 0);
			 robMatchIdRt_out  : out std_logic_vector(2 downto 0);
			 robMatchIdRt_mem_out : out std_logic_vector(2 downto 0);
          exeRegWrite       : in  std_logic;
          tagRegWrite       : in  std_logic;
			 dcaRegWrite       : in  std_logic;
			 robRegWrite0      : in  std_logic;
			 robRegWrite1      : in  std_logic;
			 robRegWrite2      : in  std_logic;
			 robRegWrite3      : in  std_logic;
			 robRegWrite4      : in  std_logic;
			 robRegWrite5      : in  std_logic;
			 robRegWrite6      : in  std_logic;
			 robRegWrite7      : in  std_logic;
          idMemWrite        : in  std_logic;
          exeMemWrite       : in  std_logic;
			 FreeSlotL         : in  std_logic; -- If NO instruction is in L stage don't forward from that 
			 FreeSlotC         : in  std_logic; -- If NO instruction is in C stage don't forward from that
          robTail           : in  std_logic_vector(2 downto 0);
          fwd_aluRs         : out std_logic_vector(2 downto 0);
          fwd_aluRt         : out std_logic_vector(2 downto 0);
          fwd_alu_regmem    : out std_logic_vector(2 downto 0);
          fwd_lookup_regmem : out std_logic;
			 fwd_cache_regmem  : out std_logic); 
end forwarding_ctrl;

architecture Structure of forwarding_ctrl is 
	 signal robRegisterRdRs : std_logic_vector(5 downto 0); --The youngest producer in ROB for Rs register
    signal robMatchIdRs     : std_logic_vector(2 downto 0); --Position in ROB of mach for Rs
	 signal robMatch0Rs      : std_logic;
	 signal robMatch1Rs      : std_logic;
	 signal robMatch2Rs      : std_logic;
	 signal robMatch3Rs      : std_logic;
	 signal robMatch4Rs      : std_logic;
	 signal robMatch5Rs      : std_logic;
	 signal robMatch6Rs      : std_logic;
	 signal robMatch7Rs      : std_logic;
	 signal robMatchRs       : std_logic; 
	 
	 signal robRegisterRdRt : std_logic_vector(5 downto 0); --The youngest producer in ROB for Rt register
    signal robMatchIdRt     : std_logic_vector(2 downto 0); --Position in ROB of mach for Rt 
	 signal robMatch0Rt     : std_logic;
	 signal robMatch1Rt     : std_logic;
	 signal robMatch2Rt     : std_logic;
	 signal robMatch3Rt     : std_logic;
	 signal robMatch4Rt     : std_logic;
	 signal robMatch5Rt     : std_logic;
	 signal robMatch6Rt     : std_logic;
	 signal robMatch7Rt     : std_logic;
	 signal robMatchRt       : std_logic; 
	 
	 signal robRegisterRdRt_mem : std_logic_vector(5 downto 0); --The youngest producer in ROB for Rt register that writes in mem (Store)
    signal robMatchIdRt_mem : std_logic_vector(2 downto 0); --Position in ROB of mach for Rt and is an Store
	 signal robMatch0Rt_mem : std_logic;
	 signal robMatch1Rt_mem : std_logic;
	 signal robMatch2Rt_mem : std_logic;
	 signal robMatch3Rt_mem : std_logic;
	 signal robMatch4Rt_mem : std_logic;
	 signal robMatch5Rt_mem : std_logic;
	 signal robMatch6Rt_mem : std_logic;
	 signal robMatch7Rt_mem : std_logic;
	 signal robMatchRt_mem   : std_logic; 
begin

    robMatch0Rs <= '1' when (robRegWrite0 = '1' and robRegisterRd0 /= "000000" and robRegisterRd0 = idRegisterRs) else
	                '0';
    robMatch1Rs <= '1' when (robRegWrite1 = '1' and robRegisterRd1 /= "000000" and robRegisterRd1 = idRegisterRs) else
	                '0';
    robMatch2Rs <= '1' when (robRegWrite2 = '1' and robRegisterRd2 /= "000000" and robRegisterRd2 = idRegisterRs) else
	                '0';
    robMatch3Rs <= '1' when (robRegWrite3 = '1' and robRegisterRd3 /= "000000" and robRegisterRd3 = idRegisterRs) else
	                '0';
    robMatch4Rs <= '1' when (robRegWrite4 = '1' and robRegisterRd4 /= "000000" and robRegisterRd4 = idRegisterRs) else
	                '0';
    robMatch5Rs <= '1' when (robRegWrite5 = '1' and robRegisterRd5 /= "000000" and robRegisterRd5 = idRegisterRs) else
	                '0';
    robMatch6Rs <= '1' when (robRegWrite6 = '1' and robRegisterRd6 /= "000000" and robRegisterRd6 = idRegisterRs) else
	                '0';
    robMatch7Rs <= '1' when (robRegWrite7 = '1' and robRegisterRd7 /= "000000" and robRegisterRd7 = idRegisterRs) else
	                '0';
	 robMatchRs  <= '1' when (robMatch0Rs or robMatch1Rs or robMatch2Rs or robMatch3Rs or robMatch4Rs or robMatch5Rs or robMatch6Rs or robMatch7Rs) = '1' else
	                '0';
	 
    robMatch0Rt <= '1' when (robRegWrite0 = '1' and robRegisterRd0 /= "000000" and robRegisterRd0 = idRegisterRt) else
	                '0';
    robMatch1Rt <= '1' when (robRegWrite1 = '1' and robRegisterRd1 /= "000000" and robRegisterRd1 = idRegisterRt) else
	                '0';
    robMatch2Rt <= '1' when (robRegWrite2 = '1' and robRegisterRd2 /= "000000" and robRegisterRd2 = idRegisterRt) else
	                '0';
    robMatch3Rt <= '1' when (robRegWrite3 = '1' and robRegisterRd3 /= "000000" and robRegisterRd3 = idRegisterRt) else
	                '0';
    robMatch4Rt <= '1' when (robRegWrite4 = '1' and robRegisterRd4 /= "000000" and robRegisterRd4 = idRegisterRt) else
	                '0';
    robMatch5Rt <= '1' when (robRegWrite5 = '1' and robRegisterRd5 /= "000000" and robRegisterRd5 = idRegisterRt) else
	                '0';
    robMatch6Rt <= '1' when (robRegWrite6 = '1' and robRegisterRd6 /= "000000" and robRegisterRd6 = idRegisterRt) else
	                '0';
    robMatch7Rt <= '1' when (robRegWrite7 = '1' and robRegisterRd7 /= "000000" and robRegisterRd7 = idRegisterRt) else
	                '0';
	 robMatchRt  <= '1' when (robMatch0Rt or robMatch1Rt or robMatch2Rt or robMatch3Rt or robMatch4Rt or robMatch5Rt or robMatch6Rt or robMatch7Rt) = '1' else
	                '0';
	 
    robMatch0Rt_mem <= '1' when (robRegWrite0 = '1' and robRegisterRd0 /= "000000" and robRegisterRd0 = idRegisterRt and idMemWrite = '1') else
	                    '0';
    robMatch1Rt_mem <= '1' when (robRegWrite1 = '1' and robRegisterRd1 /= "000000" and robRegisterRd1 = idRegisterRt and idMemWrite = '1') else
	                    '0';
    robMatch2Rt_mem <= '1' when (robRegWrite2 = '1' and robRegisterRd2 /= "000000" and robRegisterRd2 = idRegisterRt and idMemWrite = '1') else
	                    '0';
    robMatch3Rt_mem <= '1' when (robRegWrite3 = '1' and robRegisterRd3 /= "000000" and robRegisterRd3 = idRegisterRt and idMemWrite = '1') else
	                    '0';
    robMatch4Rt_mem <= '1' when (robRegWrite4 = '1' and robRegisterRd4 /= "000000" and robRegisterRd4 = idRegisterRt and idMemWrite = '1') else
	                    '0';
    robMatch5Rt_mem <= '1' when (robRegWrite5 = '1' and robRegisterRd5 /= "000000" and robRegisterRd5 = idRegisterRt and idMemWrite = '1') else
	                    '0';
    robMatch6Rt_mem <= '1' when (robRegWrite6 = '1' and robRegisterRd6 /= "000000" and robRegisterRd6 = idRegisterRt and idMemWrite = '1') else
	                    '0';
    robMatch7Rt_mem <= '1' when (robRegWrite7 = '1' and robRegisterRd7 /= "000000" and robRegisterRd7 = idRegisterRt and idMemWrite = '1') else
	                    '0';
	 robMatchRt_mem  <= '1' when (robMatch0Rt_mem or robMatch1Rt_mem or robMatch2Rt_mem or robMatch3Rt_mem or robMatch4Rt_mem or robMatch5Rt_mem or robMatch6Rt_mem or robMatch7Rt_mem) = '1' else
	                    '0';
	 
    robMatchIdRs <= "000" when (robMatch0Rs = '1' and (  (robTail = "000") 
                                                      or (robTail = "111" and  robMatch7Rs = '0')
                                                      or (robTail = "110" and (robMatch7Rs and robMatch6Rs) = '0') 
                                                      or (robTail = "101" and (robMatch7Rs and robMatch6Rs and robMatch5Rs) = '0')
                                                      or (robTail = "100" and (robMatch7Rs and robMatch6Rs and robMatch5Rs and robMatch4Rs) = '0') 
                                                      or (robTail = "011" and (robMatch7Rs and robMatch6Rs and robMatch5Rs and robMatch4Rs and robMatch3Rs) = '0') 
                                                      or (robTail = "010" and (robMatch7Rs and robMatch6Rs and robMatch5Rs and robMatch4Rs and robMatch3Rs and robMatch2Rs) = '0') 
                                                      or (robTail = "001" and (robMatch7Rs and robMatch6Rs and robMatch5Rs and robMatch4Rs and robMatch3Rs and robMatch2Rs and robMatch1Rs) = '0'))) else 
						 "001" when (robMatch1Rs = '1' and (   (robTail = "001") 
                                                      or (robTail = "000" and  robMatch0Rs = '0')
                                                      or (robTail = "111" and (robMatch0Rs and robMatch7Rs) = '0')
                                                      or (robTail = "110" and (robMatch0Rs and robMatch7Rs and robMatch6Rs) = '0') 
                                                      or (robTail = "101" and (robMatch0Rs and robMatch7Rs and robMatch6Rs and robMatch5Rs) = '0')
                                                      or (robTail = "100" and (robMatch0Rs and robMatch7Rs and robMatch6Rs and robMatch5Rs and robMatch4Rs) = '0') 
                                                      or (robTail = "011" and (robMatch0Rs and robMatch7Rs and robMatch6Rs and robMatch5Rs and robMatch4Rs and robMatch3Rs) = '0') 
                                                      or (robTail = "010" and (robMatch0Rs and robMatch7Rs and robMatch6Rs and robMatch5Rs and robMatch4Rs and robMatch3Rs and robMatch2Rs) = '0'))) else 
						 "010" when (robMatch2Rs = '1' and (   (robTail = "010")
                                                      or (robTail = "001" and  robMatch1Rs = '0') 
                                                      or (robTail = "000" and (robMatch1Rs and robMatch0Rs) = '0')
                                                      or (robTail = "111" and (robMatch1Rs and robMatch0Rs and robMatch7Rs) = '0')
                                                      or (robTail = "110" and (robMatch1Rs and robMatch0Rs and robMatch7Rs and robMatch6Rs) = '0') 
                                                      or (robTail = "101" and (robMatch1Rs and robMatch0Rs and robMatch7Rs and robMatch6Rs and robMatch5Rs) = '0')
                                                      or (robTail = "100" and (robMatch1Rs and robMatch0Rs and robMatch7Rs and robMatch6Rs and robMatch5Rs and robMatch4Rs) = '0') 
                                                      or (robTail = "011" and (robMatch1Rs and robMatch0Rs and robMatch7Rs and robMatch6Rs and robMatch5Rs and robMatch4Rs and robMatch3Rs) = '0'))) else
						 "011" when (robMatch3Rs = '1' and (   (robTail = "011")
                                                      or (robTail = "010" and  robMatch2Rs = '0')
                                                      or (robTail = "001" and (robMatch2Rs and robMatch1Rs) = '0') 
                                                      or (robTail = "000" and (robMatch2Rs and robMatch1Rs and robMatch0Rs) = '0')
                                                      or (robTail = "111" and (robMatch2Rs and robMatch1Rs and robMatch0Rs and robMatch7Rs) = '0')
                                                      or (robTail = "110" and (robMatch2Rs and robMatch1Rs and robMatch0Rs and robMatch7Rs and robMatch6Rs) = '0') 
                                                      or (robTail = "101" and (robMatch2Rs and robMatch1Rs and robMatch0Rs and robMatch7Rs and robMatch6Rs and robMatch5Rs) = '0')
                                                      or (robTail = "100" and (robMatch2Rs and robMatch1Rs and robMatch0Rs and robMatch7Rs and robMatch6Rs and robMatch5Rs and robMatch4Rs) = '0'))) else
						 "100" when (robMatch4Rs = '1' and (   (robTail = "100")
                                                      or (robTail = "011" and  robMatch3Rs = '0')
                                                      or (robTail = "010" and (robMatch3Rs and robMatch2Rs) = '0')
                                                      or (robTail = "001" and (robMatch3Rs and robMatch2Rs and robMatch1Rs) = '0') 
                                                      or (robTail = "000" and (robMatch3Rs and robMatch2Rs and robMatch1Rs and robMatch0Rs) = '0')
                                                      or (robTail = "111" and (robMatch3Rs and robMatch2Rs and robMatch1Rs and robMatch0Rs and robMatch7Rs) = '0')
                                                      or (robTail = "110" and (robMatch3Rs and robMatch2Rs and robMatch1Rs and robMatch0Rs and robMatch7Rs and robMatch6Rs) = '0') 
                                                      or (robTail = "101" and (robMatch3Rs and robMatch2Rs and robMatch1Rs and robMatch0Rs and robMatch7Rs and robMatch6Rs and robMatch5Rs) = '0'))) else
						 "101" when (robMatch5Rs = '1' and (   (robTail = "101")
                                                      or (robTail = "100" and  robMatch4Rs = '0')
                                                      or (robTail = "011" and (robMatch4Rs and robMatch3Rs) = '0')
                                                      or (robTail = "010" and (robMatch4Rs and robMatch3Rs and robMatch2Rs) = '0')
                                                      or (robTail = "001" and (robMatch4Rs and robMatch3Rs and robMatch2Rs and robMatch1Rs) = '0') 
                                                      or (robTail = "000" and (robMatch4Rs and robMatch3Rs and robMatch2Rs and robMatch1Rs and robMatch0Rs) = '0')
                                                      or (robTail = "111" and (robMatch4Rs and robMatch3Rs and robMatch2Rs and robMatch1Rs and robMatch0Rs and robMatch7Rs) = '0')
                                                      or (robTail = "110" and (robMatch4Rs and robMatch3Rs and robMatch2Rs and robMatch1Rs and robMatch0Rs and robMatch7Rs and robMatch6Rs) = '0'))) else
						 "110" when (robMatch6Rs = '1' and (   (robTail = "110")
                                                      or (robTail = "101" and  robMatch5Rs = '0')
                                                      or (robTail = "100" and (robMatch5Rs and robMatch4Rs) = '0')
                                                      or (robTail = "011" and (robMatch5Rs and robMatch4Rs and robMatch3Rs) = '0')
                                                      or (robTail = "010" and (robMatch5Rs and robMatch4Rs and robMatch3Rs and robMatch2Rs) = '0')
                                                      or (robTail = "001" and (robMatch5Rs and robMatch4Rs and robMatch3Rs and robMatch2Rs and robMatch1Rs) = '0') 
                                                      or (robTail = "000" and (robMatch5Rs and robMatch4Rs and robMatch3Rs and robMatch2Rs and robMatch1Rs and robMatch0Rs) = '0')
                                                      or (robTail = "111" and (robMatch5Rs and robMatch4Rs and robMatch3Rs and robMatch2Rs and robMatch1Rs and robMatch0Rs and robMatch7Rs) = '0'))) else
						 "111" when (robMatch7Rs = '1' and (   (robTail = "111")
                                                      or (robTail = "110" and  robMatch6Rs = '0')
                                                      or (robTail = "101" and (robMatch6Rs and robMatch5Rs) = '0')
                                                      or (robTail = "100" and (robMatch6Rs and robMatch5Rs and robMatch4Rs) = '0')
                                                      or (robTail = "011" and (robMatch6Rs and robMatch5Rs and robMatch4Rs and robMatch3Rs) = '0')
                                                      or (robTail = "010" and (robMatch6Rs and robMatch5Rs and robMatch4Rs and robMatch3Rs and robMatch2Rs) = '0')
                                                      or (robTail = "001" and (robMatch6Rs and robMatch5Rs and robMatch4Rs and robMatch3Rs and robMatch2Rs and robMatch1Rs) = '0') 
                                                      or (robTail = "000" and (robMatch6Rs and robMatch5Rs and robMatch4Rs and robMatch3Rs and robMatch2Rs and robMatch1Rs and robMatch0Rs) = '0'))) else
						 "XXX"; -- error
	 
	 
    robMatchIdRt <= "000" when (robMatch0Rt = '1' and (   (robTail = "000") 
                                                      or (robTail = "111" and  robMatch7Rt = '0')
                                                      or (robTail = "110" and (robMatch7Rt and robMatch6Rt) = '0') 
                                                      or (robTail = "101" and (robMatch7Rt and robMatch6Rt and robMatch5Rt) = '0')
                                                      or (robTail = "100" and (robMatch7Rt and robMatch6Rt and robMatch5Rt and robMatch4Rt) = '0') 
                                                      or (robTail = "011" and (robMatch7Rt and robMatch6Rt and robMatch5Rt and robMatch4Rt and robMatch3Rt) = '0') 
                                                      or (robTail = "010" and (robMatch7Rt and robMatch6Rt and robMatch5Rt and robMatch4Rt and robMatch3Rt and robMatch2Rt) = '0') 
                                                      or (robTail = "001" and (robMatch7Rt and robMatch6Rt and robMatch5Rt and robMatch4Rt and robMatch3Rt and robMatch2Rt and robMatch1Rt) = '0'))) else 
						 "001" when (robMatch1Rt = '1' and (   (robTail = "001") 
                                                      or (robTail = "000" and  robMatch0Rt = '0')
                                                      or (robTail = "111" and (robMatch0Rt and robMatch7Rt) = '0')
                                                      or (robTail = "110" and (robMatch0Rt and robMatch7Rt and robMatch6Rt) = '0') 
                                                      or (robTail = "101" and (robMatch0Rt and robMatch7Rt and robMatch6Rt and robMatch5Rt) = '0')
                                                      or (robTail = "100" and (robMatch0Rt and robMatch7Rt and robMatch6Rt and robMatch5Rt and robMatch4Rt) = '0') 
                                                      or (robTail = "011" and (robMatch0Rt and robMatch7Rt and robMatch6Rt and robMatch5Rt and robMatch4Rt and robMatch3Rt) = '0') 
                                                      or (robTail = "010" and (robMatch0Rt and robMatch7Rt and robMatch6Rt and robMatch5Rt and robMatch4Rt and robMatch3Rt and robMatch2Rt) = '0'))) else 
						 "010" when (robMatch2Rt = '1' and (   (robTail = "010")
                                                      or (robTail = "001" and  robMatch1Rt = '0') 
                                                      or (robTail = "000" and (robMatch1Rt and robMatch0Rt) = '0')
                                                      or (robTail = "111" and (robMatch1Rt and robMatch0Rt and robMatch7Rt) = '0')
                                                      or (robTail = "110" and (robMatch1Rt and robMatch0Rt and robMatch7Rt and robMatch6Rt) = '0') 
                                                      or (robTail = "101" and (robMatch1Rt and robMatch0Rt and robMatch7Rt and robMatch6Rt and robMatch5Rt) = '0')
                                                      or (robTail = "100" and (robMatch1Rt and robMatch0Rt and robMatch7Rt and robMatch6Rt and robMatch5Rt and robMatch4Rt) = '0') 
                                                      or (robTail = "011" and (robMatch1Rt and robMatch0Rt and robMatch7Rt and robMatch6Rt and robMatch5Rt and robMatch4Rt and robMatch3Rt) = '0'))) else
						 "011" when (robMatch3Rt = '1' and (   (robTail = "011")
                                                      or (robTail = "010" and  robMatch2Rt = '0')
                                                      or (robTail = "001" and (robMatch2Rt and robMatch1Rt) = '0') 
                                                      or (robTail = "000" and (robMatch2Rt and robMatch1Rt and robMatch0Rt) = '0')
                                                      or (robTail = "111" and (robMatch2Rt and robMatch1Rt and robMatch0Rt and robMatch7Rt) = '0')
                                                      or (robTail = "110" and (robMatch2Rt and robMatch1Rt and robMatch0Rt and robMatch7Rt and robMatch6Rt) = '0') 
                                                      or (robTail = "101" and (robMatch2Rt and robMatch1Rt and robMatch0Rt and robMatch7Rt and robMatch6Rt and robMatch5Rt) = '0')
                                                      or (robTail = "100" and (robMatch2Rt and robMatch1Rt and robMatch0Rt and robMatch7Rt and robMatch6Rt and robMatch5Rt and robMatch4Rt) = '0'))) else
						 "100" when (robMatch4Rt = '1' and (   (robTail = "100")
                                                      or (robTail = "011" and  robMatch3Rt = '0')
                                                      or (robTail = "010" and (robMatch3Rt and robMatch2Rt) = '0')
                                                      or (robTail = "001" and (robMatch3Rt and robMatch2Rt and robMatch1Rt) = '0') 
                                                      or (robTail = "000" and (robMatch3Rt and robMatch2Rt and robMatch1Rt and robMatch0Rt) = '0')
                                                      or (robTail = "111" and (robMatch3Rt and robMatch2Rt and robMatch1Rt and robMatch0Rt and robMatch7Rt) = '0')
                                                      or (robTail = "110" and (robMatch3Rt and robMatch2Rt and robMatch1Rt and robMatch0Rt and robMatch7Rt and robMatch6Rt) = '0') 
                                                      or (robTail = "101" and (robMatch3Rt and robMatch2Rt and robMatch1Rt and robMatch0Rt and robMatch7Rt and robMatch6Rt and robMatch5Rt) = '0'))) else
						 "101" when (robMatch5Rt = '1' and (   (robTail = "101")
                                                      or (robTail = "100" and  robMatch4Rt = '0')
                                                      or (robTail = "011" and (robMatch4Rt and robMatch3Rt) = '0')
                                                      or (robTail = "010" and (robMatch4Rt and robMatch3Rt and robMatch2Rt) = '0')
                                                      or (robTail = "001" and (robMatch4Rt and robMatch3Rt and robMatch2Rt and robMatch1Rt) = '0') 
                                                      or (robTail = "000" and (robMatch4Rt and robMatch3Rt and robMatch2Rt and robMatch1Rt and robMatch0Rt) = '0')
                                                      or (robTail = "111" and (robMatch4Rt and robMatch3Rt and robMatch2Rt and robMatch1Rt and robMatch0Rt and robMatch7Rt) = '0')
                                                      or (robTail = "110" and (robMatch4Rt and robMatch3Rt and robMatch2Rt and robMatch1Rt and robMatch0Rt and robMatch7Rt and robMatch6Rt) = '0'))) else
						 "110" when (robMatch6Rt = '1' and (   (robTail = "110")
                                                      or (robTail = "101" and  robMatch5Rt = '0')
                                                      or (robTail = "100" and (robMatch5Rt and robMatch4Rt) = '0')
                                                      or (robTail = "011" and (robMatch5Rt and robMatch4Rt and robMatch3Rt) = '0')
                                                      or (robTail = "010" and (robMatch5Rt and robMatch4Rt and robMatch3Rt and robMatch2Rt) = '0')
                                                      or (robTail = "001" and (robMatch5Rt and robMatch4Rt and robMatch3Rt and robMatch2Rt and robMatch1Rt) = '0') 
                                                      or (robTail = "000" and (robMatch5Rt and robMatch4Rt and robMatch3Rt and robMatch2Rt and robMatch1Rt and robMatch0Rt) = '0')
                                                      or (robTail = "111" and (robMatch5Rt and robMatch4Rt and robMatch3Rt and robMatch2Rt and robMatch1Rt and robMatch0Rt and robMatch7Rt) = '0'))) else
						 "111" when (robMatch7Rt = '1' and (   (robTail = "111")
                                                      or (robTail = "110" and  robMatch6Rt = '0')
                                                      or (robTail = "101" and (robMatch6Rt and robMatch5Rt) = '0')
                                                      or (robTail = "100" and (robMatch6Rt and robMatch5Rt and robMatch4Rt) = '0')
                                                      or (robTail = "011" and (robMatch6Rt and robMatch5Rt and robMatch4Rt and robMatch3Rt) = '0')
                                                      or (robTail = "010" and (robMatch6Rt and robMatch5Rt and robMatch4Rt and robMatch3Rt and robMatch2Rt) = '0')
                                                      or (robTail = "001" and (robMatch6Rt and robMatch5Rt and robMatch4Rt and robMatch3Rt and robMatch2Rt and robMatch1Rt) = '0') 
                                                      or (robTail = "000" and (robMatch6Rt and robMatch5Rt and robMatch4Rt and robMatch3Rt and robMatch2Rt and robMatch1Rt and robMatch0Rt) = '0'))) else
						 "XXX"; -- error
	 
	 
    robMatchIdRt_mem <= "000" when (robMatch0Rt_mem = '1' and (   (robTail = "000") 
                                                          or (robTail = "111" and  robMatch7Rt_mem = '0')
                                                          or (robTail = "110" and (robMatch7Rt_mem and robMatch6Rt_mem) = '0') 
                                                          or (robTail = "101" and (robMatch7Rt_mem and robMatch6Rt_mem and robMatch5Rt_mem) = '0')
                                                          or (robTail = "100" and (robMatch7Rt_mem and robMatch6Rt_mem and robMatch5Rt_mem and robMatch4Rt_mem) = '0') 
                                                          or (robTail = "011" and (robMatch7Rt_mem and robMatch6Rt_mem and robMatch5Rt_mem and robMatch4Rt_mem and robMatch3Rt_mem) = '0') 
                                                          or (robTail = "010" and (robMatch7Rt_mem and robMatch6Rt_mem and robMatch5Rt_mem and robMatch4Rt_mem and robMatch3Rt_mem and robMatch2Rt_mem) = '0') 
                                                          or (robTail = "001" and (robMatch7Rt_mem and robMatch6Rt_mem and robMatch5Rt_mem and robMatch4Rt_mem and robMatch3Rt_mem and robMatch2Rt_mem and robMatch1Rt_mem) = '0'))) else 
    						 "001" when (robMatch1Rt_mem = '1' and (   (robTail = "001") 
                                                          or (robTail = "000" and  robMatch0Rt_mem = '0')
                                                          or (robTail = "111" and (robMatch0Rt_mem and robMatch7Rt_mem) = '0')
                                                          or (robTail = "110" and (robMatch0Rt_mem and robMatch7Rt_mem and robMatch6Rt_mem) = '0') 
                                                          or (robTail = "101" and (robMatch0Rt_mem and robMatch7Rt_mem and robMatch6Rt_mem and robMatch5Rt_mem) = '0')
                                                          or (robTail = "100" and (robMatch0Rt_mem and robMatch7Rt_mem and robMatch6Rt_mem and robMatch5Rt_mem and robMatch4Rt_mem) = '0') 
                                                          or (robTail = "011" and (robMatch0Rt_mem and robMatch7Rt_mem and robMatch6Rt_mem and robMatch5Rt_mem and robMatch4Rt_mem and robMatch3Rt_mem) = '0') 
                                                          or (robTail = "010" and (robMatch0Rt_mem and robMatch7Rt_mem and robMatch6Rt_mem and robMatch5Rt_mem and robMatch4Rt_mem and robMatch3Rt_mem and robMatch2Rt_mem) = '0'))) else 
	    					 "010" when (robMatch2Rt_mem = '1' and (   (robTail = "010")
                                                          or (robTail = "001" and  robMatch1Rt_mem = '0') 
                                                          or (robTail = "000" and (robMatch1Rt_mem and robMatch0Rt_mem) = '0')
                                                          or (robTail = "111" and (robMatch1Rt_mem and robMatch0Rt_mem and robMatch7Rt_mem) = '0')
                                                          or (robTail = "110" and (robMatch1Rt_mem and robMatch0Rt_mem and robMatch7Rt_mem and robMatch6Rt_mem) = '0') 
                                                          or (robTail = "101" and (robMatch1Rt_mem and robMatch0Rt_mem and robMatch7Rt_mem and robMatch6Rt_mem and robMatch5Rt_mem) = '0')
                                                          or (robTail = "100" and (robMatch1Rt_mem and robMatch0Rt_mem and robMatch7Rt_mem and robMatch6Rt_mem and robMatch5Rt_mem and robMatch4Rt_mem) = '0') 
                                                          or (robTail = "011" and (robMatch1Rt_mem and robMatch0Rt_mem and robMatch7Rt_mem and robMatch6Rt_mem and robMatch5Rt_mem and robMatch4Rt_mem and robMatch3Rt_mem) = '0'))) else
		    				 "011" when (robMatch3Rt_mem = '1' and (   (robTail = "011")
                                                          or (robTail = "010" and  robMatch2Rt_mem = '0')
                                                          or (robTail = "001" and (robMatch2Rt_mem and robMatch1Rt_mem) = '0') 
                                                          or (robTail = "000" and (robMatch2Rt_mem and robMatch1Rt_mem and robMatch0Rt_mem) = '0')
                                                          or (robTail = "111" and (robMatch2Rt_mem and robMatch1Rt_mem and robMatch0Rt_mem and robMatch7Rt_mem) = '0')
                                                          or (robTail = "110" and (robMatch2Rt_mem and robMatch1Rt_mem and robMatch0Rt_mem and robMatch7Rt_mem and robMatch6Rt_mem) = '0') 
                                                          or (robTail = "101" and (robMatch2Rt_mem and robMatch1Rt_mem and robMatch0Rt_mem and robMatch7Rt_mem and robMatch6Rt_mem and robMatch5Rt_mem) = '0')
                                                          or (robTail = "100" and (robMatch2Rt_mem and robMatch1Rt_mem and robMatch0Rt_mem and robMatch7Rt_mem and robMatch6Rt_mem and robMatch5Rt_mem and robMatch4Rt_mem) = '0'))) else
				    		 "100" when (robMatch4Rt_mem = '1' and (   (robTail = "100")
                                                          or (robTail = "011" and  robMatch3Rt_mem = '0')
                                                          or (robTail = "010" and (robMatch3Rt_mem and robMatch2Rt_mem) = '0')
                                                          or (robTail = "001" and (robMatch3Rt_mem and robMatch2Rt_mem and robMatch1Rt_mem) = '0') 
                                                          or (robTail = "000" and (robMatch3Rt_mem and robMatch2Rt_mem and robMatch1Rt_mem and robMatch0Rt_mem) = '0')
                                                          or (robTail = "111" and (robMatch3Rt_mem and robMatch2Rt_mem and robMatch1Rt_mem and robMatch0Rt_mem and robMatch7Rt_mem) = '0')
                                                          or (robTail = "110" and (robMatch3Rt_mem and robMatch2Rt_mem and robMatch1Rt_mem and robMatch0Rt_mem and robMatch7Rt_mem and robMatch6Rt_mem) = '0') 
                                                          or (robTail = "101" and (robMatch3Rt_mem and robMatch2Rt_mem and robMatch1Rt_mem and robMatch0Rt_mem and robMatch7Rt_mem and robMatch6Rt_mem and robMatch5Rt_mem) = '0'))) else
    						 "101" when (robMatch5Rt_mem = '1' and (   (robTail = "101")
                                                          or (robTail = "100" and  robMatch4Rt_mem = '0')
                                                          or (robTail = "011" and (robMatch4Rt_mem and robMatch3Rt_mem) = '0')
                                                          or (robTail = "010" and (robMatch4Rt_mem and robMatch3Rt_mem and robMatch2Rt_mem) = '0')
                                                          or (robTail = "001" and (robMatch4Rt_mem and robMatch3Rt_mem and robMatch2Rt_mem and robMatch1Rt_mem) = '0') 
                                                          or (robTail = "000" and (robMatch4Rt_mem and robMatch3Rt_mem and robMatch2Rt_mem and robMatch1Rt_mem and robMatch0Rt_mem) = '0')
                                                          or (robTail = "111" and (robMatch4Rt_mem and robMatch3Rt_mem and robMatch2Rt_mem and robMatch1Rt_mem and robMatch0Rt_mem and robMatch7Rt_mem) = '0')
                                                          or (robTail = "110" and (robMatch4Rt_mem and robMatch3Rt_mem and robMatch2Rt_mem and robMatch1Rt_mem and robMatch0Rt_mem and robMatch7Rt_mem and robMatch6Rt_mem) = '0'))) else
						     "110" when (robMatch6Rt_mem = '1' and (   (robTail = "110")
                                                          or (robTail = "101" and  robMatch5Rt_mem = '0')
                                                          or (robTail = "100" and (robMatch5Rt_mem and robMatch4Rt_mem) = '0')
                                                          or (robTail = "011" and (robMatch5Rt_mem and robMatch4Rt_mem and robMatch3Rt_mem) = '0')
                                                          or (robTail = "010" and (robMatch5Rt_mem and robMatch4Rt_mem and robMatch3Rt_mem and robMatch2Rt_mem) = '0')
                                                          or (robTail = "001" and (robMatch5Rt_mem and robMatch4Rt_mem and robMatch3Rt_mem and robMatch2Rt_mem and robMatch1Rt_mem) = '0') 
                                                          or (robTail = "000" and (robMatch5Rt_mem and robMatch4Rt_mem and robMatch3Rt_mem and robMatch2Rt_mem and robMatch1Rt_mem and robMatch0Rt_mem) = '0')
                                                          or (robTail = "111" and (robMatch5Rt_mem and robMatch4Rt_mem and robMatch3Rt_mem and robMatch2Rt_mem and robMatch1Rt_mem and robMatch0Rt_mem and robMatch7Rt_mem) = '0'))) else
    						 "111" when (robMatch7Rt_mem = '1' and (   (robTail = "111")
                                                          or (robTail = "110" and  robMatch6Rt_mem = '0')
                                                          or (robTail = "101" and (robMatch6Rt_mem and robMatch5Rt_mem) = '0')
                                                          or (robTail = "100" and (robMatch6Rt_mem and robMatch5Rt_mem and robMatch4Rt_mem) = '0')
                                                          or (robTail = "011" and (robMatch6Rt_mem and robMatch5Rt_mem and robMatch4Rt_mem and robMatch3Rt_mem) = '0')
                                                          or (robTail = "010" and (robMatch6Rt_mem and robMatch5Rt_mem and robMatch4Rt_mem and robMatch3Rt_mem and robMatch2Rt_mem) = '0')
                                                          or (robTail = "001" and (robMatch6Rt_mem and robMatch5Rt_mem and robMatch4Rt_mem and robMatch3Rt_mem and robMatch2Rt_mem and robMatch1Rt_mem) = '0') 
                                                          or (robTail = "000" and (robMatch6Rt_mem and robMatch5Rt_mem and robMatch4Rt_mem and robMatch3Rt_mem and robMatch2Rt_mem and robMatch1Rt_mem and robMatch0Rt_mem) = '0'))) else
				    		 "XXX"; -- error
					
    robRegisterRdRs <= robRegisterRd0 when robMatchIdRs = "000" else
                       robRegisterRd1 when robMatchIdRs = "001" else
                       robRegisterRd2 when robMatchIdRs = "010" else
                       robRegisterRd3 when robMatchIdRs = "011" else
                       robRegisterRd4 when robMatchIdRs = "100" else
                       robRegisterRd5 when robMatchIdRs = "101" else
                       robRegisterRd6 when robMatchIdRs = "110" else
                       robRegisterRd7; --  robMatchIdRs = "111" else
							  
    robRegisterRdRt <= robRegisterRd0 when robMatchIdRt = "000" else
                       robRegisterRd1 when robMatchIdRt = "001" else
                       robRegisterRd2 when robMatchIdRt = "010" else
                       robRegisterRd3 when robMatchIdRt = "011" else
                       robRegisterRd4 when robMatchIdRt = "100" else
                       robRegisterRd5 when robMatchIdRt = "101" else
                       robRegisterRd6 when robMatchIdRt = "110" else
                       robRegisterRd7; --  robMatchIdRt = "111" else

    robRegisterRdRt_mem <= robRegisterRd0 when robMatchIdRt_mem = "000" else
                           robRegisterRd1 when robMatchIdRt_mem = "001" else
                           robRegisterRd2 when robMatchIdRt_mem = "010" else
                           robRegisterRd3 when robMatchIdRt_mem = "011" else
                           robRegisterRd4 when robMatchIdRt_mem = "100" else
                           robRegisterRd5 when robMatchIdRt_mem = "101" else
                           robRegisterRd6 when robMatchIdRt_mem = "110" else
                           robRegisterRd7; --  robMatchIdRt_mem = "111" else

    robMatchIdRs_out     <= robMatchIdRs;
    robMatchIdRt_out     <= robMatchIdRt;	 
    robMatchIdRt_mem_out <= robMatchIdRt_mem;
	 
    fwd_aluRs <= "111" when (         exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRs ) else  -- fwd from ALU to ID 
                 "100" when (         robMatchRs = '1' 
                             and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRs)) else  -- fwd from ROB (youngest Rd=Rs) to ID
                 "110" when (         tagRegWrite = '1' and tagRegisterRd /= "000000" and tagRegisterRd = idRegisterRs
                             and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRs)
									  and not (FreeSlotL = '1')                                                                 ) else  -- fwd from LOOKUP to ID 
                 "101" when (         dcaRegWrite = '1' and dcaRegisterRd /= "000000" and dcaRegisterRd = idRegisterRs
                             and not (tagRegWrite = '1' and tagRegisterRd /= "000000" and tagRegisterRd = idRegisterRs)
                             and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRs)
									  and not (FreeSlotC = '1')                                                                 ) else  -- fwd from CACHE to ID 
                 "000";                                                                                                       -- (don't fwd) typical path 
    
    fwd_aluRt <= "111" when (         exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt ) else  -- fwd from ALU to ID 
                 "100" when (         robMatchRt = '1' 
                             and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt)) else  -- fwd from ROB (youngest Rd=Rt) to ID
                 "110" when (         tagRegWrite = '1' and tagRegisterRd /= "000000" and tagRegisterRd = idRegisterRt         -- fwd from LOOKUP to ID 
                             and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt)
									  and not (FreeSlotL = '1')                                                                 ) else  -- priority for newest value(alu)
                 "101" when (         dcaRegWrite = '1' and dcaRegisterRd /= "000000" and dcaRegisterRd = idRegisterRt
					              and not (tagRegWrite = '1' and tagRegisterRd /= "000000" and tagRegisterRd = idRegisterRt)
                             and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt)
									  and not (FreeSlotC = '1')                                                                 ) else  -- fwd from CACHE to ID 
                 "000";                                                                                                       -- (don't fwd) typical path
    
    fwd_alu_regmem <= "111" when (         exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt and idMemWrite = '1')  else -- fwd from ALU to ID (ALU-STORE)
                      "100" when (         robMatchRt_mem = '1' 
                                  and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt and idMemWrite = '1')) else  -- fwd from ROB (youngest Rd=Rt-mem) to ID
                      "110" when (         tagRegWrite = '1' and tagRegisterRd /= "000000" and tagRegisterRd = idRegisterRt and idMemWrite = '1'        
                                  and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt and idMemWrite = '1')
									       and not (FreeSlotL = '1')                                                                                      ) else -- fwd from L to ID (ALU-STORE from LOOKUP)
                      "101" when (         dcaRegWrite = '1' and dcaRegisterRd /= "000000" and dcaRegisterRd = idRegisterRt and idMemWrite = '1'
					                   and not (tagRegWrite = '1' and tagRegisterRd /= "000000" and tagRegisterRd = idRegisterRt and idMemWrite = '1')
                                  and not (exeRegWrite = '1' and exeRegisterRd /= "000000" and exeRegisterRd = idRegisterRt and idMemWrite = '1')
									       and not (FreeSlotC = '1')                                                                                      ) else  -- fwd from C to ID (LOAD-STORE)
                      "000";

    --TODO Rethink this forward paths with ROB
    fwd_lookup_regmem <= '1' when (tagRegWrite = '1' and tagRegisterRd /= "000000" and tagRegisterRd = exeRegisterRt and exeMemWrite = '1') else -- PRODUCER(LOOKUP)-CONSUMER(ALU)in next cycle
                         '0';
    fwd_cache_regmem  <= '1' when (dcaRegWrite = '1' and dcaRegisterRd /= "000000" and dcaRegisterRd = exeRegisterRt and exeMemWrite = '1') else -- PRODUCER(CACHE)-CONSUMER(ALU)
                         '0';    
end Structure;
