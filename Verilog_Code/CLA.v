// 8-bit Carry Look Ahead Adder using 2 4-bit CLA

`timescale 1ns/1ps
module CLA8 (
    output signed [7:0] Out, // Output is in Q7 format (Signed 2's complement representation)
    input signed [7:0] A, B // Inputs are in Q7 format (Signed 2's complement representation)
);
    wire signed [7:0] S; // Net representing the addition output of A & B
    wire [7:0] P, G; // Net representing Propogate and genrate signals;
    wire [8:0] C; // Carry signal (C0 and C8 represents input and output carry respectively)

    // Generate Gi and Pi signals
    genvar i;
    generate
        for (i = 0; i<8; i = i + 1) begin : GEN_PG
            xor #(0.24) (P[i], A[i], B[i]);
            and #(0.13) (G[i], A[i], B[i]);
        end
    endgenerate

    // Logic for Carry Look Ahead Adder
    // First 4-bit CLA
    assign C[0] = 1'b0; // Input carry is set to 0 (Assuming no input carry is required)
    assign C[1] = G[0];
    
    wire P1G0;
    and #(0.13) (P1G0, P[1], G[0]);
    or #(0.18) (C[2], P1G0, G[1]);

    wire P2G1, P2P1G0;
    and #(0.13) (P2G1, P[2], G[1]);
    and #(0.17) (P2P1G0, P[2], P[1], G[0]);
    or #(0.23) (C[3], P2G1, P2P1G0, G[2]);

    wire P3G2, P3P2G1, P3P2P1G0;
    and #(0.13) (P3G2, P[3], G[2]);
    and #(0.17) (P3P2G1, P[2], P[3], G[1]);    
    and #(0.21) (P3P2P1G0, P[2], P[3], P[1], G[0]);    
    or #(0.29) (C[4], P3G2, P3P2G1,P3P2P1G0, G[3]);

    // Second 4-bit CLA
    wire P4C4;
    and #(0.13) (P4C4, P[4], C[4]);
    or #(0.18) (C[5], P4C4, G[4]);

    wire P5G4, P5P4C4;
    and #(0.13) (P5G4, P[5], G[4]);
    and #(0.17) (P5P4C4, P[5], P[4], C[4]);
    or #(0.23) (C[6], P5G4, P5P4C4, G[5]);

    wire P6G5, P6P5G4, P6P5P4C4;
    and #(0.13) (P6G5, P[6], G[5]);
    and #(0.17) (P6P5G4, P[6], P[5], G[4]);    
    and #(0.21) (P6P5P4C4, P[6], P[5], P[4], C[4]);    
    or #(0.29) (C[7], P6G5, P6P5G4,P6P5P4C4, G[6]);

    // Carry out generation
    wire w1;
    and #(0.13) (w1, P[7], C[7]);
    or #(0.18) (C[8], w1, G[7]);

    // Sum Generation
    generate
        for (i = 0; i<8; i = i + 1) begin : GEN_SUM
            xor #(0.24) (S[i], P[i], C[i]);
        end
    endgenerate

    // Logic for detecting overflow
    wire AB, AS, overflow;
    xnor #(0.3) (AB, A[7], B[7]);
    xor #(0.24) (AS, A[7], S[7]);
    and #(0.13) (overflow, AB, AS);

    // Logic for saturating the value if overflow has occured
    wire [7:0] max;
    wire [7:0] min;
    assign max = 8'b0111_1111; // Net representing maximum saturation value
    assign min = 8'b1000_0000; // Net representing minimum saturation value

    MUX841 MUX1(Out, S, S, max, min, overflow, B[7]);
    
endmodule

// 8-bit 4x1 Multiplexer used in saturating the output value if overflow occured
module MUX841 (
    output signed [7:0] Y,
    input signed [7:0] I0,
    input signed [7:0] I1,
    input signed [7:0] I2,
    input signed [7:0] I3,
    input select1,
    input select0
);
    wire [7:0] w0, w1, w2, w3; // Nets to represent intermediate signals
    wire select1_bar, select0_bar; // Nets to store complement values select line

    // Complemented inputs of select line
    not #(0.06) (select1_bar, select1);
    not #(0.06) (select0_bar, select0);

    genvar i;
    generate
        for (i = 0; i<8; i=i+1) begin : GEN_MUX841
            and #(0.17) (w0[i], select1_bar, select0_bar, I0[i]);
            and #(0.17) (w1[i], select1_bar, select0, I1[i]);
            and #(0.17) (w2[i], select1, select0_bar, I2[i]);
            and #(0.17) (w3[i], select1, select0, I3[i]);
            or #(0.29) (Y[i], w0[i], w1[i], w2[i], w3[i]);
        end
    endgenerate

endmodule