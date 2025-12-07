library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_phase_accumulator is
end tb_phase_accumulator;

architecture sim of tb_phase_accumulator is
    constant PHASE_ACC_SIZE: integer := 32;

    signal CLK: std_logic := '0';
    signal RST: std_logic := '0';
    signal PHASE_INC: std_logic_vector(PHASE_ACC_SIZE-1 downto 0) := (others => '0');
    signal SIN_OUT: std_logic_vector(15 downto 0);
    signal COS_OUT: std_logic_vector(15 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin
    DUT: entity work.carrier_generator
    generic map (
        phase_acc_size => PHASE_ACC_SIZE
    )
    port map (
        CLK => CLK,
        RST => RST,
        PHASE_INC => PHASE_INC,
        SIN_OUT => SIN_OUT,
        COS_OUT => COS_OUT
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

    reset_process: process
    begin
        rst <= '1';
        wait for clk_period * 3.5;
        rst <= '0';
        wait;
    end process reset_process;
    
    varying_phase_increment: process
    begin
        wait until rst = '0';
        PHASE_INC <= X"051EB852";
        wait for 5 us;
        PHASE_INC <= X"147AE148";
        wait;
    end process;
    
end sim;
