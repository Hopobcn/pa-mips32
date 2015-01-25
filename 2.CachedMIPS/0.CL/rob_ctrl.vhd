library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rob_ctrl is
    port (clk : in std_logic;
      boot : in std_logic;

      -- The exception flag, for a certain exception operation
      except_flag : in std_logic;
      except_addr : in std_logic_vector(2 downto 0);

		-- 2 WRITE PORTS to allow this:
		--   LOAD :  F D E L C    Wrob   <- Write from cache
		--   arit      F D E Wrob 
		--   arit        F D E    Wrob   <- write from ALU
		
      -- FIRST PORT
      value_flag_exe   : in std_logic;
      value_robid_exe  : in std_logic_vector(2 downto 0);
      value_alu        : in std_logic_vector(31 downto 0); -- Value from alu when commiting an Aritmetic operation
      value_to_store   : in std_logic_vector(31 downto 0); -- Value to be stored in cache/mem

		-- SECOND PORT
		value_flag_cache  : in std_logic;
		value_robid_cache : in std_logic_vector(2 downto 0);
      value_cache       : in std_logic_vector(31 downto 0);  -- Value from Cache when commiting a LOAD operation 

      -- To-RegisterFile signals
      rf_write   : out std_logic;
      rf_addr    : out std_logic_vector(4 downto 0);   
      rf_val     : out std_logic_vector(31 downto 0);
      
      -- Rewind because a branch is taken
      rewind_cause_branch  : in std_logic;

      -- To-L-C {cache/mem}
      mem_addr_store : out std_logic_vector(31 downto 0);
      mem_val_store  : out std_logic_vector(31 downto 0);
      mem_store      : out std_logic;
      MemComplete    : in std_logic;

      -- New entries (from decode stage)
      newentry_flag  : in std_logic; -- UB if using this while full
      newentry_store : in std_logic;
      newentry_load  : in std_logic; -- mutually exclusive with store
      newentry_regaddr : in std_logic_vector(5 downto 0);
      -- To Foward Control: We must pick the youngest instruction in ROB in order to forward the correct data
      robRegisterRd0        : out  std_logic_vector(5 downto 0);  --producer ROB entrada 0 
      robRegisterRd1        : out  std_logic_vector(5 downto 0);  --producer ROB entrada 1 
      robRegisterRd2        : out  std_logic_vector(5 downto 0);  --producer ROB entrada 2 
      robRegisterRd3        : out  std_logic_vector(5 downto 0);  --producer ROB entrada 3 
      robRegisterRd4        : out  std_logic_vector(5 downto 0);  --producer ROB entrada 4 
      robRegisterRd5        : out  std_logic_vector(5 downto 0);  --producer ROB entrada 5 
      robRegisterRd6        : out  std_logic_vector(5 downto 0);  --producer ROB entrada 6 
      robRegisterRd7        : out  std_logic_vector(5 downto 0);  --producer ROB entrada 7 
		robMatchIdRs_in       : in std_logic_vector(2 downto 0);
		robMatchIdRt_in       : in std_logic_vector(2 downto 0);
		robMatchIdRt_mem_in   : in std_logic_vector(2 downto 0);
		robRegWrite0          : out  std_logic;                     -- RegWrite = ValidBit (we supouse all positions in rob to write in Regfile, maybe this is not true for Stores)!!
		robRegWrite1          : out  std_logic;
		robRegWrite2          : out  std_logic;
		robRegWrite3          : out  std_logic;
		robRegWrite4          : out  std_logic;
		robRegWrite5          : out  std_logic;
		robRegWrite6          : out  std_logic;
		robRegWrite7          : out  std_logic;
      fwd_path_rob_rs       : out std_logic_vector(31 downto 0); 
		fwd_path_rob_rt       : out std_logic_vector(31 downto 0);
		fwd_path_rob_rt_mem   : out std_logic_vector(31 downto 0);
		-- To Hazard Control: Tell Hazard controll that we have a match (CAM array implemented here not in Hazard_ctrl)
		robLoadStoreDep       : out std_logic; -- To Hazard_ctrl
		lookup_load_addr      : in  std_logic_vector(31 downto 0); -- Addres of a load in Lookup stage
		
		FreeSlot  : in std_logic; -- From LOOKUP stage. (1: L stage can be populated with an Store, 0: otherwise)
		
      ready : out std_logic;  -- If head == tail and !empty, then we are full
      tail  : out std_logic_vector(2 downto 0)
      );
end rob_ctrl;

architecture Structure of rob_ctrl is
    type ROB_DATA is array (7 downto 0) of std_logic_vector(107 downto 0);
    -- *** Data inside the structure (each std_logic_Vector) ***
    -- Bit 107 ValidData
    -- Bit 106 WorkInProgress
    -- Bit 105 ReadyToMem
    -- Bit 104 Exception
    -- Bit 103 Load flag
    -- Bit 102 Store flag
    -- Bits 101..96 Register address
    -- Bits 95..64 PC
    -- Bits 63..32 Memory location (for loads/stores)
    -- Bits 31..0 Value to store
    signal data : ROB_DATA;

    signal i_head : std_logic_vector(2 downto 0);
    signal i_tail : std_logic_vector(2 downto 0);

    signal did_push : std_logic;
    signal did_pop  : std_logic;
    signal keep_empty : std_logic; 
    
	 signal  rob_addr_store0       :  std_logic_vector(31 downto 0); -- @ Load/Store entrada 0
	 signal	rob_addr_store1       :  std_logic_vector(31 downto 0);
	 signal	rob_addr_store2       :  std_logic_vector(31 downto 0);
	 signal	rob_addr_store3       :  std_logic_vector(31 downto 0);
	 signal	rob_addr_store4       :  std_logic_vector(31 downto 0);
	 signal	rob_addr_store5       :  std_logic_vector(31 downto 0);
	 signal	rob_addr_store6       :  std_logic_vector(31 downto 0);
	 signal	rob_addr_store7       :  std_logic_vector(31 downto 0);
	 signal	robStoreFlag0         :  std_logic;                     -- StoreFlag = ValidBid AND Store_Flag 
	 signal	robStoreFlag1         :  std_logic;
	 signal	robStoreFlag2         :  std_logic;
	 signal	robStoreFlag3         :  std_logic;
	 signal	robStoreFlag4         :  std_logic;
	 signal	robStoreFlag5         :  std_logic;
	 signal	robStoreFlag6         :  std_logic;
	 signal	robStoreFlag7         :  std_logic;
	 signal  MemOpInProgress       :  std_logic;
begin

    robRegisterRd0    <= data(0)(101 downto 96);
    robRegisterRd1    <= data(1)(101 downto 96);
    robRegisterRd2    <= data(2)(101 downto 96);
    robRegisterRd3    <= data(3)(101 downto 96);
    robRegisterRd4    <= data(4)(101 downto 96);
    robRegisterRd5    <= data(5)(101 downto 96);
    robRegisterRd6    <= data(6)(101 downto 96);
    robRegisterRd7    <= data(7)(101 downto 96);
	 
    robRegWrite0      <= '1' when data(0)(107) = '1' else
	                      '0';
    robRegWrite1      <= '1' when data(1)(107) = '1' else
	                      '0';
    robRegWrite2      <= '1' when data(2)(107) = '1' else
	                      '0';
    robRegWrite3      <= '1' when data(3)(107) = '1' else
	                      '0';
    robRegWrite4      <= '1' when data(4)(107) = '1' else
	                      '0';
    robRegWrite5      <= '1' when data(5)(107) = '1' else
	                      '0';
    robRegWrite6      <= '1' when data(6)(107) = '1' else
	                      '0';
    robRegWrite7      <= '1' when data(7)(107) = '1' else
	                      '0';
		
	 
    fwd_path_rob_rs     <= data(to_integer(unsigned(robMatchIdRs_in)))(31 downto 0);
    fwd_path_rob_rt     <= data(to_integer(unsigned(robMatchIdRt_in)))(31 downto 0);
    fwd_path_rob_rt_mem <= data(to_integer(unsigned(robMatchIdRt_mem_in)))(31 downto 0);


	 rob_addr_store0 <= data(0)(63 downto 32);
	 rob_addr_store1 <= data(0)(63 downto 32);
	 rob_addr_store2 <= data(0)(63 downto 32);
	 rob_addr_store3 <= data(0)(63 downto 32);
	 rob_addr_store4 <= data(0)(63 downto 32);
	 rob_addr_store5 <= data(0)(63 downto 32);
	 rob_addr_store6 <= data(0)(63 downto 32);
	 rob_addr_store7 <= data(0)(63 downto 32);
	 
	 robStoreFlag0    <= '1' when data(0)(107) = '1' and data(0)(102) = '1' else
	                     '0';
	 robStoreFlag1    <= '1' when data(0)(107) = '1' and data(0)(102) = '1' else
	                     '0';
	 robStoreFlag2    <= '1' when data(0)(107) = '1' and data(0)(102) = '1' else
	                     '0';
	 robStoreFlag3    <= '1' when data(0)(107) = '1' and data(0)(102) = '1' else
	                     '0';
	 robStoreFlag4    <= '1' when data(0)(107) = '1' and data(0)(102) = '1' else
	                     '0';
	 robStoreFlag5    <= '1' when data(0)(107) = '1' and data(0)(102) = '1' else
	                     '0';
	 robStoreFlag6    <= '1' when data(0)(107) = '1' and data(0)(102) = '1' else
	                     '0';
	 robStoreFlag7    <= '1' when data(0)(107) = '1' and data(0)(102) = '1' else
	                     '0';
    -- CAM:
	 robLoadStoreDep <= '1' when ((robStoreFlag0 = '1' and lookup_load_addr = rob_addr_store0) or
	                              (robStoreFlag1 = '1' and lookup_load_addr = rob_addr_store1) or 
	                              (robStoreFlag2 = '1' and lookup_load_addr = rob_addr_store2) or 
	                              (robStoreFlag3 = '1' and lookup_load_addr = rob_addr_store3) or 
	                              (robStoreFlag4 = '1' and lookup_load_addr = rob_addr_store4) or 
	                              (robStoreFlag5 = '1' and lookup_load_addr = rob_addr_store5) or 
	                              (robStoreFlag6 = '1' and lookup_load_addr = rob_addr_store6) or 
	                              (robStoreFlag7 = '1' and lookup_load_addr = rob_addr_store7)) else
							  '0';	
	 
	 
    -- Do logic on clk edge
    basic_logic : process(clk, boot)
    begin
        if (rising_edge(clk)) then
            if (boot = '1') then
                i_head <= "000";
                i_tail <= "000";
                keep_empty <= '1';
                rf_write <= '0';
                data(0)(107 downto 0) <= (others => '0'); -- Valid bit to 0
                data(0)(99 downto 68) <= x"DABBAD00";
            else
                if (did_pop = '1' AND i_head = i_tail) then
                    keep_empty <= '1';
                end if;
          
                did_push <= '0';
                did_pop  <= '0';
          
                if (except_flag = '1') then
                    data(to_integer(unsigned(except_addr)))(104) <= '1';
                end if;
          
                -- Wrob first-port (Aritmetic operations(value) and LOAD/STORE(for @))
                if (value_flag_exe = '1' AND rewind_cause_branch = '0') then
                    if (data(to_integer(unsigned(value_robid_exe)))(102) = '1' OR    -- Store 
                        data(to_integer(unsigned(value_robid_exe)))(103) = '1') then -- Load
                        data(to_integer(unsigned(value_robid_exe)))(63 downto 32) <= value_alu;    -- STORES/LOADS this is the @
                        data(to_integer(unsigned(value_robid_exe)))(31 downto 0)  <= value_to_store; -- STORES Value to be stored in memory
                        data(to_integer(unsigned(value_robid_exe)))(105)         <= '1';           -- ReadyToMem
                    else
                        data(to_integer(unsigned(value_robid_exe)))(31 downto 0) <= value_alu;     -- Value from EXE (for non LOAD/STORE inst)
                        data(to_integer(unsigned(value_robid_exe)))(107)         <= '1';           -- value ready
                    end if;
                end if;
          
                -- Wrob second-port (LOAD value)
                if (value_flag_cache = '1') then  --even when rewind bit is 1
                    if (data(to_integer(unsigned(value_robid_cache)))(103) = '1') then -- Load
                        data(to_integer(unsigned(value_robid_cache)))(31 downto 0) <= value_cache; -- LOADS this is the value
                        data(to_integer(unsigned(value_robid_cache)))(107)         <= '1';       -- value ready
                        end if;
                end if;
                     
                -- Wregfile
                -- Here, the commit-to-register-file part
                if (data(to_integer(unsigned(i_head)))(102) = '1' and 
                    data(to_integer(unsigned(i_head)))(105) = '1') then --STORE and Ready
                    data(to_integer(unsigned(i_head)))(107) <= '1';
                    
                end if;
                
                    -- the regular "valid" ROB operation
                if (data(to_integer(unsigned(i_head)))(107) = '1' or
                    -- consider the STORE and ready scenario
                    (data(to_integer(unsigned(i_head)))(102) = '1' and 
                    data(to_integer(unsigned(i_head)))(105) = '1')) then
                        -- if 'Instruction has been commited'
                    if (data(to_integer(unsigned(i_head)))(102) = '0') then
                        -- proceed to commit a value to the register file
                        rf_write <= '1';
                        rf_addr  <= data(to_integer(unsigned(i_head)))(100 downto 96); -- ignoring bit '5' of a regular rf_addr
                        rf_val   <= data(to_integer(unsigned(i_head)))(31 downto 0);

                        data(to_integer(unsigned(i_head)))(107 downto 0)  <= (others => '0');
                        data(to_integer(unsigned(i_head)))(99 downto 68) <= x"DEADBEEF";
                        did_pop <= '1';
                        keep_empty <= '1';
						  
                        i_head   <= std_logic_vector(unsigned(i_head) + 1);
                    else  -- STORE
                        -- proceed to write into cache/mem
                        if (FreeSlot = '1') then
                            mem_store      <= '1'; 
                            MemOpInProgress <= '1';
                        end if;
								if (memOpInProgress = '1') then
                            mem_store      <= '1'; 
                            mem_addr_store <= data(to_integer(unsigned(i_head)))(63 downto 32);
                            mem_val_store  <= data(to_integer(unsigned(i_head)))(31 downto 0);
								end if;
                        if (MemComplete = '1') then -- we should also check that didn't produce an exception
                            data(to_integer(unsigned(i_head)))(107 downto 0)  <= (others => '0');
                            data(to_integer(unsigned(i_head)))(99 downto 68) <= x"DEADBEEF";
                            did_pop <= '1';
                            keep_empty <= '1';
						  
                            i_head   <= std_logic_vector(unsigned(i_head) + 1);
                        end if;
                    end if;
                else
                    rf_write <= '0';
                    mem_store <= '0';
                    MemOpInProgress <= '0';
                end if;
  
                -- Here, the add-a-member part
                if (newentry_flag = '1' AND rewind_cause_branch = '0') then
                    data(to_integer(unsigned(i_tail)))(107 downto 0)  <= (others => '0');
                    data(to_integer(unsigned(i_tail)))(101 downto 96) <= newentry_regaddr;
                    data(to_integer(unsigned(i_tail)))(106)           <= '1';
                    data(to_integer(unsigned(i_tail)))(102)           <= newentry_store;
                    data(to_integer(unsigned(i_tail)))(103)           <= newentry_load;
                    i_tail <= std_logic_vector(unsigned(i_tail) + 1 );
                    did_push <= '1';
                    keep_empty <= '0';
                end if;
                
                -- If a branch is taken, then an instruction is fixed
                if (rewind_cause_branch = '1' AND data(to_integer(unsigned(i_tail)-1))(106) = '1') then
                    data(to_integer(unsigned(i_tail)-1))(107 downto 0) <= (others => '0');
                    data(to_integer(unsigned(i_tail)-1))(99 downto 68) <= x"BAADF00D";
                    i_tail <= std_logic_vector(unsigned(i_tail) - 1 );
                end if;
            end if;
        end if;
    end process;
    
    ready <= '1' when i_head /= i_tail else
             '1' when keep_empty = '1' else
             '0';

    tail <= i_tail;
end Structure;
