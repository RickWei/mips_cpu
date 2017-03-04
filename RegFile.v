`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/02 08:55:25
// Design Name: 
// Module Name: RegFile
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


module RegFile(
    input CLK, WE,
    input [4:0] R1, R2, RW,
    input [31:0] Din,
    output [31:0] A,B
    );
    
    reg [31:0] regs[0:31];
    
    integer i;
    initial 
    begin
        for (i=0; i<32; i=i+1) begin
            regs[i] = 0;
        end
    end
    
    assign A=regs[R1];
    assign B=regs[R2];
    
    always @(posedge CLK) begin
        if (WE) begin
            regs[RW] <= Din;
        end
    end
    
    
endmodule
