library ieee;
use ieee.std_logic_1164.all;

entity adder_branch is
	port (--buses
			pc_up			:	in std_logic_vector(31 downto 0);
			offset		:	in	std_logic_vector(31 downto 0);
			addr_branch	:	out std_logic_vector(31 downto 0));
			
end adder_branch;

architecture Structure of adder_branch is

	component adder_branch_1bit_adder is
	port(	a			:	in std_logic;
			b			:	in std_logic;
			carryIn	:	in	std_logic;
			res		:	out std_logic;
			carryOut	:	out std_logic);
	end component;
	
	signal caIn0				:	std_logic;
	signal caOut0_2_caIn1	:	std_logic;
	signal caOut1_2_caIn2	:	std_logic;
	signal caOut2_2_caIn3	:	std_logic;
	signal caOut3_2_caIn4	:	std_logic;
	signal caOut4_2_caIn5	:	std_logic;
	signal caOut5_2_caIn6	:	std_logic;
	signal caOut6_2_caIn7	:	std_logic;
	signal caOut7_2_caIn8	:	std_logic;
	signal caOut8_2_caIn9	:	std_logic;
	signal caOut9_2_caIn10	:	std_logic;
	signal caOut10_2_caIn11	:	std_logic;
	signal caOut11_2_caIn12	:	std_logic;
	signal caOut12_2_caIn13	:	std_logic;
	signal caOut13_2_caIn14	:	std_logic;
	signal caOut14_2_caIn15	:	std_logic;
	signal caOut15_2_caIn16	:	std_logic;
	signal caOut16_2_caIn17	:	std_logic;
	signal caOut17_2_caIn18	:	std_logic;
	signal caOut18_2_caIn19	:	std_logic;
	signal caOut19_2_caIn20	:	std_logic;
	signal caOut20_2_caIn21	:	std_logic;
	signal caOut21_2_caIn22	:	std_logic;
	signal caOut22_2_caIn23	:	std_logic;
	signal caOut23_2_caIn24	:	std_logic;
	signal caOut24_2_caIn25	:	std_logic;
	signal caOut25_2_caIn26	:	std_logic;
	signal caOut26_2_caIn27	:	std_logic;
	signal caOut27_2_caIn28	:	std_logic;
	signal caOut28_2_caIn29	:	std_logic;
	signal caOut29_2_caIn30	:	std_logic;
	signal caOut30_2_caIn31	:	std_logic;
	signal caOut31				:	std_logic;
	
begin
	
	--addr_branch => pc_up + offset;
	
	caIn0 <= '0';
	
	ADDER0	: adder_branch_1bit_adder
	port map(a			=> pc_up(0),
				b			=> offset(0),
				carryIn	=>	caIn0,
				res		=> addr_branch(0),
				carryOut	=>	caOut0_2_caIn1); 

	ADDER1	: adder_branch_1bit_adder
	port map(a			=> pc_up(1),
				b			=> offset(1),
				carryIn	=>	caOut0_2_caIn1,
				res		=> addr_branch(1),
				carryOut	=>	caOut1_2_caIn2); 
				
	ADDER2	: adder_branch_1bit_adder
	port map(a			=> pc_up(2),
				b			=> offset(2),
				carryIn	=>	caOut1_2_caIn2,
				res		=> addr_branch(2),
				carryOut	=>	caOut2_2_caIn3); 
				
	ADDER3	: adder_branch_1bit_adder
	port map(a			=> pc_up(3),
				b			=> offset(3),
				carryIn	=>	caOut2_2_caIn3,
				res		=> addr_branch(3),
				carryOut	=>	caOut3_2_caIn4); 
				
	ADDER4	: adder_branch_1bit_adder
	port map(a			=> pc_up(4),
				b			=> offset(4),
				carryIn	=>	caOut3_2_caIn4,
				res		=> addr_branch(4),
				carryOut	=>	caOut4_2_caIn5); 
				
	ADDER5	: adder_branch_1bit_adder
	port map(a			=> pc_up(5),
				b			=> offset(5),
				carryIn	=>	caOut4_2_caIn5,
				res		=> addr_branch(5),
				carryOut	=>	caOut5_2_caIn6); 
				
	ADDER6	: adder_branch_1bit_adder
	port map(a			=> pc_up(6),
				b			=> offset(6),
				carryIn	=>	caOut5_2_caIn6,
				res		=> addr_branch(6),
				carryOut	=>	caOut6_2_caIn7); 
				
	ADDER7	: adder_branch_1bit_adder
	port map(a			=> pc_up(7),
				b			=> offset(7),
				carryIn	=>	caOut6_2_caIn7,
				res		=> addr_branch(7),
				carryOut	=>	caOut7_2_caIn8); 
				
	ADDER8	: adder_branch_1bit_adder
	port map(a			=> pc_up(8),
				b			=> offset(8),
				carryIn	=>	caOut7_2_caIn8,
				res		=> addr_branch(8),
				carryOut	=>	caOut8_2_caIn9); 
				
	ADDER9	: adder_branch_1bit_adder
	port map(a			=> pc_up(9),
				b			=> offset(9),
				carryIn	=>	caOut8_2_caIn9,
				res		=> addr_branch(9),
				carryOut	=>	caOut9_2_caIn10); 
				
	ADDER10	: adder_branch_1bit_adder
	port map(a			=> pc_up(10),
				b			=> offset(10),
				carryIn	=>	caOut9_2_caIn10,
				res		=> addr_branch(10),
				carryOut	=>	caOut10_2_caIn11); 
				
	ADDER11	: adder_branch_1bit_adder
	port map(a			=> pc_up(11),
				b			=> offset(11),
				carryIn	=>	caOut10_2_caIn11,
				res		=> addr_branch(11),
				carryOut	=>	caOut11_2_caIn12); 
				
	ADDER12	: adder_branch_1bit_adder
	port map(a			=> pc_up(12),
				b			=> offset(12),
				carryIn	=>	caOut11_2_caIn12,
				res		=> addr_branch(12),
				carryOut	=>	caOut12_2_caIn13); 
				
	ADDER13	: adder_branch_1bit_adder
	port map(a			=> pc_up(13),
				b			=> offset(13),
				carryIn	=>	caOut12_2_caIn13,
				res		=> addr_branch(13),
				carryOut	=>	caOut13_2_caIn14); 
				
	ADDER14	: adder_branch_1bit_adder
	port map(a			=> pc_up(14),
				b			=> offset(14),
				carryIn	=>	caOut13_2_caIn14,
				res		=> addr_branch(14),
				carryOut	=>	caOut14_2_caIn15); 
				
	ADDER15	: adder_branch_1bit_adder
	port map(a			=> pc_up(15),
				b			=> offset(15),
				carryIn	=>	caOut14_2_caIn15,
				res		=> addr_branch(15),
				carryOut	=>	caOut15_2_caIn16); 
				
	ADDER16	: adder_branch_1bit_adder
	port map(a			=> pc_up(16),
				b			=> offset(16),
				carryIn	=>	caOut15_2_caIn16,
				res		=> addr_branch(16),
				carryOut	=>	caOut16_2_caIn17); 
				
	ADDER17	: adder_branch_1bit_adder
	port map(a			=> pc_up(17),
				b			=> offset(17),
				carryIn	=>	caOut16_2_caIn17,
				res		=> addr_branch(17),
				carryOut	=>	caOut17_2_caIn18); 
				
	ADDER18	: adder_branch_1bit_adder
	port map(a			=> pc_up(18),
				b			=> offset(18),
				carryIn	=>	caOut17_2_caIn18,
				res		=> addr_branch(18),
				carryOut	=>	caOut18_2_caIn19); 
				
	ADDER19	: adder_branch_1bit_adder
	port map(a			=> pc_up(19),
				b			=> offset(19),
				carryIn	=>	caOut18_2_caIn19,
				res		=> addr_branch(19),
				carryOut	=>	caOut19_2_caIn20); 
				
	ADDER20	: adder_branch_1bit_adder
	port map(a			=> pc_up(20),
				b			=> offset(20),
				carryIn	=>	caOut19_2_caIn20,
				res		=> addr_branch(20),
				carryOut	=>	caOut20_2_caIn21); 
				
	ADDER21	: adder_branch_1bit_adder
	port map(a			=> pc_up(21),
				b			=> offset(21),
				carryIn	=>	caOut20_2_caIn21,
				res		=> addr_branch(21),
				carryOut	=>	caOut21_2_caIn22); 
				
	ADDER22	: adder_branch_1bit_adder
	port map(a			=> pc_up(22),
				b			=> offset(22),
				carryIn	=>	caOut21_2_caIn22,
				res		=> addr_branch(22),
				carryOut	=>	caOut22_2_caIn23); 
				
	ADDER23	: adder_branch_1bit_adder
	port map(a			=> pc_up(23),
				b			=> offset(23),
				carryIn	=>	caOut22_2_caIn23,
				res		=> addr_branch(23),
				carryOut	=>	caOut23_2_caIn24); 
				
	ADDER24	: adder_branch_1bit_adder
	port map(a			=> pc_up(24),
				b			=> offset(24),
				carryIn	=>	caOut23_2_caIn24,
				res		=> addr_branch(24),
				carryOut	=>	caOut24_2_caIn25); 
				
	ADDER25	: adder_branch_1bit_adder
	port map(a			=> pc_up(25),
				b			=> offset(25),
				carryIn	=>	caOut24_2_caIn25,
				res		=> addr_branch(25),
				carryOut	=>	caOut25_2_caIn26); 
				
	ADDER26	: adder_branch_1bit_adder
	port map(a			=> pc_up(26),
				b			=> offset(26),
				carryIn	=>	caOut25_2_caIn26,
				res		=> addr_branch(26),
				carryOut	=>	caOut26_2_caIn27); 
				
	ADDER27	: adder_branch_1bit_adder
	port map(a			=> pc_up(27),
				b			=> offset(27),
				carryIn	=>	caOut26_2_caIn27,
				res		=> addr_branch(27),
				carryOut	=>	caOut27_2_caIn28); 
				
	ADDER28	: adder_branch_1bit_adder
	port map(a			=> pc_up(28),
				b			=> offset(28),
				carryIn	=>	caOut27_2_caIn28,
				res		=> addr_branch(28),
				carryOut	=>	caOut28_2_caIn29); 
				
	ADDER29	: adder_branch_1bit_adder
	port map(a			=> pc_up(29),
				b			=> offset(29),
				carryIn	=>	caOut28_2_caIn29,
				res		=> addr_branch(29),
				carryOut	=>	caOut29_2_caIn30); 
				
	ADDER30	: adder_branch_1bit_adder
	port map(a			=> pc_up(30),
				b			=> offset(30),
				carryIn	=>	caOut29_2_caIn30,
				res		=> addr_branch(30),
				carryOut	=>	caOut30_2_caIn31); 
				
	ADDER31	: adder_branch_1bit_adder
	port map(a			=> pc_up(31),
				b			=> offset(31),
				carryIn	=>	caOut30_2_caIn31,
				res		=> addr_branch(31),
				carryOut	=>	caOut31); 
	
	
	
end Structure;