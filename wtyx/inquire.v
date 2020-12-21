`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/13 16:38:25
// Design Name: 
// Module Name: inquire
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


module inquire(
input in,//是否在查询状态
input en,
output reg inquire
    );
    always@*
    begin
    if(in&&en)
    inquire=1;
    else
    inquire=0;
    end
    
endmodule
