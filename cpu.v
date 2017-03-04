`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/01 19:19:21
// Design Name: 
// Module Name: test
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


module cpu(
        input clk,
        input [2:0] Int_button,
        output reg [31:0] DISPLAY_OUT,
        output reg [31:0] cycle,
        output reg [31:0] predict_success,
        output reg [31:0] predict_fail
    );
    wire HALT;
    reg ENABLE;
    reg CLR;
    wire CLK=HALT?1'b0:clk;
    
    initial
    begin
        predict_success=1'b0;
        predict_fail=1'b0;
        cycle=32'b0;
        ENABLE=1'b1;
        CLR=1'b0;
    end
    wire Syscall_Display;
    wire [31:0] Display;
    always @(posedge CLK)
        begin
            cycle=cycle+1;
            if(Syscall_Display) DISPLAY_OUT=Display;
        end
 ////////////////////IF///////////////////////////
    wire branch;
    wire [31:0] PC_jump;
    wire [31:0] PC_in_temp;
    wire [31:0] PC_out_temp;
    wire LOCK_IF;
    register #(.width(32)) PC(CLK, ~LOCK_IF, PC_in_temp, PC_out_temp);
    wire [31:0] PC_IF;
    wire [31:0] IR_IF;
    wire [31:0] int_pc;
    wire eret_EX;
    wire Interrupt;
    
    
    
    ////////////////////predict///////////////////////////////
    
    wire [31:0] PC_EX,preaddr;
    wire predict_IF;
    wire predict_ID;
    wire predict_EX;
    wire branch_jump=branch^predict_EX;
    
    predictor predictor(CLK,PC_IF,PC_in_temp,PC_EX,branch_jump,predict_EX,preaddr,predict_IF);
    
    assign PC_in_temp=eret_EX?EPC:Interrupt?int_pc:branch_jump?(predict_EX?PC_EX:PC_jump):predict_IF?preaddr:(PC_out_temp+32'h4);
    
    always @(posedge CLK)
            begin
                if(branch&predict_EX) predict_success=predict_success+1;
                else if (branch&~predict_EX) predict_fail=predict_fail+1;
            end
    
    ////////////////////predict///////////////////////////////
    
    assign PC_IF=PC_out_temp+32'h4;
    wire [9:0] PC_addr=PC_out_temp[11:2];
    
    dist_mem_gen_0 ROM(PC_addr,IR_IF);
    
    
    ////////////////////IF/ID///////////////////////////
    wire [31:0] PC_ID;
    wire [31:0] IR_ID;
    wire LOCK_ID;
    IF_ID IF_ID(
        CLK,~LOCK_ID,Interrupt|branch_jump,
        PC_IF,IR_IF,predict_IF,
        PC_ID,IR_ID,predict_ID
        );
        
    ////////////////////ID///////////////////////////
    wire [5:0] op=IR_ID[31:26];
    wire [4:0] rs=IR_ID[25:21];
    wire [4:0] rt=IR_ID[20:16];
    wire [4:0] rd=IR_ID[15:11];
    wire [5:0] func=IR_ID[5:0];
    
    wire Read_rt,Beq_ID,Bne_ID,Bgez_ID,MemWrite_ID,MemtoReg_ID,Unsigned,ALUsrc_ID,I_ins,Jr_ID,Shift_ID;
    wire [3:0] ALUop_ID;
    wire Jump_ID,Jal,RegWrite_ID,Syscall,Sh_ID;
    wire eret_ID,mtc0_ID,mfc0_ID;
    ControlUnit ControlUnit(
        op,
        func,
        rs,
        Read_rt,Beq_ID,Bne_ID,Bgez_ID,MemWrite_ID,MemtoReg_ID,Unsigned,ALUsrc_ID,I_ins,Jr_ID,Shift_ID,
        ALUop_ID,
        Jump_ID,Jal,RegWrite_ID,Syscall,Sh_ID,
        eret_ID,mtc0_ID,mfc0_ID
        );
    
    wire [12:0] EX_in={eret_ID,Syscall,ALUop_ID,Jump_ID,Shift_ID,Jr_ID,ALUsrc_ID,Bgez_ID,Bne_ID,Beq_ID};
    wire [3:0] M_in_ID={Sh_ID,Jal,MemtoReg_ID,MemWrite_ID};
    wire [1:0] WB_in_ID={Syscall,RegWrite_ID};
    wire RegWrite;
    wire [4:0] R1_ID=Syscall?5'h2:rs;
    wire [4:0] R2_ID=Syscall?5'h4:rt;
    wire [4:0] RW;
    wire [31:0] Din;
    wire WE=RegWrite?1'b1:1'b0;
    wire [31:0] A,B;
    RegFile RegFile(
            ~CLK, WE,
            R1_ID, R2_ID, RW,
            Din,
            A,B
            );
            
    wire [31:0] R;
    wire [31:0] WriteData_in;
    wire Forward_R1,Forward_R2,Forward_R1_2,Forward_R2_2;
    wire [31:0] IMM_in=Unsigned?
                        {{16{1'b0}}, IR_ID[15:0]}:
                        {{16{IR_ID[15]}}, IR_ID[15:0]};
    wire [4:0] WR_in_ID=Jal?5'h1f:I_ins?rt:mfc0_ID?rt:rd;
    wire [31:0] R1_in=mfc0_ID?EPC:Forward_R1?R:Forward_R1_2?WriteData_in:A;
    wire [31:0] R2_in=mfc0_ID?32'b0:Forward_R2?R:Forward_R2_2?WriteData_in:B;
     ////////////////////ID/EX///////////////////////////
    wire [31:0] IR_EX;
    wire [31:0] R1;
    wire [31:0] R2;
    wire [12:0] EX_out;
    wire [4:0] WR_out_EX;
    wire [3:0] M_out_EX;
    wire [1:0] WB_out_EX;
    wire Stall_ID;
    wire [31:0] imm;
    
    ID_EX ID_EX(
         CLK,branch_jump|Stall_ID|Interrupt,
         PC_ID,IR_ID,R1_in,R2_in,IMM_in,
         WR_in_ID,
         EX_in,
         M_in_ID,
         WB_in_ID,
         predict_ID,
         PC_EX,IR_EX,R1,R2,imm,
         WR_out_EX,
         EX_out,
         M_out_EX,
         WB_out_EX,
         predict_EX
         );
         
         
    ////////////////////EX///////////////////////////
    wire [31:0] sa={{27{1'b0}},IR_EX[10:6]};
    wire [25:0] addr=IR_EX[25:0];
    
    wire Beq=EX_out[0];
    wire Bne=EX_out[1];    
    wire Bgez=EX_out[2];    
    wire ALUsrc=EX_out[3];    
    wire Jr=EX_out[4];    
    wire Shift=EX_out[5];    
    wire Jump=EX_out[6];    
    wire [10:7] ALUop=EX_out[10:7]; 
    wire Syscall_EX=EX_out[11]; 
    assign eret_EX=EX_out[12];
    wire [4:0] WR_EX=WR_out_EX[4:0];
    wire LW=M_out_MEM[1];
    wire Jal_EX=M_out_EX[2];
        
    wire [31:0] X=Shift?R2:R1;
    wire [31:0] Y=Bgez?32'b0:Shift?sa:ALUsrc?imm:Syscall_EX?32'ha:R2;
    wire Equal;
    ALU ALU(
        ALUop,
        X, Y,
        R,
        Equal
        );
    wire bne_beq=(Bgez&~R)|(Beq&Equal)|(Bne&~Equal);
    assign branch=Jr|Jump|bne_beq;
    assign PC_jump=eret_EX?EPC:Jr?R1:bne_beq?PC_EX+(imm<<2):Jump?{PC_EX[31:28],addr,2'b00}:PC_EX;
    wire HALT_in=Equal&Syscall_EX;
    wire [31:0] Jal_data_in=PC_EX;
    ////////////////////EX/MEM///////////////////////////
    wire [31:0] PC_MEM;
    wire [31:0] IR_MEM;
    wire [31:0] B_out;
    wire [31:0] ALUout_out;
    wire [4:0] WR_out_MEM;
    wire [3:0] M_out_MEM;
    wire [1:0] WB_out_MEM;
    wire HALT_out_MEM;
    wire [31:0] Jal_data_out;
    EX_MEM EX_MEM(
        CLK,
        PC_jump,IR_EX,R2,R,
        WR_out_EX,
        M_out_EX,
        WB_out_EX,
        HALT_in,
        Jal_data_in,
        PC_MEM,IR_MEM,B_out,ALUout_out,
        WR_out_MEM,
        M_out_MEM,
        WB_out_MEM,
        HALT_out_MEM,
        Jal_data_out
        );
    ////////////////////MEM///////////////////////////
    wire MemWrite=M_out_MEM[0];
    wire MemtoReg=M_out_MEM[1];
    wire Jal_MEM=M_out_MEM[2];
    wire sh=M_out_MEM[3];
    
    wire [31:0] Data;
    wire RAM_0_WE=sh?0:MemWrite;
    wire RAM_1_WE=MemWrite;
    dist_mem_gen_1 RAM_0(
        ALUout_out[11:2],
        B_out[15:0],
        ALUout_out[11:2],
        CLK,
        RAM_0_WE,
        Data[15:0]
    );
    dist_mem_gen_1 RAM_1(
        ALUout_out[11:2],
        B_out[31:16],
        ALUout_out[11:2],
        CLK,
        RAM_1_WE,
        Data[31:16]
    );
    wire [4:0] WR_MEM=WR_out_MEM;
    assign WriteData_in=Jal_MEM?Jal_data_out:MemtoReg?Data:ALUout_out;
    ////////////////////MEM/WB///////////////////////////
    wire [31:0] PC_WB;
    wire [31:0] IR_WB;
    wire [31:0] WriteData_out;
    wire [31:0] Display_out;
    wire [4:0] WR_out_WB;
    wire [1:0] WB_out_WB;
    wire HALT_out_WB;
    MEM_WB MEM_WB(
        CLK,
        PC_MEM,IR_MEM,WriteData_in,B_out,
        WR_out_MEM,
        WB_out_MEM,
        HALT_out_MEM,
        PC_WB,IR_WB,WriteData_out,Display_out,
        WR_out_WB,
        WB_out_WB,
        HALT_out_WB
        );
     /////////////////////WB///////////////////////////
     assign RegWrite=WB_out_WB[0];
     assign Syscall_Display=WB_out_WB[1];
     assign Din=WriteData_out;
     assign Display=Display_out;
     assign RW=WR_out_WB;
     
     register #(.width(1)) HALT_reg(CLK, 1'b1, HALT_out_WB, HALT);
     
     
    ////////////////////HAZARD///////////////////////////
    Hazard_Unit Hazard_Unit( 
        WR_EX,WR_MEM,R1_ID,R2_ID,
        I_ins,Read_rt,LW,
        Stall_ID,LOCK_ID,LOCK_IF,Forward_R1,Forward_R2,Forward_R1_2,Forward_R2_2
        );
        
    /////////////////////INTERRUPT//////////////////////////////
    wire [2:0] INM, CLR_INT,Int_No;
    wire [11:0] PC_JUDGE=PC_out_temp[11:0];
    assign INM=(PC_JUDGE>=12'hf00)?3'b111:(PC_JUDGE>=12'he00)?3'b011:(PC_JUDGE>=12'hd00)?3'b001:3'b000;
    assign CLR_INT=(PC_JUDGE==12'hf24)?3'b100:(PC_JUDGE==12'he24)?3'b010:(PC_JUDGE==12'hd24)?3'b001:3'b000;
    wire IE,Interrupt_temp;
    wire [31:0] EPC;
    Interrupt_sample Interrupt_sample(
        ~CLK,
        Int_button, INM, CLR_INT,
        IE,
        Int_No,
        Interrupt_temp
        );
    assign Interrupt=(IR_WB!=32'b0)?Interrupt_temp:1'b0;
    register #(.width(1)) IE_reg(CLK, eret_EX|Interrupt|(mtc0_ID&~IR_ID[11]), eret_EX?1'b1:Interrupt?1'b0:R2_in[0], IE);
    register #(.width(32)) EPC_reg(CLK, Interrupt|(mtc0_ID&IR_ID[11]), Interrupt?PC_WB:R2_in, EPC);
    assign int_pc=(Int_No==3'd3)?32'hf00:(Int_No==3'd2)?32'he00:(Int_No==3'd1)?32'hd00:32'h0;
endmodule
