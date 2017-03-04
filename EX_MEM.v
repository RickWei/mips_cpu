`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/01 19:43:43
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    input CLK,
    input [31:0] PC_in,IR_in,B_in,ALUout_in,
    input [4:0] WR_in,
    input [3:0] M_in,
    input [1:0] WB_in,
    input HALT_in,
    input [31:0] Jal_data_in,
    output [31:0] PC_out,IR_out,B_out,ALUout_out,
    output [4:0] WR_out,
    output [3:0] M_out,
    output [1:0] WB_out,
    output HALT_out,
    output [31:0] Jal_data_out
    );
    reg ENABLE=1;
    reg CLR=0;
    
    wire [31:0] Jal_data_in_temp=CLR?32'b0:Jal_data_in;
    wire [31:0] Jal_data_out_temp;
    register #(.width(32)) Jal_data(CLK, ENABLE, Jal_data_in_temp, Jal_data_out_temp);
    assign Jal_data_out=Jal_data_out_temp;
    
    wire [31:0] PC_in_temp=CLR?32'b0:PC_in;
    wire [31:0] PC_out_temp;
    register #(.width(32)) PC(CLK, ENABLE, PC_in_temp, PC_out_temp);
    assign PC_out=PC_out_temp;
    
    wire [31:0] IR_in_temp=CLR?32'b0:IR_in;
    wire [31:0] IR_out_temp;
    register #(.width(32)) IR(CLK, ENABLE, IR_in_temp, IR_out_temp);
    assign IR_out=IR_out_temp;
    
    wire [31:0] B_in_temp=CLR?32'b0:B_in;
    wire [31:0] B_out_temp;
    register #(.width(32)) B(CLK, ENABLE, B_in_temp, B_out_temp);
    assign B_out=B_out_temp;
    
    wire [31:0] ALUout_in_temp=CLR?32'b0:ALUout_in;
    wire [31:0] ALUout_out_temp;
    register #(.width(32)) ALUout(CLK, ENABLE, ALUout_in_temp, ALUout_out_temp);
    assign ALUout_out=ALUout_out_temp;
    
    wire [4:0] WR_in_temp=CLR?5'b0:WR_in;
    wire [4:0] WR_out_temp;
    register #(.width(5)) WR(CLK, ENABLE, WR_in_temp, WR_out_temp);
    assign WR_out=WR_out_temp;     
    
    wire [3:0] M_in_temp=CLR?4'b0:M_in;
    wire [3:0] M_out_temp;
    register #(.width(4)) M(CLK, ENABLE, M_in_temp, M_out_temp);
    assign M_out=M_out_temp;  
    
    wire [1:0] WB_in_temp=CLR?2'b0:WB_in;
    wire [1:0] WB_out_temp;
    register #(.width(2)) WB(CLK, ENABLE, WB_in_temp, WB_out_temp);
    assign WB_out=WB_out_temp; 
     
    wire HALT_in_temp=CLR?1'b0:HALT_in;
    wire HALT_out_temp;
    register #(.width(1)) HALT(CLK, ENABLE, HALT_in_temp, HALT_out_temp);
    assign HALT_out=HALT_out_temp; 
endmodule
