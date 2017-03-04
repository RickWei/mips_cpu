`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/03 11:01:28
// Design Name: 
// Module Name: Interrupt_sample
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


module Interrupt_sample(
    input clk,
    input [2:0] Int_button, INM, CLR,
    input IE,
    output [2:0] Int_No,
    output Int
    );
    wire [2:0] int_out;
    Interrupt_sample_sub INT0(clk,Int_button[0],CLR[0],int_out[0]);
    Interrupt_sample_sub INT1(clk,Int_button[1],CLR[1],int_out[1]);
    Interrupt_sample_sub INT2(clk,Int_button[2],CLR[2],int_out[2]); 
    wire [2:0] pri_input=int_out&~INM;
    assign Int=pri_input[0]|pri_input[1]|pri_input[2];
    assign Int_No=pri_input[2]?3'd3:pri_input[1]?3'd2:pri_input[0]?3'd1:3'd0;
endmodule
