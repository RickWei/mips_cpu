`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/01 19:43:43
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
    input CLK,CLR,
    input [31:0] PC_in,IR_in,R1_in,R2_in,IMM_in,
    input [4:0] WR_in,
    input [12:0] EX_in,
    input [3:0] M_in,
    input [1:0] WB_in,
    input predict_ID,
    output [31:0] PC_out,IR_out,R1_out,R2_out,IMM_out,
    output [4:0] WR_out,
    output [12:0] EX_out,
    output [3:0] M_out,
    output [1:0] WB_out,
    output predict_EX
    );
    reg ENABLE=1;
    
    wire predict_in_temp=CLR?1'b0:predict_ID;
    wire predict_out_temp;
    register #(.width(1)) predict(CLK, ENABLE, predict_in_temp, predict_out_temp);
    assign predict_EX=predict_out_temp;
    
    wire [31:0] PC_in_temp=CLR?32'b0:PC_in;
    wire [31:0] PC_out_temp;
    register #(.width(32)) PC(CLK, ENABLE, PC_in_temp, PC_out_temp);
    assign PC_out=PC_out_temp;
    
    wire [31:0] IR_in_temp=CLR?32'b0:IR_in;
    wire [31:0] IR_out_temp;
    register #(.width(32)) IR(CLK, ENABLE, IR_in_temp, IR_out_temp);
    assign IR_out=IR_out_temp;
    
    wire [31:0] R1_in_temp=CLR?32'b0:R1_in;
    wire [31:0] R1_out_temp;
    register #(.width(32)) R1(CLK, ENABLE, R1_in_temp, R1_out_temp);
    assign R1_out=R1_out_temp;
    
    wire [31:0] R2_in_temp=CLR?32'b0:R2_in;
    wire [31:0] R2_out_temp;
    register #(.width(32)) R2(CLK, ENABLE, R2_in_temp, R2_out_temp);
    assign R2_out=R2_out_temp;
    
    wire [31:0] IMM_in_temp=CLR?32'b0:IMM_in;
    wire [31:0] IMM_out_temp;
    register #(.width(32)) IMM(CLK, ENABLE, IMM_in_temp, IMM_out_temp);
    assign IMM_out=IMM_out_temp;
    
    wire [4:0] WR_in_temp=CLR?5'b0:WR_in;
    wire [4:0] WR_out_temp;
    register #(.width(5)) WR(CLK, ENABLE, WR_in_temp, WR_out_temp);
    assign WR_out=WR_out_temp;     
    
    wire [12:0] EX_in_temp=CLR?13'b0:EX_in;
    wire [12:0] EX_out_temp;
    register #(.width(13)) EX(CLK, ENABLE, EX_in_temp, EX_out_temp);
    assign EX_out=EX_out_temp;  
    
    wire [3:0] M_in_temp=CLR?4'b0:M_in;
    wire [3:0] M_out_temp;
    register #(.width(4)) M(CLK, ENABLE, M_in_temp, M_out_temp);
    assign M_out=M_out_temp;  
    
    wire [1:0] WB_in_temp=CLR?2'b0:WB_in;
    wire [1:0] WB_out_temp;
    register #(.width(2)) WB(CLK, ENABLE, WB_in_temp, WB_out_temp);
    assign WB_out=WB_out_temp;  

      
endmodule
