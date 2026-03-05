// 8-bit 4x1 Multiplexer
`timescale 1ns/1ps

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