library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity phase_accum is
    generic (
        phase_acc_size: integer := 32
    );
    port (
        CLK: in  std_logic;
        RST: in  std_logic;
        PHASE_INC: in std_logic_vector(phase_acc_size - 1 downto 0);
        PHASE: out std_logic_vector(phase_acc_size - 1 downto 0)
    );
end phase_accum;

architecture Behavioral of phase_accum is
    signal phase_reg: unsigned(phase_acc_size - 1 downto 0) := (others => '0');
begin
    process (CLK, RST)
    begin
        if (RST = '1') then
            PHASE_reg <= (others => '0');
            PHASE <= (others => '0');
        elsif (rising_edge(CLK)) then
            phase_reg <= phase_reg + unsigned(PHASE_INC); 
            PHASE <= std_logic_vector(phase_reg);  
        end if;
    end process;
end Behavioral;
