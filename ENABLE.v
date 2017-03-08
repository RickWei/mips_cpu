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
			3'd1: an = 8'b11111101;
			3'd2: an = 8'b11111011;
			3'd3: an = 8'b11110111;
			3'd4: an = 8'b11101111;
			3'd5: an = 8'b11011111;
			3'd6: an = 8'b10111111;
			3'd7: an = 8'b01111111;
			default:an = 8'b11111111; //使所有灯都熄灭

		endcase
	end
endmodule
