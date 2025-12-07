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
