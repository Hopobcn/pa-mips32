library ieee;
use ieee.std_logic_1164.all;

entity id_exe_reg is
	port (-- buses
			pc_up_in			:	in		std_logic_vector(31 downto 0);	
			pc_up_out		:	out	std_logic_vector(31 downto 0);	
			opcode_in		:	in		std_logic_vector(5 downto 0);		
			opcode_out		:	out	std_logic_vector(5 downto 0);	
			rs_in				:	in 	std_logic_vector(31 downto 0);	
			rs_out			:	out 	std_logic_vector(31 downto 0);	
			rt_in				:	in 	std_logic_vector(31 downto 0);	
			rt_out			:	out 	std_logic_vector(31 downto 0);
			sign_ext_in	 	:	in 	std_logic_vector(31 downto 0);	
			sign_ext_out 	:	out 	std_logic_vector(31 downto 0);
			zero_ext_in		:	in 	std_logic_vector(31 downto 0);	
			zero_ext_out	:	out 	std_logic_vector(31 downto 0);
			addr_rt_in		:	in 	std_logic_vector(4 downto 0);		
			addr_rt_out		:	out 	std_logic_vector(4 downto 0);	
			addr_rd_in		:	in 	std_logic_vector(4 downto 0);		
			addr_rd_out		:	out 	std_logic_vector(4 downto 0);	
			addr_jump_in	:	in		std_logic_vector(31 downto 0);	
			addr_jump_out	:	out	std_logic_vector(31 downto 0);	
			-- control signals
			RegWrite_in		:	in 	std_logic;									
			RegWrite_out	:	out 	std_logic;	
			Jump_in			:	in 	std_logic;							
			Jump_out			:	out 	std_logic;	
			Branch_in		:	in 	std_logic;								
			Branch_out		:	out 	std_logic;	
			MemRead_in		:	in 	std_logic;								 
			MemRead_out		:	out 	std_logic;	
			MemWrite_in		:	in 	std_logic;								 
			MemWrite_out	:	out 	std_logic;	
			ByteAddress_in	:  in 	std_logic;								
			ByteAddress_out:  out 	std_logic;	
			WordAddress_in	:	in		std_logic;						
			WordAddress_out:	out 	std_logic;	
			MemtoReg_in		:	in 	std_logic;							
			MemtoReg_out	:	out 	std_logic;	
			RegDst_in		:	in 	std_logic;
			RegDst_out		:	out 	std_logic;
			ALUOp_in			:	in 	std_logic_vector(2 downto 0);		
			ALUOp_out		:	out 	std_logic_vector(2 downto 0);		
			ALUSrc_in		:	in 	std_logic;			
			ALUSrc_out		:	out 	std_logic;	
			-- register control signals
			enable			:	in std_logic;
			clear    : in std_logic;
			clk				 :	in std_logic);
end id_exe_reg;

architecture Structure of id_exe_reg is


begin
	
	id_exe_register : process(clk)
	begin
		if (clear = '0' and enable = '1') then
			if (rising_edge(clk)) then
				pc_up_out		<=	pc_up_in;
				opcode_out		<=	opcode_in;
				rs_out			<= rs_in;
				rt_out			<= rt_in;
				sign_ext_out	<= sign_ext_in;
				zero_ext_out	<=	zero_ext_in;
				addr_rt_out		<=	addr_rt_in;
				addr_rd_out		<= addr_rd_in;
				addr_jump_out	<= addr_jump_in;
				RegWrite_out	<=	RegWrite_in;
				Jump_out			<=	Jump_in;
				Branch_out		<=	Branch_in;
				MemRead_out		<=	MemRead_in;
				MemWrite_out	<=	MemWrite_in;
				ByteAddress_out<=	ByteAddress_in;
				WordAddress_out<=	WordAddress_in;
				MemtoReg_out	<=	MemtoReg_in;
				RegDst_out		<=	RegDst_in;
				ALUOp_out		<=	ALUOp_in;
				ALUSrc_out		<=	ALUSrc_in;
			end if;
		elsif (clear = '1') then
		  if (rising_edge(clk)) then
  		    pc_up_out <= pc_up_in;
    		  opcode_out <= "000000";
    		  RegWrite_out <= '0';
    		  Jump_out <= '0';
    		  Branch_out <= '0';
    		  MemRead_out <= '0';
    		  MemWrite_out <= '0';
    		  MemtoReg_out <= '0';
    		  ALUOp_out <= "010";
		  end if;
		end if;
	end process;	
				
end Structure;