// 8x8 Signed Multiplication using Carry Save Multiplier
// 16-bit output will be truncated to 8-bits
`timescale 1ns/1ps

module MUL8 (
    output signed [15:0] M,
    input signed [7:0] A,
    input signed [7:0] B
);
    
    wire [7:0] pp[7:0]; // To store partial products
    genvar i, j;
    generate
        for (i = 0; i < 8; i = i + 1) begin : ROW
            for (j = 0; j < 8; j = j + 1) begin : COL
                and #(0.13) (pp[i][j], A[j], B[i]);
            end
        end
    endgenerate

    wire [80:0] s;        
    wire [80:0] c;
    wire [20:0] inv; 
   
    //1st row 
    HA h1(s[0],c[0],pp[1][0],pp[0][1]);
    HA h2(s[1],c[1],pp[0][2],pp[1][1]);
    HA h3(s[2],c[2],pp[1][2],pp[0][3]);
    HA h4(s[3],c[3],pp[1][3],pp[0][4]);
    HA h5(s[4],c[4],pp[1][4],pp[0][5]);
    HA h6(s[5],c[5],pp[0][6],pp[1][5]);
    
    not #(0.06) n1(inv[0],pp[0][7]);
    HA h7(s[6],c[6],inv[0],pp[1][6]);
    
    not #(0.06) n2(inv[1],pp[1][7]);
    HA h8(s[7],c[7],inv[1],1'b1);
     
    //2nd Row 
    FA f1(s[8],c[8],pp[2][0],s[1],c[0]);
    FA f2(s[9],c[9],pp[2][1],s[2],c[1]);
    FA f3(s[10],c[10],pp[2][2],s[3],c[2]);
    FA f4(s[11],c[11],pp[2][3],s[4],c[3]);
    FA f5(s[12],c[12],pp[2][4],s[5],c[4]);
    FA f6(s[13],c[13],pp[2][5],s[6],c[5]);
    FA f7(s[14],c[14],pp[2][6],s[7],c[6]);

    not #(0.06) n3(inv[2],pp[2][7]);
    HA h9(s[15],c[15],inv[2],c[7]);

    //3 rd row
    FA f8(s[16],c[16],pp[3][0],s[9],c[8]);
    FA f9(s[17],c[17],pp[3][1],s[10],c[9]);
    FA f10(s[18],c[18],pp[3][2],s[11],c[10]);
    FA f11(s[19],c[19],pp[3][3],s[12],c[11]);
    FA f12(s[20],c[20],pp[3][4],s[13],c[12]);
    FA f13(s[21],c[21],pp[3][5],s[14],c[13]);
    FA f14(s[22],c[22],pp[3][6],s[15],c[14]);

    not #(0.06) n4(inv[3],pp[3][7]);
    HA h10(s[23],c[23],inv[3],c[15]);

    //4th row 
    FA f15(s[24],c[24],pp[4][0],s[17],c[16]);
    FA f16(s[25],c[25],pp[4][1],s[18],c[17]);
    FA f17(s[26],c[26],pp[4][2],s[19],c[18]);
    FA f18(s[27],c[27],pp[4][3],s[20],c[19]);
    FA f19(s[28],c[28],pp[4][4],s[21],c[20]);
    FA f20(s[29],c[29],pp[4][5],s[22],c[21]);
    FA f21(s[30],c[30],pp[4][6],s[23],c[22]);

    not #(0.06) n5(inv[4],pp[4][7]);
    HA h11(s[31],c[31],inv[4],c[23]);

    //5th row 
    FA f22(s[32],c[32],pp[5][0],s[25],c[24]);
    FA f23(s[33],c[33],pp[5][1],s[26],c[25]);
    FA f24(s[34],c[34],pp[5][2],s[27],c[26]);
    FA f25(s[35],c[35],pp[5][3],s[28],c[27]);
    FA f26(s[36],c[36],pp[5][4],s[29],c[28]);
    FA f27(s[37],c[37],pp[5][5],s[30],c[29]);
    FA f28(s[38],c[38],pp[5][6],s[31],c[30]);
    
    not #(0.060) n6(inv[5],pp[5][7]);
    HA h12(s[39],c[39],inv[5],c[31]);
    
    //6th row 
    FA f29(s[40],c[40],pp[6][0],s[33],c[32]);
    FA f30(s[41],c[41],pp[6][1],s[34],c[33]);
    FA f31(s[42],c[42],pp[6][2],s[35],c[34]);
    FA f32(s[43],c[43],pp[6][3],s[36],c[35]);
    FA f33(s[44],c[44],pp[6][4],s[37],c[36]);
    FA f34(s[45],c[45],pp[6][5],s[38],c[37]);
    FA f35(s[46],c[46],pp[6][6],s[39],c[38]);
   
   not #(0.060) n7(inv[6],pp[6][7]);
   HA h13(s[47],c[47],inv[6],c[39]);
    
   //7th row
     not #(0.060) n8(inv[7],pp[7][0]);
     FA f36(s[48],c[48],inv[7],s[41],c[40]);
    
     not #(0.060) n9(inv[8],pp[7][1]);
     FA f37(s[49],c[49],inv[8],s[42],c[41]);
    
     not #(0.060) n10(inv[9],pp[7][2]);
     FA f38(s[50],c[50],inv[9],s[43],c[42]);
    
     not #(0.060) n11(inv[10],pp[7][3]);
     FA f39(s[51],c[51],inv[10],s[44],c[43]);
    
     not #(0.060) n12(inv[11],pp[7][4]);
     FA f40(s[52],c[52],inv[11],s[45],c[44]);
    
     not #(0.060) n13(inv[12],pp[7][5]);
     FA f41(s[53],c[53],inv[12],s[46],c[45]);
    
     not #(0.060) n14(inv[13],pp[7][6]);
     FA f42(s[54],c[54],inv[13],s[47],c[46]);
      
     HA h14(s[55],c[55],pp[7][7],c[47]);
    
    
   //8th row
     HA h15(s[56],c[56],s[49],c[48]);
     FA f43(s[57],c[57],s[50],c[49],c[56]);
     FA f44(s[58],c[58],s[51],c[50],c[57]);
     FA f45(s[59],c[59],s[52],c[51],c[58]);
     FA f46(s[60],c[60],s[53],c[52],c[59]);
     FA f47(s[61],c[61],s[54],c[53],c[60]);
     FA f48(s[62],c[62],s[55],c[54],c[61]);
     FA f49(s[63],c[63],1'b1,c[55],c[62]);
      
     assign M[0]=pp[0][0];
     assign M[1]=s[0];
     assign M[2]=s[8];
     assign M[3]=s[16];
     assign M[4]=s[24];
     assign M[5]=s[32];
     assign M[6]=s[40];
     assign M[7]=s[48];
     assign M[8]=s[56];
     assign M[9]=s[57];
     assign M[10]=s[58];
     assign M[11]=s[59];
     assign M[12]=s[60];
     assign M[13]=s[61];
     assign M[14]=s[62];
     assign M[15]=s[63];
endmodule

// Half Adder Module
module HA (S, C, A, B);
    input A, B; 
    output S, C;
    and #(0.13) x1(C, A, B);
    xor #(0.24) x2(S, A, B);
endmodule

// Full Adder Module
module FA (S, Cout, A, B, Cin);
    input A, B, Cin; 
    output S, Cout; 
    wire w1, w2, w3;
    xor #(0.24) g1(w1, A, B);
    xor #(0.24) g2(S, w1, Cin);
    nand #(0.072) g3(w2, A, B);
    nand #(0.072) g4(w3, w1, Cin);
    nand #(0.072) g5(Cout, w2, w3);
endmodule