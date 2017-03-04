`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/02 10:00:05
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input [3:0] ALUop,
    input [31:0] x, y,
    output [31:0] R, 
    output equal
    );


    assign R = (ALUop==4'h0) ? x << y[4:0] : 32'hz,
           R = (ALUop==4'h1) ? {{32{x[31]}}, x} >>> y[4:0] : 32'hz,
           R = (ALUop==4'h2) ? x >> y[4:0] : 32'hz,
           R = (ALUop==4'h4) ? x / y : 32'hz,
           R = (ALUop==4'h5) ? x + y : 32'hz,
           R = (ALUop==4'h6) ? x - y : 32'hz,
           R = (ALUop==4'h7) ? x & y : 32'hz,
           R = (ALUop==4'h8) ? x | y : 32'hz,
           R = (ALUop==4'h9) ? x ^ y : 32'hz,
           R = (ALUop==4'ha) ? ~(x | y) : 32'hz,
           R = (ALUop==4'hb) ? $signed(x) < $signed(y) : 32'hz,
           R = (ALUop==4'hc) ? x < y : 32'hz,
           R = (ALUop>=4'hd) ? 32'h0 : 32'hz;

    assign equal = (x==y);

endmodule
