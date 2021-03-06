library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ALU implementation from Patterson/Hennesy 5th ed. Appendix B. p B-27 to B-37.

entity alu_core is
	port(	-- buses
			a			:	in std_logic_vector(31 downto 0);
			b			:	in std_logic_vector(31 downto 0);
			res		:	out std_logic_vector(31 downto 0);
			-- control signals
			Zero		:	out std_logic;
			Overflow	: 	out std_logic;
		 --CarryOut	: 	out std_logic;
			ALUOp		:	in	std_logic_vector(3 downto 0));
end alu_core;

architecture Structure of alu_core is

	component alu_1bit_alu is
	port(	a			:	in std_logic;
			b			:	in std_logic;
			less		:	in	std_logic;
			carryIn	:	in	std_logic;
			res		:	out std_logic;
			carryOut : 	out std_logic;
			Ainvert	: 	in std_logic;
			Binvert	:	in	std_logic;
			Operation:	in	std_logic_vector(1 downto 0));
	end component;

	
	component alu_1bit_alu_msb is
	port(	a			:	in std_logic;
			b			:	in std_logic;
			less		:	in	std_logic;
			carryIn	:	in	std_logic;
			res		:	out std_logic;
			set 		: 	out std_logic;
			overflow : 	out std_logic;
			Ainvert	: 	in std_logic;
			Binvert	:	in	std_logic;
			Operation:	in	std_logic_vector(1 downto 0));
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
	
	signal less31_2_less01	:	std_logic;
	
	signal res_tmp				: 	std_logic_vector(31 downto 0);
	
begin
	-- Ripple carry ALU
	caIn0  <=  '1' when ALUOp = "0110" else
	           '0';
	
	ALU0	: alu_1bit_alu
	port map(a			=> a(0),
				b			=> b(0),
				less		=> less31_2_less01,
				carryIn	=>	caIn0,
				res		=> res_tmp(0),
				carryOut	=>	caOut0_2_caIn1,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 

	ALU1	: alu_1bit_alu
	port map(a			=> a(1),
				b			=> b(1),
				less		=> '0',
				carryIn	=>	caOut0_2_caIn1,
				res		=> res_tmp(1),
				carryOut	=>	caOut1_2_caIn2,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU2	: alu_1bit_alu
	port map(a			=> a(2),
				b			=> b(2),
				less		=> '0',
				carryIn	=>	caOut1_2_caIn2,
				res		=> res_tmp(2),
				carryOut	=>	caOut2_2_caIn3,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU3	: alu_1bit_alu
	port map(a			=> a(3),
				b			=> b(3),
				less		=> '0',
				carryIn	=>	caOut2_2_caIn3,
				res		=> res_tmp(3),
				carryOut	=>	caOut3_2_caIn4,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU4	: alu_1bit_alu
	port map(a			=> a(4),
				b			=> b(4),
				less		=> '0',
				carryIn	=>	caOut3_2_caIn4,
				res		=> res_tmp(4),
				carryOut	=>	caOut4_2_caIn5,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU5	: alu_1bit_alu
	port map(a			=> a(5),
				b			=> b(5),
				less		=> '0',
				carryIn	=>	caOut4_2_caIn5,
				res		=> res_tmp(5),
				carryOut	=>	caOut5_2_caIn6,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU6	: alu_1bit_alu
	port map(a			=> a(6),
				b			=> b(6),
				less		=> '0',
				carryIn	=>	caOut5_2_caIn6,
				res		=> res_tmp(6),
				carryOut	=>	caOut6_2_caIn7,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU7	: alu_1bit_alu
	port map(a			=> a(7),
				b			=> b(7),
				less		=> '0',
				carryIn	=>	caOut6_2_caIn7,
				res		=> res_tmp(7),
				carryOut	=>	caOut7_2_caIn8,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU8	: alu_1bit_alu
	port map(a			=> a(8),
				b			=> b(8),
				less		=> '0',
				carryIn	=>	caOut7_2_caIn8,
				res		=> res_tmp(8),
				carryOut	=>	caOut8_2_caIn9,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU9	: alu_1bit_alu
	port map(a			=> a(9),
				b			=> b(9),
				less		=> '0',
				carryIn	=>	caOut8_2_caIn9,
				res		=> res_tmp(9),
				carryOut	=>	caOut9_2_caIn10,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU10	: alu_1bit_alu
	port map(a			=> a(10),
				b			=> b(10),
				less		=> '0',
				carryIn	=>	caOut9_2_caIn10,
				res		=> res_tmp(10),
				carryOut	=>	caOut10_2_caIn11,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU11	: alu_1bit_alu
	port map(a			=> a(11),
				b			=> b(11),
				less		=> '0',
				carryIn	=>	caOut10_2_caIn11,
				res		=> res_tmp(11),
				carryOut	=>	caOut11_2_caIn12,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU12	: alu_1bit_alu
	port map(a			=> a(12),
				b			=> b(12),
				less		=> '0',
				carryIn	=>	caOut11_2_caIn12,
				res		=> res_tmp(12),
				carryOut	=>	caOut12_2_caIn13,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU13	: alu_1bit_alu
	port map(a			=> a(13),
				b			=> b(13),
				less		=> '0',
				carryIn	=>	caOut12_2_caIn13,
				res		=> res_tmp(13),
				carryOut	=>	caOut13_2_caIn14,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU14	: alu_1bit_alu
	port map(a			=> a(14),
				b			=> b(14),
				less		=> '0',
				carryIn	=>	caOut13_2_caIn14,
				res		=> res_tmp(14),
				carryOut	=>	caOut14_2_caIn15,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU15	: alu_1bit_alu
	port map(a			=> a(15),
				b			=> b(15),
				less		=> '0',
				carryIn	=>	caOut14_2_caIn15,
				res		=> res_tmp(15),
				carryOut	=>	caOut15_2_caIn16,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU16	: alu_1bit_alu
	port map(a			=> a(16),
				b			=> b(16),
				less		=> '0',
				carryIn	=>	caOut15_2_caIn16,
				res		=> res_tmp(16),
				carryOut	=>	caOut16_2_caIn17,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU17	: alu_1bit_alu
	port map(a			=> a(17),
				b			=> b(17),
				less		=> '0',
				carryIn	=>	caOut16_2_caIn17,
				res		=> res_tmp(17),
				carryOut	=>	caOut17_2_caIn18,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU18	: alu_1bit_alu
	port map(a			=> a(18),
				b			=> b(18),
				less		=> '0',
				carryIn	=>	caOut17_2_caIn18,
				res		=> res_tmp(18),
				carryOut	=>	caOut18_2_caIn19,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU19	: alu_1bit_alu
	port map(a			=> a(19),
				b			=> b(19),
				less		=> '0',
				carryIn	=>	caOut18_2_caIn19,
				res		=> res_tmp(19),
				carryOut	=>	caOut19_2_caIn20,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU20	: alu_1bit_alu
	port map(a			=> a(20),
				b			=> b(20),
				less		=> '0',
				carryIn	=>	caOut19_2_caIn20,
				res		=> res_tmp(20),
				carryOut	=>	caOut20_2_caIn21,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU21	: alu_1bit_alu
	port map(a			=> a(21),
				b			=> b(21),
				less		=> '0',
				carryIn	=>	caOut20_2_caIn21,
				res		=> res_tmp(21),
				carryOut	=>	caOut21_2_caIn22,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU22	: alu_1bit_alu
	port map(a			=> a(22),
				b			=> b(22),
				less		=> '0',
				carryIn	=>	caOut21_2_caIn22,
				res		=> res_tmp(22),
				carryOut	=>	caOut22_2_caIn23,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU23	: alu_1bit_alu
	port map(a			=> a(23),
				b			=> b(23),
				less		=> '0',
				carryIn	=>	caOut22_2_caIn23,
				res		=> res_tmp(23),
				carryOut	=>	caOut23_2_caIn24,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU24	: alu_1bit_alu
	port map(a			=> a(24),
				b			=> b(24),
				less		=> '0',
				carryIn	=>	caOut23_2_caIn24,
				res		=> res_tmp(24),
				carryOut	=>	caOut24_2_caIn25,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU25	: alu_1bit_alu
	port map(a			=> a(25),
				b			=> b(25),
				less		=> '0',
				carryIn	=>	caOut24_2_caIn25,
				res		=> res_tmp(25),
				carryOut	=>	caOut25_2_caIn26,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU26	: alu_1bit_alu
	port map(a			=> a(26),
				b			=> b(26),
				less		=> '0',
				carryIn	=>	caOut25_2_caIn26,
				res		=> res_tmp(26),
				carryOut	=>	caOut26_2_caIn27,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU27	: alu_1bit_alu
	port map(a			=> a(27),
				b			=> b(27),
				less		=> '0',
				carryIn	=>	caOut26_2_caIn27,
				res		=> res_tmp(27),
				carryOut	=>	caOut27_2_caIn28,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU28	: alu_1bit_alu
	port map(a			=> a(28),
				b			=> b(28),
				less		=> '0',
				carryIn	=>	caOut27_2_caIn28,
				res		=> res_tmp(28),
				carryOut	=>	caOut28_2_caIn29,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU29	: alu_1bit_alu
	port map(a			=> a(29),
				b			=> b(29),
				less		=> '0',
				carryIn	=>	caOut28_2_caIn29,
				res		=> res_tmp(29),
				carryOut	=>	caOut29_2_caIn30,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU30	: alu_1bit_alu
	port map(a			=> a(30),
				b			=> b(30),
				less		=> '0',
				carryIn	=>	caOut29_2_caIn30,
				res		=> res_tmp(30),
				carryOut	=>	caOut30_2_caIn31,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
	ALU31	: alu_1bit_alu_msb
	port map(a			=> a(31),
				b			=> b(31),
				less		=> '0',
				carryIn	=>	caOut30_2_caIn31,
				res		=> res_tmp(31),
				set		=>	less31_2_less01,
				overflow	=> Overflow,
				Ainvert	=> ALUOp(3),
				Binvert	=>	ALUOp(2),
				Operation=> ALUOp(1 downto 0)); 
				
				
				
	Zero 	<= not( res_tmp(31) or
					  res_tmp(30) or
					  res_tmp(29) or
					  res_tmp(28) or
					  res_tmp(27) or
					  res_tmp(26) or
					  res_tmp(25) or
					  res_tmp(24) or
					  res_tmp(23) or
					  res_tmp(22) or
					  res_tmp(21) or
					  res_tmp(20) or
					  res_tmp(19) or
					  res_tmp(18) or
					  res_tmp(17) or
					  res_tmp(16) or
					  res_tmp(15) or
					  res_tmp(14) or
					  res_tmp(13) or
					  res_tmp(12) or
					  res_tmp(11) or
					  res_tmp(10) or
					  res_tmp(9) or
					  res_tmp(8) or
					  res_tmp(7) or
					  res_tmp(6) or
					  res_tmp(5) or
					  res_tmp(4) or
					  res_tmp(3) or
					  res_tmp(2) or
					  res_tmp(1) or
					  res_tmp(0));
			  
	res <= res_tmp;	  
		  
end Structure;