library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
Port ( 
    a: in std_logic;
    b: in std_logic;
    carry_in: in std_logic;
    output: out std_logic;
    carry_out: out std_logic
);
end full_adder;

architecture Behavioral of full_adder is
begin
    output <= a xor b xor carry_in; 
    carry_out <= (a and b) or (b and carry_in) or (carry_in and a);
end Behavioral;
