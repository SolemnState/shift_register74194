`timescale 1ns / 1ps
//  SPB SUAI
//Group 1641
// Authors:   Filippov K. and Denisov D. 
// XOR module with 4 inputs and 1 output.
module OR(
    input a,
    input b,
    input c,
    input d,
    output e
    );
    assign e=a|b|c|d;
endmodule
