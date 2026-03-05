`timescale 1ns/1ps

module HA (S, C, A, B );

    input A, B; output S, C;

    and #(0.132) x1(C, A, B);
    xor #(0.24) x2(S, A, B);

endmodule