`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/11 23:15:03
// Design Name: 
// Module Name: num_display
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


module num_display(
input [3:0] num,
output reg [7:0] display_r
    );
    always @(num)
    begin
    case(num)
    4'd0: display_r=8'b00111111;
    4'd1: display_r=8'b00000110;
    4'd2: display_r=8'b01011011;
    4'd3: display_r=8'b01001111;
    4'd4: display_r=8'b01100110;
    4'd5: display_r=8'b01101101;
    4'd6: display_r=8'b01111100;
    4'd7: display_r=8'b00000111;
    4'd8: display_r=8'b01111111;
    4'd9: display_r=8'b01101111;
    endcase
    end
endmodule
