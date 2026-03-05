`timescale 1ns/1ps

module HA (S, C, A, B );

    input A, B; output S, C;

    and #(0.132) x1(C, A, B);
    xor #(0.24) x2(S, A, B);

endmodule

module FA (S, Cout, A, B, Cin);

    input A, B, Cin; output S, Cout; wire w1, w2, w3;

    xor #(0.24) g1(w1, A, B);
    xor #(0.24) g2(S, w1, Cin);
    nand #(0.072) g3(w2, A, B);
    nand #(0.072) g4(w3, w1, Cin);
    nand #(0.072) g5(Cout, w2, w3);
    
endmodule


module wallace7x7(A,B,M);
      input  [6:0] A, B;
      output [13:0] M;

    wire[6:0] pp [6:0];   // 7x7 Partial Products
    wire [50:0] s;        
    wire [50:0] c;

// Generate 7×7 Partial Products
    genvar i, j;
    generate
    for (i = 0; i < 7; i = i + 1) begin : GEN_PP
        for (j = 0; j < 7; j = j + 1) begin
            and #(0.132) (pp[i][j], A[i], B[j]);
        end
    end
endgenerate

    
    // Assigning the LSB of the product
    assign M[0]= pp[0][0];
    
    //1st stage
    HA h1(s[1],c[1],pp[2][0],pp[1][1]);
    FA f1(s[2],c[2],pp[3][0],pp[2][1],pp[1][2]);
    FA f2(s[3],c[3],pp[4][0],pp[3][1],pp[2][2]);
    HA h2(s[4],c[4],pp[1][3],pp[0][4]);
    FA f3(s[5],c[5],pp[5][0],pp[4][1],pp[3][2]);
    FA f4(s[6],c[6],pp[2][3],pp[1][4],pp[0][5]);
    FA f5(s[7],c[7],pp[6][0],pp[5][1],pp[4][2]);
    FA f6(s[8],c[8],pp[3][3],pp[2][4],pp[1][5]);
    FA f7(s[9],c[9],pp[6][1],pp[5][2],pp[4][3]);
    FA f8(s[10],c[10],pp[3][4],pp[2][5],pp[1][6]);
    FA f9(s[11],c[11],pp[6][2],pp[5][3],pp[4][4]);
    HA h3(s[12],c[12],pp[3][5],pp[2][6]);
    FA f10(s[13],c[13],pp[6][3],pp[5][4],pp[4][5]);
    FA f11(s[14],c[14],pp[6][4],pp[5][5],pp[4][6]);
    
    //2nd stage
    
    HA h4(s[15],c[15],s[2],c[1]);
    FA f12(s[16],c[16],s[3],s[4],c[2]);
    FA f13(s[17],c[17],s[5],s[6],c[3]);
    FA f14(s[18],c[18],s[7],s[8],pp[0][6]);
    HA h5(s[19],c[19],c[5],c[6]);
    FA f15(s[20],c[20],s[9],s[10],c[7]);
    FA f16(s[21],c[21],s[11],s[12],c[9]);
    FA f17(s[22],c[22],s[13],pp[3][6],c[11]);
    HA h6(s[23],c[23],s[14],c[13]);
    FA f18(s[24],c[24],pp[6][5],pp[5][6],c[14]);
    
    //3rd stage
    
    HA h7(s[25],c[25],s[17],c[4]);
    FA f19(s[26],c[26],s[18],s[19],c[17]);
    FA f20(s[27],c[27],s[20],c[8],c[18]);
    FA f21(s[28],c[28],s[21],c[10],c[20]);
    FA f22(s[29],c[29],s[22],c[12],c[21]);
    HA h8(s[30],c[30],s[23],c[22]);
    HA h9(s[31],c[31],s[24],c[23]);
    HA h10(s[32],c[32],pp[6][6],c[24]);
    
    //4th stage
    
    HA h11(s[33],c[33],s[27],c[19]);
    HA h12(s[34],c[34],s[28],c[27]);
    HA h13(s[35],c[35],s[29],c[28]);
    HA h14(s[36],c[36],s[30],c[29]);
    HA h15(s[37],c[37],s[31],c[30]);
    HA h16(s[38],c[38],s[32],c[31]);
    
   
    
    //final vector merge
    
    wire[12:0]a ={c[32],s[38],s[37],s[36],s[35],s[34],s[33],s[26],s[25],s[16],s[15],s[1],pp[1][0]};
    wire[12:0]b= {c[38],c[37],c[36],c[35],c[34],c[33],c[26],c[25],c[1],c[15],pp[0][3],pp[0][2],pp[0][1]};
    
    assign M[13:1]= a+b;
 
endmodule

module tb();
    reg [6:0]A,B;
    wire [13:0]M;
    wallace7x7 w1(A,B,M);
    
    initial begin
        A = 0;
        B = 0;
        #1;

        #10 A=7'd127; B=7'd127;
        #20
        $display("%0d X %0d = %0d",A,B,M);
        #40 $finish;
    end
endmodule