`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/01 19:43:43
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
    input CLK,
    input [31:0] PC_in,IR_in,WriteData_in,Display_in,
    input [4:0] WR_in,
    input [1:0] WB_in,
    input HALT_in,
    output [31:0] PC_out,IR_out,WriteData_out,Display_out,
    output [4:0] WR_out,
    output [1:0] WB_out,
    output HALT_out
    );
    reg ENABLE=1;
    reg CLR=0;
    
    wire [31:0] PC_in_temp=CLR?32'b0:PC_in;
    wire [31:0] PC_out_temp;
    register #(.width(32)) PC(CLK, ENABLE, PC_in_temp, PC_out_temp);
    assign PC_out=PC_out_temp;
    
    wire [31:0] IR_in_temp=CLR?32'b0:IR_in;
    wire [31:0] IR_out_temp;
    register #(.width(32)) IR(CLK, ENABLE, IR_in_temp, IR_out_temp);
    assign IR_out=IR_out_temp;
    
    wire [31:0] WriteData_in_temp=CLR?32'b0:WriteData_in;
    wire [31:0] WriteData_out_temp;
    register #(.width(32)) WriteData(CLK, ENABLE, WriteData_in_temp, WriteData_out_temp);
    assign WriteData_out=WriteData_out_temp;
    
    wire [31:0] Display_in_temp=CLR?32'b0:Display_in;
    wire [31:0] Display_out_temp;
    register #(.width(32)) Display(CLK, ENABLE, Display_in_temp, Display_out_temp);
    assign Display_out=Display_out_temp;
    
    wire [4:0] WR_in_temp=CLR?5'b0:WR_in;
    wire [4:0] WR_out_temp;
    register #(.width(5)) WR(CLK, ENABLE, WR_in_temp, WR_out_temp);
    assign WR_out=WR_out_temp;     
    
    wire [1:0] WB_in_temp=CLR?2'b0:WB_in;
    wire [1:0] WB_out_temp;
    register #(.width(2)) WB(CLK, ENABLE, WB_in_temp, WB_out_temp);
    assign WB_out=WB_out_temp; 
     
    wire HALT_in_temp=CLR?1'b0:HALT_in;
    wire HALT_out_temp;
    register #(.width(1)) HALT(CLK, ENABLE, HALT_in_temp, HALT_out_temp);
    assign HALT_out=HALT_out_temp; 
endmodule
