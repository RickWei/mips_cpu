`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/01 19:43:43
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input CLK,ENABLE,CLR,
    input [31:0] PC_in,IR_in,
    input predict_IF,
    output [31:0] PC_out,IR_out,
    output predict_ID
    );
    wire predict_in_temp=CLR?1'b0:predict_IF;
    wire predict_out_temp;
    register #(.width(1)) predict(CLK, ENABLE, predict_in_temp, predict_out_temp);
    assign predict_ID=predict_out_temp;
    
    wire [31:0] PC_in_temp=CLR?32'b0:PC_in;
    wire [31:0] PC_out_temp;
    register #(.width(32)) PC(CLK, ENABLE, PC_in_temp, PC_out_temp);
    assign PC_out=PC_out_temp;
    
    wire [31:0] IR_in_temp=CLR?32'b0:IR_in;
    wire [31:0] IR_out_temp;
    register #(.width(32)) IR(CLK, ENABLE, IR_in_temp, IR_out_temp);
    assign IR_out=IR_out_temp;
    
endmodule
