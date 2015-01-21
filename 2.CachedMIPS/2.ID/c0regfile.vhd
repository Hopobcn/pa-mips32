Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity c0regfile is
    port (clk		          :	  in  std_logic;
          addr_read         :	  in  std_logic_vector(4 downto 0);   --! Read address
          reg_read          :	  out	std_logic_vector(31 downto 0); --! Register data for the read operation
          addr_write        :   in  std_logic_vector(4 downto 0);  --! Write address
          reg_write         :   in  std_logic_vector(31 downto 0);  --! Register data for the write operation
          RegWrite          :   in  std_logic;                      --! Enable Write for the write port
          BadVAddr_reg      :   in  std_logic_vector(31 downto 0);  --! Direct input of the BadVAddr register (#8)
          BadVAddr_w        :   in  std_logic;                      --! Enable Write flag for the BadVAddr register
          Status_reg        :   in  std_logic_vector(31 downto 0);  --! Direct input of the Status register (#12)
          Status_w          :   in  std_logic;                      --! Enable Write flag for the Status register
          Cause_reg         :   in  std_logic_vector(31 downto 0);  --! Direct input for the Cause register (#13)
          Cause_w           :   in  std_logic;                      --! Enable Write flag for the Cause register
          EPC_reg           :   in  std_logic_vector(31 downto 0);  --! Direct input for the EPC  register (#14)
          EPC_w             :   in  std_logic);                     --! Enable Write flag for the EPC register
end c0regfile;

-- pag.A-33 coprocessor 0 registers
architecture Structure of c0regfile is
    type REGISTER_BLOCK is array (2**5-1 downto 0) of std_logic_vector(31 downto 0);
    signal reg : REGISTER_BLOCK;
begin

    -- Immediate read operation
    reg_read <= reg(to_integer(unsigned(addr_read)));

    register_file_write : process(clk)
    begin
        if (falling_edge(clk)) then
		  -- Undefined Behaviour if RegWrite is 1 and a conflicting enable is active too
            if (RegWrite = '1') then
                reg(to_integer(unsigned(addr_write))) <= reg_write;
            end if;

            if (BadVAddr_w = '1') then
                reg(8) <= BadVAddr_reg; 
            end if;

            if (Status_w = '1') then
                reg(12) <= Status_reg;
            end if;

            if (Cause_w = '1') then
                reg(13) <= Cause_reg;
            end if;

            if (EPC_w = '1') then
                reg(14) <= EPC_reg;
            end if;
        end if;
    end process register_file_write;    
    
end Structure;
            
