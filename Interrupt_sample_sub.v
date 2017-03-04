`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/03 11:09:30
// Design Name: 
// Module Name: Interrupt_sample_sub
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


module Interrupt_sample_sub(
    input clk,
    input int_in,
    input clear,
    output int_out
    );
    
    reg temp,IR;
    assign int_out=IR;
    
    initial
    begin
        temp=0;
        IR=0;
    end
    
    always @ (posedge clk)
    begin
        if((temp|IR)&~clear) IR=1;
        else IR=0;
    end
    
    always @ (posedge clk or posedge IR)
    begin
        if(IR) temp=0;
        else if(int_in) temp=1;
    end
   
    
endmodule
