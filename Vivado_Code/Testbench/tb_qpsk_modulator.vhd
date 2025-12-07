library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_qpsk_modulator is
end tb_qpsk_modulator;

architecture sim of tb_qpsk_modulator is
    constant PHASE_ACC_SIZE: integer := 32;
    constant CLK_PERIOD: time := 10 ns;    
    
    signal CLK: std_logic := '0';
    signal RST: std_logic := '0';
    signal INPUT_STREAM: std_logic_vector(1 downto 0) := "00";
    signal PHASE_INC: std_logic_vector(PHASE_ACC_SIZE-1 downto 0) := (others => '0');
    signal MODULATED_SIGNAL: std_logic_vector(17 downto 0);    
begin
    DUT: entity work.qpsk_modulator
    generic map (
        phase_acc_size => PHASE_ACC_SIZE
    )
    port map (
        INPUT_STREAM => INPUT_STREAM,
        CLK => CLK,
        RST => RST,
        PHASE_INC => PHASE_INC,
        MODULATED_SIGNAL => MODULATED_SIGNAL
    );

    CLK_process: process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD/2;
            CLK <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    rst_process: process
    begin
        RST <= '1';
        wait for 10*CLK_PERIOD;
        RST <= '0';
        wait;
    end process;

    input_process: process
    begin
        PHASE_INC <= X"147AE148";
        wait until RST = '0';
        for i in 0 to 100 loop
            wait until rising_edge(CLK);
            INPUT_STREAM <= "00";
            wait for 60*CLK_PERIOD;
        
            INPUT_STREAM <= "01";
            wait for 60*CLK_PERIOD;
        
            wait until rising_edge(CLK);
            INPUT_STREAM <= "10";
            wait for 60*CLK_PERIOD;
        
            wait until rising_edge(CLK);
            INPUT_STREAM <= "11";
            wait for 60*CLK_PERIOD;
            
         end loop;
    wait;
    end process;

end sim;
