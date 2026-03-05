// Main module of FIR Filter
`timescale 1ns/1ps
`include "CLA.v"
`include "MUL8.v"

module filter;
    reg signed [7:0] signal_in [0:400]; // Input signal 8-bit wide in Q7 format
    reg signed [7:0] signal_out [0:400]; // Output signal 8-bit wide in Q7 format
    reg signed [7:0] h [0:4]; // Registers to store coefficients of filter
    reg signed [7:0] z [1:14]; // Shift register to store delayed signal
    reg signed [7:0] x_in; // To store 1st sample in a register
    reg clk; // Clock signal
    integer file1; // File handler
    reg [31:0] PC; // Program Counter (32-bit)
    integer i;

    // Calling adder module to calculate 4 intermediate Additions
    wire signed [7:0] w1 [0:3]; // Nets representing intermediate addition results
    CLA8 ADD1(w1[0], x_in, z[14]);
    CLA8 ADD2(w1[1], z[2], z[12]);
    CLA8 ADD3(w1[2], z[4], z[10]);
    CLA8 ADD4(w1[3], z[6], z[8]);
    
    // Calling Multiplication module to calculate 5 intermediate Multiplications
    wire signed [7:0] w2 [0:4]; // Nets representing intermediate multiplication results
    MUL8 M1(w2[0], w1[0], h[0]);
    MUL8 M2(w2[1], w1[1], h[1]);
    MUL8 M3(w2[2], w1[2], h[2]);
    MUL8 M4(w2[3], w1[3], h[3]);
    MUL8 M5(w2[4], z[7], h[4]);

    // Final stage addition
    wire signed [7:0] w3 [0:2];
    wire signed [7:0] filter_out; // Final output of the filter
    CLA8 ADD5(w3[0], w2[0], w2[1]);
    CLA8 ADD6(w3[1], w2[2], w2[3]);
    CLA8 ADD7(w3[2], w3[0], w3[1]);    
    CLA8 ADD8(filter_out, w3[2], w2[4]);    

    initial begin
        clk = 1'b0;
        PC = 0;
        // Initialize the shift register to 0 value
        for (i = 1; i<15; i=i+1) begin
            z[i] = 8'b0;
        end

        // Reading input signal data from txt file
        $readmemb("sine_samples_1500_50.txt", signal_in);
        // Loading Coefficients of filter
        $readmemb("coefficients.txt", h);
        // Opening a file to write the output data
        file1 = $fopen("Output.txt");

        $display("Filtering the signal...");
    end

    // Updating the shift register and input samples on every clock edge
    always @(posedge clk) begin
        if(PC == 400) begin
            $fclose(file1); // Close the file
            $display("Filtering finished (processed %0d samples).", PC);
            $display("Output data stored in Output.txt file");
            $finish; // Finish the simulation
        end
        else begin
            // Store the computed output in memory and write to the output file
            signal_out[PC] <= filter_out;
            $fdisplay(file1, "%b", filter_out);

            // Updating shift register on every clock edge
            x_in <= signal_in[PC];
            z[1] <= x_in;
            for (i = 2; i<=14; i=i+1) begin
                z[i] <= z[i-1];
            end

            PC <= PC + 1; // Update the program Counter
        end
    end

    // Clock signal Generation
    always #8 clk = ~clk; // Worst case delay of the filter is 14.038 ns
endmodule