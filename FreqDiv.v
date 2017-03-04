`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/28 14:15:53
// Design Name: 
// Module Name: FreqDiv
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


module FreqDiv(
    input CLK,
    output CP
    );
    reg[31:0] count = 0;
    reg CP=0;
    parameter [31:0] NUM=1;
    always @(posedge CLK) 
    begin
        if(count == NUM)
        begin
            count <= 0;
            CP <= ~CP;
        end
        else
            count <= count + 1;
    end
    
endmodule
