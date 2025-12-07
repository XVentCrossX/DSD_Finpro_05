LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity tb_qpsk_mapper is
end tb_qpsk_mapper;

architecture tb of tb_qpsk_mapper is
    signal input_bits : std_logic_vector(1 downto 0);
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal i_symbol   : std_logic_vector(1 downto 0);
    signal q_symbol   : std_logic_vector(1 downto 0);

begin
    DUT: entity work.qpsk_mapper
        port map (
            input_bits => input_bits,
            clk        => clk,
            rst        => rst,
            i_symbol   => i_symbol,
            q_symbol   => q_symbol
        );
        
    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    input_bit_pairs : process
    begin
        rst <= '1';
        input_bits <= "00";
        wait for 20 ns;
        rst <= '0';

        -- testing all constellations
        wait for 10 ns; input_bits <= "00";  -- (+1, +j)
        wait for 10 ns; input_bits <= "01";  -- (-1, +j)
        wait for 10 ns; input_bits <= "10";  -- (+1, -j)
        wait for 10 ns; input_bits <= "11";  -- (-1, -j)

        wait for 50 ns;
    end process;

end tb;
