LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- CONSTELLATION
-- INPUT BITS | OUTPUT SYMBOLS
--     00     | (+1, +j)
--     01     | (-1, +j)
--     10     | (+1, -j)
--     11     | (-1, -j)

entity qpsk_mapper is
Port ( 
    input_bits: in std_logic_vector(1 downto 0);
    clk: in std_logic;
    rst: in std_logic;
    i_symbol: out std_logic_vector(1 downto 0);
    q_symbol: out std_logic_vector(1 downto 0)
);
end qpsk_mapper;

architecture Behavioral of qpsk_mapper is
begin
    process (clk, rst)
    begin
        if (rst = '1') then
            i_symbol <= (others => '0');
            q_symbol <= (others => '0');
        elsif (rising_edge(clk)) then
            -- First bit will be the sign bit
            case input_bits is
                when "00" => 
                    i_symbol <= "01";
                    q_symbol <= "01";
                when "01" =>
                    i_symbol <= "11";
                    q_symbol <= "01";
                when "10" =>
                    i_symbol <= "01";
                    q_symbol <= "11";
                when "11" =>
                    i_symbol <= "11";
                    q_symbol <= "11";
                when others =>
                    i_symbol <= "00";
                    q_symbol <= "00";
            end case;    
        end if;
    end process;
end Behavioral;
