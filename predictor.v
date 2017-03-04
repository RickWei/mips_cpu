`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/04 13:15:44
// Design Name: 
// Module Name: predictor
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


module predictor(
    input CLK,
    input [31:0] PC_now,PC_to,PC_happen,
    input branch_jump,predict_EX,
    output [31:0] preaddr,
    output predict_IF
    );
    reg valid [0:7];
    reg [31:0] PC [0:7];
    reg [31:0] PC_TO [0:7];
    reg [1:0] state [0:7];
    
    reg [2:0] count;
    
    integer i;
    initial
    begin
        for(i=0;i<8;i=i+1)
        begin
            valid[i]=0;
            PC[i]=0;
            PC_TO[i]=0;
            state[i]=0;
        end      
        count=0;
    end
    
    wire match0=(PC[0]==PC_now)&valid[0]?1'b1:1'b0;
    wire match1=(PC[1]==PC_now)&valid[1]?1'b1:1'b0;
    wire match2=(PC[2]==PC_now)&valid[2]?1'b1:1'b0;
    wire match3=(PC[3]==PC_now)&valid[3]?1'b1:1'b0;
    wire match4=(PC[4]==PC_now)&valid[4]?1'b1:1'b0;
    wire match5=(PC[5]==PC_now)&valid[5]?1'b1:1'b0;
    wire match6=(PC[6]==PC_now)&valid[6]?1'b1:1'b0;
    wire match7=(PC[7]==PC_now)&valid[7]?1'b1:1'b0;
    
    wire match=match0|match1|match2|match3|match4|match5|match6|match7;
    wire [2:0] match_No=match7?3'd7:match6?3'd6:match5?3'd5:match4?3'd4:
                        match3?3'd3:match2?3'd2:match1?3'd1:match0?3'd0:3'd0;
                        
    wire match0_EX=(PC[0]==PC_happen)&valid[0]?1'b1:1'b0;
    wire match1_EX=(PC[1]==PC_happen)&valid[1]?1'b1:1'b0;
    wire match2_EX=(PC[2]==PC_happen)&valid[2]?1'b1:1'b0;
    wire match3_EX=(PC[3]==PC_happen)&valid[3]?1'b1:1'b0;
    wire match4_EX=(PC[4]==PC_happen)&valid[4]?1'b1:1'b0;
    wire match5_EX=(PC[5]==PC_happen)&valid[5]?1'b1:1'b0;
    wire match6_EX=(PC[6]==PC_happen)&valid[6]?1'b1:1'b0;
    wire match7_EX=(PC[7]==PC_happen)&valid[7]?1'b1:1'b0;
    
    wire match_EX=match0_EX|match1_EX|match2_EX|match3_EX|match4_EX|match5_EX|match6_EX|match7_EX;
    wire [2:0] match_No_EX=match7_EX?3'd7:match6_EX?3'd6:match5_EX?3'd5:match4_EX?3'd4:
                        match3_EX?3'd3:match2_EX?3'd2:match1_EX?3'd1:match0_EX?3'd0:3'd0;
    
    always @ (posedge CLK)
    begin
        if(branch_jump)
        begin
            if(match_EX)
            begin
                valid[match_No_EX]=1'b0;
                valid[count]=1'b1;
                PC[count]=PC_happen;
                PC_TO[count]=PC_to;
                state[count]=predict_EX?
                                (state[match_No_EX]==2'b00)?2'b00:state[match_No_EX]-2'b1:
                                (state[match_No_EX]==2'b11)?2'b11:state[match_No_EX]+2'b1;
                count=count+1;
            end
            else
            begin
                valid[count]=1'b1;
                PC[count]=PC_happen;
                PC_TO[count]=PC_to;
                state[count]=2'b01;
                count=count+1;
            end
        end
    end
    
    assign predict_IF=match&(state[match_No][1]==1'b1)?1'b1:1'b0;
    assign preaddr=predict_IF?PC_TO[match_No]:32'b0;
    
endmodule
