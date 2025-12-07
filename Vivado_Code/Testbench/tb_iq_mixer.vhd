library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_iq_mixer is
end tb_iq_mixer;

architecture sim of tb_iq_mixer is
    constant PHASE_ACC_SIZE: integer := 32;
    signal CLK: std_logic := '0';
    signal RST: std_logic := '0';
    signal INPUT_BITS: std_logic_vector(1 downto 0) := "01";
    signal PHASE_INC: std_logic_vector(PHASE_ACC_SIZE-1 downto 0) := (others => '0');
    signal I_MIX: std_logic_vector(17 downto 0);
    signal Q_MIX: std_logic_vector(17 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin
    DUT: entity work.iq_mixer
    generic map (
        phase_acc_size => PHASE_ACC_SIZE
    )
    port map (
        CLK => CLK,
        RST => RST,
        INPUT_BITS => INPUT_BITS,
        PHASE_INC => PHASE_INC,
        I_MIX => I_MIX,
        Q_MIX => Q_MIX
    );

    clk_process : process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD/2;
            CLK <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    rst_process : process
    begin
        RST <= '1';
        wait for 3 * CLK_PERIOD;
        RST <= '0';
        wait;
    end process;

    test_symbols_process : process
    begin
        PHASE_INC <= X"147AE148";
        
        wait until RST = '0';
        INPUT_BITS <= "01";
        wait for 500 ns;

        INPUT_BITS <= "11";
        wait for 500 ns;

        INPUT_BITS <= "10";
        wait for 500 ns;
        
        INPUT_BITS <= "00";
        wait for 500 ns;
        wait;
    end process;
end sim;
