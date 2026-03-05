`timescale 1ns/1ps

module FA (S, Cout, A, B, Cin);

    input A, B, Cin; output S, Cout; wire w1, w2, w3;

    xor #(0.24) g1(w1, A, B), g2(S, w1, Cin);
    nand #(0.072) g3(w2, A, B), g4(w3, w1, Cin), g5(Cout, w2, w3);
    
endmodule