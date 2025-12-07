# FPGA-based QPSK Modulator using CORDIC
> This project implements a **Quadrature Phase Shift Keying (QPSK) modulator** on an FPGA using the **CORDIC algorithm** to generate sine and cosine values efficiently. 


   
## Introduction
This final project represents the design, and implementation of a FPGA-based QPSK Modulator using the CORDIC algorithm. This work is carried out as a requirement for completing the Final Project for Digital System Design Course.

This FPGA is used to process a binary data stream, and process it into a phase-modulated carrier signal, which the signal is suitable for transmission. The input bitstream is grouped into pairs of bits, with each pair mapped to one of four possible points in the QPSK constellation diagram. Then, each constellation point corresponds to amplitude values of +1 or -1 for the in-phase (I), and quadrature (Q) components. The components (I, and Q) are multiplied by the orthogonal carrier signals, whic usually is cosine for the in-phase (I)  path, and sine for quadrature (Q) path, thus the resulting signals are summed to produce the final output.

Since it uses sine, and cosine values. To efficiently generate the required values, we use the CORDIC (Coordinate Rotation Digital Computer) algorithm, which allows trigonometric computations to be implemented using shift, and add operations. 