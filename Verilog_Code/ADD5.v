`timescale 1ns/1ps
`include "FA.v"
`include "HA.v"

module ADD5 (S, A, B);

    input[4:0] A, B; output[5:0] S;
    wire w1, w2, w3, w4;

    HA h1(S[0], w1, A[0], B[0]);
    FA f1(S[1], w2, A[1], B[1], w1);
    FA f2(S[2], w3, A[2], B[2], w2);
    FA f3(S[3], w4, A[3], B[3], w3);
    FA f4(S[4], S[5], A[4], B[4], w4);

endmodule