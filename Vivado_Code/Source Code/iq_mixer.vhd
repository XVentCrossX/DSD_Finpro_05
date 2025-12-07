library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity iq_mixer is
generic (
    phase_acc_size: integer := 32
);
Port ( 
    CLK: in std_logic;
    RST: in std_logic;
    INPUT_BITS: in std_logic_vector(1 downto 0);
    PHASE_INC: in std_logic_vector(phase_acc_size - 1 downto 0);
    I_MIX: out std_logic_vector(17 downto 0);
    Q_MIX: out std_logic_vector(17 downto 0)
);
end iq_mixer;

architecture Behavioral of iq_mixer is
    -- 2-bit signed × 16-bit signed = 18-bit signed result (max).
    signal I_mix_result: signed(17 downto 0) := (others => '0');
    signal Q_mix_result: signed(17 downto 0) := (others => '0');
    
    signal Q_SYMBOL: std_logic_vector(1 downto 0);
    signal I_SYMBOL: std_logic_vector(1 downto 0);
    
    SIGNAL Q_sine: std_logic_vector(15 downto 0);
    SIGNAL I_cos: std_logic_vector(15 downto 0);
    
    component carrier_generator
    generic (
        phase_acc_size: integer := 32
    );
    port (
        CLK: in  std_logic;
        RST: in  std_logic;
        PHASE_INC: in std_logic_vector(phase_acc_size - 1 downto 0);
        SIN_OUT: out std_logic_vector(15 downto 0);
        COS_OUT: out std_logic_vector(15 downto 0)
    );
    end component;
    
    component qpsk_mapper
    Port ( 
        input_bits: in std_logic_vector(1 downto 0);
        clk: in std_logic;
        rst: in std_logic;
        i_symbol: out std_logic_vector(1 downto 0);
        q_symbol: out std_logic_vector(1 downto 0)
    );
    end component;
begin
    u_qpsk_mapper: qpsk_mapper
    port map (
        input_bits => INPUT_BITS,
        clk => CLK,
        rst => RST,
        i_symbol => I_SYMBOL,
        q_symbol => Q_SYMBOL
    );
    
    u_carrier_generator: carrier_generator
    port map (
        CLK => CLK,
        RST => RST,
        PHASE_INC => PHASE_INC,
        SIN_OUT => Q_sine,
        COS_OUT => I_cos
    );
    
    process(CLK, RST)
    begin
        if RST = '1' then
            I_mix_result <= (others => '0');
            Q_mix_result <= (others => '0');
            I_MIX <= (others => '0');
            Q_MIX <= (others => '0');
        elsif (rising_edge(CLK)) then
            I_mix_result <= signed(I_SYMBOL) * signed(I_cos);
            Q_mix_result <= signed(Q_SYMBOL) * signed(Q_sine);
            
            I_MIX <= std_logic_vector(I_mix_result);
            Q_MIX <= std_logic_vector(Q_mix_result);
        end if;
    end process;
end Behavioral;
