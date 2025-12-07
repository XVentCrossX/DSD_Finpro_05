library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity carrier_generator is
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
end carrier_generator;

architecture behavioral of carrier_generator is
    signal phase_reg: std_logic_vector(phase_acc_size - 1 downto 0);
    constant output_width : integer := 16;
    
    component phase_accum
    generic (
        phase_acc_size: integer := 32
    );
    port (
        CLK: in  std_logic;
        RST: in  std_logic;
        PHASE_INC: in std_logic_vector(phase_acc_size - 1 downto 0);
        PHASE: out std_logic_vector(phase_acc_size - 1 downto 0)
    );
    end component;
    
    component cordic_sin_cos
    generic (
        phase_acc_size: integer := 32
    );
    Port (
        CLK: in std_logic;
        RST: in std_logic;
        ANGLE: in std_logic_vector(phase_acc_size - 1 downto 0);
        SIN_OUT: out std_logic_vector(15 downto 0);
        COS_OUT: out std_logic_vector(15 downto 0)
    );
    end component;
begin
    cordic_module: cordic_sin_cos
    port map (
        CLK => CLK,
        RST => RST,
        ANGLE => phase_reg,
        SIN_OUT => SIN_OUT,
        COS_OUT => COS_OUT
    );
    
    phase_accumulator: phase_accum
    port map (
        CLK => CLK,
        RST => RST,
        PHASE_INC => PHASE_INC,
        PHASE => phase_reg
    );
end behavioral;
