-- The cordic algorithm has a gain of approximately 1.646760258
-- For 16-bit signed output, the maximum value is 2^15 - 1
-- To scale the CORDIC output so it fits perfectly in 16 bits,
-- The Gain value will be scaled to (2^15 - 1)/(1.646760258) = 0x4DB7

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity cordic_sin_cos is
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
end cordic_sin_cos;

architecture Behavioral of cordic_sin_cos is
    constant OUTPUT_BITS : integer := 16;
    constant LUT_width: integer := 32;
    constant LUT_depth: integer := 31;

    -- LOOKUP TABLE OF THE SPECIAL ANGLES
    type atan_table_array is array (0 to LUT_depth - 1) of signed(LUT_width - 1 downto 0);
    constant atan: atan_table_array := (
        X"20000000",
        X"12E4051E",
        X"09FB385B",
        X"051111D4",
        X"028B0D43",
        X"0145D7E1",
        X"00A2F61E",
        X"00517C55",
        X"0028BE53",
        X"00145F2F",
        X"000A2F98",
        X"000517CC",
        X"00028BE6",
        X"000145F3",
        X"0000A2FA",
        X"0000517D",
        X"000028BE",
        X"0000145F",
        X"00000A30",
        X"00000518",
        X"0000028C",
        X"00000146",
        X"000000A3",
        X"00000051",
        X"00000029",
        X"00000014",
        X"0000000A",
        X"00000005",
        X"00000003",
        X"00000001",
        X"00000000"
    );
    
    type xy is array (0 to OUTPUT_BITS - 1) of signed(OUTPUT_BITS downto 0);
    signal x, y: xy := (others => (others => '0'));
    
    type z_array is array (0 to OUTPUT_BITS - 1) of signed(phase_acc_size - 1 downto 0);
    signal z: z_array := (others => (others => '0'));
    
    signal initial_x: signed(OUTPUT_BITS downto 0);
    signal initial_y: signed(OUTPUT_BITS downto 0);
    signal initial_z: signed(phase_acc_size - 1 downto 0);
    signal quadrant: std_logic_vector(1 downto 0);
    
    constant GAIN: signed(OUTPUT_BITS downto 0) := signed(std_logic_vector('0' & std_logic_vector'(X"4DB7")));

begin
    -- Extract quadrant bits from the first two bits of the angle input
    quadrant <= ANGLE(phase_acc_size - 1 downto phase_acc_size - 2);

    -- Angle input remapping depending on quadrant
    angle_input: process(quadrant, ANGLE)
    begin
        case quadrant is
            when "00" =>  -- 0 to 90 degrees
                initial_x <= signed(GAIN);
                initial_y <= (others => '0');
                initial_z <= signed(ANGLE);
            when "01" =>  -- 90 to 180 degrees
                initial_x <= (others => '0');
                initial_y <= signed(GAIN);
                initial_z <= signed("00" & ANGLE(phase_acc_size - 3 downto 0));
            when "10" =>  -- 180 to 270 degrees
                initial_x <= (others => '0');
                initial_y <= -signed(GAIN);
                initial_z <= signed("11" & ANGLE(phase_acc_size - 3 downto 0));
            when "11" =>  -- 270 to 360 degrees
                initial_x <= signed(GAIN);
                initial_y <= (others => '0');
                initial_z <= signed(ANGLE);
            when others =>
                initial_x <= (others => '0');
                initial_y <= (others => '0');
                initial_z <= (others => '0');
        end case;
    end process;

    process(CLK, RST)
    begin
        if RST = '1' then
            for i in 0 to OUTPUT_BITS - 1 loop
                x(i) <= (others => '0');
                y(i) <= (others => '0');
                z(i) <= (others => '0');
            end loop;
        elsif rising_edge(CLK) then
            x(0) <= initial_x;
            y(0) <= initial_y;
            z(0) <= initial_z;

            for i in 0 to OUTPUT_BITS - 2 loop
                if z(i) < 0 then
                    x(i + 1) <= x(i) + shift_right(y(i), i);
                    y(i + 1) <= y(i) - shift_right(x(i), i);
                    z(i + 1) <= z(i) + atan(i);
                else
                    x(i + 1) <= x(i) - shift_right(y(i), i);
                    y(i + 1) <= y(i) + shift_right(x(i), i);
                    z(i + 1) <= z(i) - atan(i);
                end if;
            end loop;
        end if;
    end process;

    SIN_OUT <= std_logic_vector(y(OUTPUT_BITS - 1)(OUTPUT_BITS - 1 downto 0));
    COS_OUT <= std_logic_vector(x(OUTPUT_BITS - 1)(OUTPUT_BITS - 1 downto 0));

end Behavioral;