library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

entity alu_shifter is
    port(   -- buses
            a           :   in std_logic_vector(31 downto 0);
            shamt       :   in std_logic_vector(31 downto 0);
            res     		:   out std_logic_vector(31 downto 0);
            -- control signals
            ALUOp       :   in  std_logic_vector(3 downto 0));
end alu_shifter;

architecture Structure of alu_shifter is

    -- Left barrel shift implementation
    signal lshift16     : std_logic_vector(31 downto 0);
    signal lshift8      : std_logic_vector(31 downto 0);
    signal lshift4      : std_logic_vector(31 downto 0);
    signal lshift2      : std_logic_vector(31 downto 0);
    signal lshift1      : std_logic_vector(31 downto 0);

    -- Right barrel shift implementation
    signal rshift16     : std_logic_vector(31 downto 0);
    signal rshift8      : std_logic_vector(31 downto 0);
    signal rshift4      : std_logic_vector(31 downto 0);
    signal rshift2      : std_logic_vector(31 downto 0);
    signal rshift1      : std_logic_vector(31 downto 0);

    -- For sign-extending (arithmetic right shift)
    signal sign         : std_logic;

begin
    lshift16 <= a(15 downto 0) 			& "0000000000000000" when shamt(4) = '1' else
                a;
    lshift8  <= lshift16(23 downto 0) 	& "00000000" 			when shamt(3) = '1' else
                lshift16;
    lshift4  <= lshift8(27 downto 0) 	& "0000" 				when shamt(2) = '1' else
                lshift8;
    lshift2  <= lshift4(29 downto 0) 	& "00" 					when shamt(1) = '1' else
                lshift4;
    lshift1  <= lshift2(30 downto 0) 	& "0" 					when shamt(0) = '1' else
                lshift2;

    sign <= '0'   when ALUOp = "0100" else --srl is logic
            a(31) when ALUop = "0101" else --sra is arithmetic
            '-';

    rshift16 <= sign & sign & sign & sign & sign & sign & sign & sign &
                sign & sign & sign & sign & sign & sign & sign & sign & a(15 downto 0) 			when shamt(4) = '1' else
                a;
    rshift8  <= sign & sign & sign & sign & sign & sign & sign & sign & rshift16(23 downto 0)	when shamt(3) = '1' else
                rshift16;
    rshift4  <= sign & sign & sign & sign 									 & rshift8(27 downto 0) 	when shamt(2) = '1' else
                rshift8;
    rshift2  <= sign & sign 														 & rshift4(29 downto 0) 	when shamt(1) = '1' else
                rshift4;
    rshift1  <= sign 																 & rshift2(30 downto 0) 	when shamt(0) = '1' else
                rshift2;

    res <= lshift1 when ALUop = "0011" else --sll
           rshift1 when ALUop = "0100" else --srl
           rshift1 when ALUop = "0101"; 	  --sra

end Structure;
