`timescale 1ns/1ps
`include "HA.v"
`include "FA.v"
`include "CLA.v"


module MUL_5x5 (M, A, B);

    input[4:0] A, B; output[9:0] M;
    wire[4:0] pp[4:0]; // Partial Products
    wire[12:0] s; // To store intermediate sums
    wire[12:0] c; // To stor intermediate Carrys


    // Generating Partial Products
    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin : GEN_PP
            for (j = 0; j < 5; j = j + 1) begin
                and #(0.132) (pp[i][j], A[i], B[j]);
            end
        end
    endgenerate

    // Assigning the LSB of product
    assign M[0] = pp[0][0];

    // 1st Stage
    HA h1(s[1], c[1], pp[2][0], pp[1][1]);
    HA h2(s[4], c[4], pp[1][3], pp[0][4]);
    FA f1(s[2], c[2], pp[3][0], pp[2][1], pp[1][2]);
    FA f2(s[3], c[3], pp[4][0], pp[3][1], pp[2][2]);
    FA f3(s[5], c[5], pp[4][1], pp[3][2], pp[2][3]);
    FA f4(s[6], c[6], pp[4][2], pp[3][3], pp[2][4]);

    // 2nd Stage
    HA h3(s[7], c[7], s[2], pp[0][3]);
    FA f5(s[8], c[8], s[3], s[4], c[2]);
    FA f6(s[9], c[9], c[3], s[5], pp[1][4]);
    

    // 3rd Stage
    HA h4(s[10], c[10], s[9], c[4]);
    FA f7(s[11], c[11], s[6], c[5], c[9]);
    FA f8(s[12], c[12], c[6], pp[4][3], pp[3][4]);

    // Final Stage(Vector Merge Stage)
    wire[7:0] a = {pp[4][4], s[12], s[11], s[10], s[8], s[7], s[1], pp[1][0]};
    wire[7:0] b = {c[12], c[11], c[10], c[8], c[7], c[1], pp[0][2], pp[0][1]};

    CLA8 cl1(a, b, 1'b0, M[8:1], M[9]);

endmodule