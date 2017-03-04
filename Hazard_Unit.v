`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/02 11:04:15
// Design Name: 
// Module Name: Hazard_Unit
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


module Hazard_Unit(
    input [4:0] WR_EX,WR_MEM,R1_ID,R2_ID,
    input I_ins,Shift,LW,
    output Stall_ID,LOCK_ID,LOCK_IF,Forward_R1,Forward_R2,Forward_R1_2,Forward_R2_2
    );
    
    wire [4:0] R1_F=Shift?5'b0:R1_ID;
    wire [4:0] R2_F=I_ins?5'b0:R2_ID;
    
    assign Forward_R1=(WR_EX!=5'b0)&(WR_EX==R1_F);
    assign Forward_R1_2=(WR_MEM!=5'b0)&(WR_MEM==R1_F);
    assign Forward_R2=(WR_EX!=5'b0)&(WR_EX==R2_F);
    assign Forward_R2_2=(WR_MEM!=5'b0)&(WR_MEM==R2_F);
    
    assign Stall_ID=LW&(Forward_R1|Forward_R2);
    assign LOCK_ID=LW&(Forward_R1|Forward_R2);
    assign LOCK_IF=LW&(Forward_R1|Forward_R2);
endmodule
