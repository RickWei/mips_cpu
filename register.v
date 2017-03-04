`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/01 19:49:37
// Design Name: 
// Module Name: register
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


module register 
    #(
        parameter width = 32
    )
    (
    input clk, WE,
    input [width-1:0] din,
    output reg [width-1:0] dout
    );
    initial
    begin
        dout <= 0;
    end
    
    always @(posedge clk) begin
        if (WE) begin
            dout[width-1:0] <= din[width-1:0];
        end
    end

endmodule
