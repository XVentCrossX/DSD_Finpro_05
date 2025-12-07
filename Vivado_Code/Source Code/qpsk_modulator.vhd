library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity qpsk_modulator is
generic (
    phase_acc_size: integer := 32
);
port (
    INPUT_STREAM: in  std_logic_vector(1 downto 0); 
    CLK: in std_logic;
    RST: in std_logic;
    PHASE_INC: in std_logic_vector(phase_acc_size - 1 downto 0);
    I_MIX: out std_logic_vector(17 downto 0);
    Q_MIX: out std_logic_vector(17 downto 0);
    MODULATED_SIGNAL: out std_logic_vector(17 downto 0)
);
end qpsk_modulator;
  
architecture Behavioral of qpsk_modulator is
    component n_bit_adder
    generic (
        N : integer := 18
    );
    Port ( 
        a: in std_logic_vector(N - 1 downto 0);
        b: in std_logic_vector(N - 1 downto 0);
        carry_in: in std_logic;
        output: out std_logic_vector(N - 1 downto 0);
        carry_out: out std_logic
    );
    end component;
    
    component iq_mixer
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
    end component;
    
    signal I_SIGNAL: std_logic_vector(17 downto 0) := (others => '0');
    signal Q_SIGNAL: std_logic_vector(17 downto 0) := (others => '0');
    signal adder_result: std_logic_vector(17 downto 0) := (others => '0');
    signal carry: std_logic;
begin
    u_iq_mixer: iq_mixer port map (
        CLK => CLK,
        RST => RST,
        INPUT_BITS => INPUT_STREAM,
        PHASE_INC => PHASE_INC,
        I_MIX => I_SIGNAL,
        Q_MIX => Q_SIGNAL
    );
    
    u_n_bit_adder: n_bit_adder port map (
        a => I_SIGNAL,
        b => Q_SIGNAL,
        carry_in => '0',
        output => MODULATED_SIGNAL,
        carry_out => carry
    );
    I_MIX <= I_SIGNAL;
    Q_MIX <= Q_SIGNAL;
end Behavioral;
