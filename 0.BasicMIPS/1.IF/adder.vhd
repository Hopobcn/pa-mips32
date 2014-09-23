library ieee;
use ieee.std_logic_1164.all;

entity adder is
	port (pc		: 	in	std_logic_vector(31 downto 0);
			four	:	in	std_logic_vector(2 downto 0);
			pc_up	:	out std_logic_vector(31 downto 0));
end adder;

architecture Structure of adder is

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

	--pc <= pc + four; --be, no s'escriu aixi :-) modificar mes endavant
	
	
	caIn0 <= '0';
	
	ADDER0	: adder_branch_1bit_adder
	port map(a			=> pc(0),
				b			=> four(0),
				carryIn	=>	caIn0,
				res		=> pc_up(0),
				carryOut	=>	caOut0_2_caIn1); 

	ADDER1	: adder_branch_1bit_adder
	port map(a			=> pc(1),
				b			=> four(1),
				carryIn	=>	caOut0_2_caIn1,
				res		=> pc_up(1),
				carryOut	=>	caOut1_2_caIn2); 
				
	ADDER2	: adder_branch_1bit_adder
	port map(a			=> pc(2),
				b			=> four(2),
				carryIn	=>	caOut1_2_caIn2,
				res		=> pc_up(2),
				carryOut	=>	caOut2_2_caIn3); 
				
	ADDER3	: adder_branch_1bit_adder
	port map(a			=> pc(3),
				b			=> '0',
				carryIn	=>	caOut2_2_caIn3,
				res		=> pc_up(3),
				carryOut	=>	caOut3_2_caIn4); 
				
	ADDER4	: adder_branch_1bit_adder
	port map(a			=> pc(4),
				b			=> '0',
				carryIn	=>	caOut3_2_caIn4,
				res		=> pc_up(4),
				carryOut	=>	caOut4_2_caIn5); 
				
	ADDER5	: adder_branch_1bit_adder
	port map(a			=> pc(5),
				b			=> '0',
				carryIn	=>	caOut4_2_caIn5,
				res		=> pc_up(5),
				carryOut	=>	caOut5_2_caIn6); 
				
	ADDER6	: adder_branch_1bit_adder
	port map(a			=> pc(6),
				b			=> '0',
				carryIn	=>	caOut5_2_caIn6,
				res		=> pc_up(6),
				carryOut	=>	caOut6_2_caIn7); 
				
	ADDER7	: adder_branch_1bit_adder
	port map(a			=> pc(7),
				b			=> '0',
				carryIn	=>	caOut6_2_caIn7,
				res		=> pc_up(7),
				carryOut	=>	caOut7_2_caIn8); 
				
	ADDER8	: adder_branch_1bit_adder
	port map(a			=> pc(8),
				b			=> '0',
				carryIn	=>	caOut7_2_caIn8,
				res		=> pc_up(8),
				carryOut	=>	caOut8_2_caIn9); 
				
	ADDER9	: adder_branch_1bit_adder
	port map(a			=> pc(9),
				b			=> '0',
				carryIn	=>	caOut8_2_caIn9,
				res		=> pc_up(9),
				carryOut	=>	caOut9_2_caIn10); 
				
	ADDER10	: adder_branch_1bit_adder
	port map(a			=> pc(10),
				b			=> '0',
				carryIn	=>	caOut9_2_caIn10,
				res		=> pc_up(10),
				carryOut	=>	caOut10_2_caIn11); 
				
	ADDER11	: adder_branch_1bit_adder
	port map(a			=> pc(11),
				b			=> '0',
				carryIn	=>	caOut10_2_caIn11,
				res		=> pc_up(11),
				carryOut	=>	caOut11_2_caIn12); 
				
	ADDER12	: adder_branch_1bit_adder
	port map(a			=> pc(12),
				b			=> '0',
				carryIn	=>	caOut11_2_caIn12,
				res		=> pc_up(12),
				carryOut	=>	caOut12_2_caIn13); 
				
	ADDER13	: adder_branch_1bit_adder
	port map(a			=> pc(13),
				b			=> '0',
				carryIn	=>	caOut12_2_caIn13,
				res		=> pc_up(13),
				carryOut	=>	caOut13_2_caIn14); 
				
	ADDER14	: adder_branch_1bit_adder
	port map(a			=> pc(14),
				b			=> '0',
				carryIn	=>	caOut13_2_caIn14,
				res		=> pc_up(14),
				carryOut	=>	caOut14_2_caIn15); 
				
	ADDER15	: adder_branch_1bit_adder
	port map(a			=> pc(15),
				b			=> '0',
				carryIn	=>	caOut14_2_caIn15,
				res		=> pc_up(15),
				carryOut	=>	caOut15_2_caIn16); 
				
	ADDER16	: adder_branch_1bit_adder
	port map(a			=> pc(16),
				b			=> '0',
				carryIn	=>	caOut15_2_caIn16,
				res		=> pc_up(16),
				carryOut	=>	caOut16_2_caIn17); 
				
	ADDER17	: adder_branch_1bit_adder
	port map(a			=> pc(17),
				b			=> '0',
				carryIn	=>	caOut16_2_caIn17,
				res		=> pc_up(17),
				carryOut	=>	caOut17_2_caIn18); 
				
	ADDER18	: adder_branch_1bit_adder
	port map(a			=> pc(18),
				b			=> '0',
				carryIn	=>	caOut17_2_caIn18,
				res		=> pc_up(18),
				carryOut	=>	caOut18_2_caIn19); 
				
	ADDER19	: adder_branch_1bit_adder
	port map(a			=> pc(19),
				b			=> '0',
				carryIn	=>	caOut18_2_caIn19,
				res		=> pc_up(19),
				carryOut	=>	caOut19_2_caIn20); 
				
	ADDER20	: adder_branch_1bit_adder
	port map(a			=> pc(20),
				b			=> '0',
				carryIn	=>	caOut19_2_caIn20,
				res		=> pc_up(20),
				carryOut	=>	caOut20_2_caIn21); 
				
	ADDER21	: adder_branch_1bit_adder
	port map(a			=> pc(21),
				b			=> '0',
				carryIn	=>	caOut20_2_caIn21,
				res		=> pc_up(21),
				carryOut	=>	caOut21_2_caIn22); 
				
	ADDER22	: adder_branch_1bit_adder
	port map(a			=> pc(22),
				b			=> '0',
				carryIn	=>	caOut21_2_caIn22,
				res		=> pc_up(22),
				carryOut	=>	caOut22_2_caIn23); 
				
	ADDER23	: adder_branch_1bit_adder
	port map(a			=> pc(23),
				b			=> '0',
				carryIn	=>	caOut22_2_caIn23,
				res		=> pc_up(23),
				carryOut	=>	caOut23_2_caIn24); 
				
	ADDER24	: adder_branch_1bit_adder
	port map(a			=> pc(24),
				b			=> '0',
				carryIn	=>	caOut23_2_caIn24,
				res		=> pc_up(24),
				carryOut	=>	caOut24_2_caIn25); 
				
	ADDER25	: adder_branch_1bit_adder
	port map(a			=> pc(25),
				b			=> '0',
				carryIn	=>	caOut24_2_caIn25,
				res		=> pc_up(25),
				carryOut	=>	caOut25_2_caIn26); 
				
	ADDER26	: adder_branch_1bit_adder
	port map(a			=> pc(26),
				b			=> '0',
				carryIn	=>	caOut25_2_caIn26,
				res		=> pc_up(26),
				carryOut	=>	caOut26_2_caIn27); 
				
	ADDER27	: adder_branch_1bit_adder
	port map(a			=> pc(27),
				b			=> '0',
				carryIn	=>	caOut26_2_caIn27,
				res		=> pc_up(27),
				carryOut	=>	caOut27_2_caIn28); 
				
	ADDER28	: adder_branch_1bit_adder
	port map(a			=> pc(28),
				b			=> '0',
				carryIn	=>	caOut27_2_caIn28,
				res		=> pc_up(28),
				carryOut	=>	caOut28_2_caIn29); 
				
	ADDER29	: adder_branch_1bit_adder
	port map(a			=> pc(29),
				b			=> '0',
				carryIn	=>	caOut28_2_caIn29,
				res		=> pc_up(29),
				carryOut	=>	caOut29_2_caIn30); 
				
	ADDER30	: adder_branch_1bit_adder
	port map(a			=> pc(30),
				b			=> '0',
				carryIn	=>	caOut29_2_caIn30,
				res		=> pc_up(30),
				carryOut	=>	caOut30_2_caIn31); 
				
	ADDER31	: adder_branch_1bit_adder
	port map(a			=> pc(31),
				b			=> '0',
				carryIn	=>	caOut30_2_caIn31,
				res		=> pc_up(31),
				carryOut	=>	caOut31); 
				
				
end Structure;