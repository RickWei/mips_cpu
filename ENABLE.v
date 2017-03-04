`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/28 14:27:50
// Design Name: 
// Module Name: ENABLE
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


module ENABLE(
	input clk,
	output [7:0] an
	);
    reg [7:0] an;
	wire cp;
	FreqDiv # (50000) fd_1ms(clk,cp);
	
	reg count = 0;
	
	always @(posedge cp) begin
		count <= count + 1;
	end

	always @(count) begin
		case(count)
			3'd0: an = 8'b11111110;
			3'd1: an = 8'b11101111;
			default:an = 8'b11111111; //使所有灯都熄灭
		endcase
	end
endmodule
