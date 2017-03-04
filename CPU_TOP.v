`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/02 18:30:20
// Design Name: 
// Module Name: CPU_TOP
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


module CPU_TOP(
    input clk,
    input [2:0] switch,
    input [2:0] Int_button,
    output [7:0] enable, out
    );
    FreqDiv # (500000) fd_10ms(clk,CLK);
    wire [31:0] DISPLAY_DATA,cycle,predict_success,predict_fail;
    cpu CPU(CLK,Int_button,DISPLAY_DATA,cycle,predict_success,predict_fail);
    
    SHOW show(
        clk,
        switch[2]?cycle:switch[1]?predict_success:switch[0]?predict_fail:DISPLAY_DATA,
        enable,
        out
        );
    
endmodule
