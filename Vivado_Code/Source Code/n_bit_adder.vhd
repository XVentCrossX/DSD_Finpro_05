library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity n_bit_adder is
generic (
    N : integer := 2
);
Port ( 
    a: in std_logic_vector(N - 1 downto 0);
    b: in std_logic_vector(N - 1 downto 0);
    carry_in: in std_logic;
    output: out std_logic_vector(N - 1 downto 0);
    carry_out: out std_logic
);
end n_bit_adder;

architecture Behavioral of n_bit_adder is 
    component full_adder
    Port ( 
        a: in std_logic;
        b: in std_logic;
        carry_in: in std_logic;
        output: out std_logic;
        carry_out: out std_logic
    );
    end component;
    
    SIGNAL c_int: std_logic_vector(N downto 0);
begin
    generate_fa: for i in 0 to N - 1 generate
        fa_i: full_adder port map (
            a => a(i),
            b => b(i),
            carry_in => c_int(i),
            output => output(i),
            carry_out => c_int(i + 1)
        );
    end generate;
    c_int(0) <= carry_in;
	carry_out <= c_int(N);
	
end Behavioral;
