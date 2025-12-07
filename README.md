# FPGA-based QPSK Modulator using CORDIC
> This project implements a **Quadrature Phase Shift Keying (QPSK) modulator** on an FPGA using the **CORDIC algorithm** to generate sine and cosine values efficiently. 


   
## Introduction
This final project represents the design, and implementation of a FPGA-based QPSK Modulator using the CORDIC algorithm. This work is carried out as a requirement for completing the Final Project for Digital System Design Course.

This FPGA is used to process a binary data stream, and process it into a phase-modulated carrier signal, which the signal is suitable for transmission. The input bitstream is grouped into pairs of bits, with each pair mapped to one of four possible points in the QPSK constellation diagram. Then, each constellation point corresponds to amplitude values of +1 or -1 for the in-phase (I), and quadrature (Q) components. The components (I, and Q) are multiplied by the orthogonal carrier signals, whic usually is cosine for the in-phase (I)  path, and sine for quadrature (Q) path, thus the resulting signals are summed to produce the final output.

Since it uses sine, and cosine values. To efficiently generate the required values, we use the CORDIC (Coordinate Rotation Digital Computer) algorithm, which allows trigonometric computations to be implemented using shift, and add operations. 

## Code Explanation
### CORDIC ALGORITHM
The code below rotates a vector through a sequence of micro-rotations to generate sine and cosine values from an input angle. It only uses shift and add operations. The atan(i) is referring to a lookup table consisting of the special angles
```vhdl
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
```
These are the special angles generated using the Python script:
```vhdl
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
    
```

### QPSK MAPPER
The QPSK mapper assigns each incoming 2-bit input to its corresponding constellation point by outputting the appropriate I and Q symbol values. The first bit determines the sign of the I component, while the second bit determines the sign of the Q component. Each symbol is represented using 2-bit signed format, where "01" corresponds to +1 and "11" corresponds to –1. The mapping is implemented inside a clocked process that updates the I/Q outputs on every rising clock edge.
```vhdl
case input_bits is
    when "00" => 
        i_symbol <= "01";   -- +1
        q_symbol <= "01";   -- +1
    when "01" =>
        i_symbol <= "11";   -- -1
        q_symbol <= "01";   -- +1
    when "10" =>
        i_symbol <= "01";   -- +1
        q_symbol <= "11";   -- -1
    when "11" =>
        i_symbol <= "11";   -- -1
        q_symbol <= "11";   -- -1
end case;
```

### QPSK MODULATOR (Top-level entity)
Uses structural modeling to link the symbol mapper, phase accumulator, CORDIC carrier generator, and IQ mixer into a full QPSK modulator.
```vhdl
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
```

### IQ MIXER
It Multiplies the I/Q symbols with their cosine/sine carriers and outputs the mixed I and Q signals.(Q_sine), producing 18-bit signed outputs I_MIX and Q_MIX
```vhdl
elsif (rising_edge(CLK)) then
    I_mix_result <= signed(I_SYMBOL) * signed(I_cos);
    Q_mix_result <= signed(Q_SYMBOL) * signed(Q_sine);
    I_MIX <= std_logic_vector(I_mix_result);
    Q_MIX <= std_logic_vector(Q_mix_result);
end if;
```

### PHASE ACCUMULATOR
Acts as a simple numerically controlled oscillator. On every clock it adds PHASE_INC to phase_reg and outputs the updated phase, creating the running phase for the CORDIC.
```vhdl
elsif (rising_edge(CLK)) then
    phase_reg <= phase_reg + unsigned(PHASE_INC);
    PHASE <= std_logic_vector(phase_reg);
end if;
```
