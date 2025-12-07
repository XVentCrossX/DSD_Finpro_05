library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL;

library std;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_cordic_sin_cos is
end tb_cordic_sin_cos;

architecture testbench of tb_cordic_sin_cos is
    file results_file: text open write_mode is "output.txt";
    constant output_size: integer := 16;
    constant phase_acc_size: integer := 32;

    signal clk: std_logic := '0';
    signal rst: std_logic := '1';
    signal angle: std_logic_vector(phase_acc_size - 1 downto 0) := (others => '0');
    signal sine: std_logic_vector(15 downto 0);
    signal cosine: std_logic_vector(15 downto 0);

    constant clk_period : time := 1 ns;
    
begin
    
    uut: entity work.cordic_sin_cos
        generic map (
            phase_acc_size => phase_acc_size
        )
        port map (
            CLK => clk,
            RST => rst,
            ANGLE => angle,
            sin_out => sine,
            cos_out => cosine
        );

    clk_gen: process
    begin
        while True loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    rst_process: process
    begin
        rst <= '1';
        wait for clk_period * 3.5;
        rst <= '0';
        wait;
    end process;


    angle_gen : process(clk, rst)
    begin
        if rst = '1' then
            angle <= (others => '0');
        elsif rising_edge(clk) then
            angle <= std_logic_vector(unsigned(angle) + 10000000);
        end if;
    end process;
    
    report_output: process
        variable lin: line;
        variable angle_i: integer;
        variable sin_i: integer;
        variable cos_i: integer;
        variable angle_real: real;
    begin
        wait until rst = '0';
        wait until (signed(sine) /= 0 or signed(cosine) /= 0);
        
        while true loop
            angle_real := real(to_integer(unsigned(angle(31 downto 16)))) * 65536.0
                          + real(to_integer(unsigned(angle(15 downto 0))));
                sin_i   := to_integer(signed(sine));
                cos_i   := to_integer(signed(cosine));
        
                lin := null;
                write(lin, string'("ANGLE="));
                write(lin, real'image(angle_real));
                write(lin, string'("   SIN="));
                write(lin, integer'image(sin_i));
                write(lin, string'("   COS="));
                write(lin, integer'image(cos_i));
                writeline(results_file, lin);
        
                wait for 1 ns;
        end loop;
    end process;
end testbench;
