`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/02 18:39:21
// Design Name: 
// Module Name: SHOW
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


module SHOW(
    input clk,
    input [31:0] DISPLAY_DATA,
    output [7:0] enable,
    output [7:0] out
    );
    wire [7:0] d0,d1,d2,d3,d4,d5,d6,d7;
    ENABLE ENABLE(clk,enable);
    SEVEN_SEG SEVEN_SEG0(DISPLAY_DATA[3:0], d0);
    SEVEN_SEG SEVEN_SEG1(DISPLAY_DATA[7:4], d1);
    SEVEN_SEG SEVEN_SEG2(DISPLAY_DATA[11:8], d2);
    SEVEN_SEG SEVEN_SEG3(DISPLAY_DATA[15:12], d3);
    SEVEN_SEG SEVEN_SEG4(DISPLAY_DATA[19:16], d4);
    SEVEN_SEG SEVEN_SEG5(DISPLAY_DATA[23:20], d5);
    SEVEN_SEG SEVEN_SEG6(DISPLAY_DATA[27:24], d6);
    SEVEN_SEG SEVEN_SEG7(DISPLAY_DATA[31:28], d7);
    assign out = (d0&{8{~enable[0]}}) |
                 (d1&{8{~enable[1]}}) |
                 (d2&{8{~enable[2]}}) |
                 (d3&{8{~enable[3]}}) |
                 (d4&{8{~enable[4]}}) |
                 (d5&{8{~enable[5]}}) |
                 (d6&{8{~enable[6]}}) |
                 (d7&{8{~enable[7]}}) ;
    
endmodule
