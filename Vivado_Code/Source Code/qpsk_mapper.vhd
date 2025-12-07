library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity qpsk_mapper is
    port(
        CLK     : in  std_logic;
        RST     : in  std_logic;
        INPUT_BITS : in  std_logic_vector(1 downto 0);
        I_OUT   : out signed(1 downto 0);
        Q_OUT   : out signed(1 downto 0)
    );
end qpsk_mapper;

architecture Behavioral of qpsk_mapper is
    signal I_reg : signed(1 downto 0);
    signal Q_reg : signed(1 downto 0);
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            I_reg <= (others => '0');
            Q_reg <= (others => '0');
        elsif rising_edge(CLK) then
            case INPUT_BITS is
                when "00" =>
                    I_reg <= to_signed(1,2);
                    Q_reg <= to_signed(1,2);
                when "01" =>
                    I_reg <= to_signed(-1,2);
                    Q_reg <= to_signed(1,2);
                when "11" =>
                    I_reg <= to_signed(-1,2);
                    Q_reg <= to_signed(-1,2);
                when "10" =>
                    I_reg <= to_signed(1,2);
                    Q_reg <= to_signed(-1,2);
                when others =>
                    I_reg <= (others => '0');
                    Q_reg <= (others => '0');
            end case;
        end if;
    end process;

    I_OUT <= I_reg;
    Q_OUT <= Q_reg;
end Behavioral;
