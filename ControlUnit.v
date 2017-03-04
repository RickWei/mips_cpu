`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/01 16:38:21
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
    input [5:0] op,
    input [5:0] func,
    input [4:0] rs,
    output Read_rt,Beq,Bne,Bgez,MemWrite,MemtoReg,Unsigned,ALUsrc,I_ins,Jr,Shift,
    output [3:0] ALUop,
    output Jump,Jal,RegWrite,Syscall,Sh,
    output eret,mtc0,mfc0
    );
    wire add,addu,and_,sll,srl,sra,jr,syscall,sub,or_,nor_,slt,subu,sltu;
    wire j,jal,beq,bne,addi,addiu,slti,andi,ori,sltiu,bgez,lw,sw,sh;
    assign add=(op==6'b0)&&(func==6'b100000);
    assign addu=(op==6'b0)&&(func==6'b100001);
    assign and_=(op==6'b0)&&(func==6'b100100);
    assign sll=(op==6'b0)&&(func==6'b000000);
    assign srl=(op==6'b0)&&(func==6'b000010);
    assign sra=(op==6'b0)&&(func==6'b000011);
    assign jr=(op==6'b0)&&(func==6'b001000);
    assign syscall=(op==6'b0)&&(func==6'b001100);
    assign sub=(op==6'b0)&&(func==6'b100010);
    assign or_=(op==6'b0)&&(func==6'b100101);
    assign nor_=(op==6'b0)&&(func==6'b100111);
    assign slt=(op==6'b0)&&(func==6'b101010);
    assign subu=(op==6'b0)&&(func==6'b100011);
    assign sltu=(op==6'b0)&&(func==6'b101011);
    
    assign j=(op==6'b000010);
    assign jal=(op==6'b000011);
    assign beq=(op==6'b000100);
    assign bne=(op==6'b000101);
    assign addi=(op==6'b001000);
    assign addiu=(op==6'b001001);
    assign slti=(op==6'b001010);
    assign andi=(op==6'b001100);  
    assign ori=(op==6'b001101);
    assign sltiu=(op==6'b001011);
    assign bgez=(op==6'b000001);
    assign lw=(op==6'b100011);
    assign sw=(op==6'b101011);
    assign sh=(op==6'b101001); 
    
    assign Shift=sll|srl|sra;
    assign Read_rt=Shift;
    assign Jal=jal;
    assign Jr=jr;
    assign Jump=j|jal;
    assign I_ins=addi|addiu|lw|slti|andi|ori|sltiu;
    assign Bne=bne;
    assign Beq=beq;
    assign Bgez=bgez;
    assign ALUsrc=addi|addiu|lw|sw|sh|slti|andi|ori|sltiu;
    assign MemWrite=sh|sw;
    assign MemtoReg=lw;
    assign Sh=sh;
    assign Unsigned=sltu|addiu|sltiu|addu|subu;
    assign Syscall=syscall;
    assign RegWrite=jal|lw|sltu|addu|add|and_|sub|or_|nor_|slt|addi|addiu|lw|slti|andi|ori|sll|srl|sra|subu|sltiu|mfc0;
    
    
    assign ALUop=(sll?4'd0:0)|
    (add|addu|addi|sh|addiu|sw|lw?4'd5:0)|
    (sra?4'd1:0)|
    (beq|bne|sub|subu?4'd6:0)|
    (srl?4'd2:0)|
    (andi|and_?4'd7:0)|
    (nor_?4'd10:0)|
    (or_|ori?4'd8:0)|
    (sltu|sltiu?4'd12:0)|
    (slti|slt|bgez?4'd11:0);
     
    assign eret=((op==6'b010000) && (func==6'b011000) && (rs[4])) ? 1'b1 : 1'b0;
    assign mfc0=((op==6'b010000) && (rs==5'b00000)) ? 1'b1 : 1'b0;
    assign mtc0=((op==6'b010000) && (rs==5'b00100)) ? 1'b1 : 1'b0;
     
    
endmodule
