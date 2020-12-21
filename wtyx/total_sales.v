`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/21 00:48:17
// Design Name: 
// Module Name: total_sales
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


module total_sales(
input total,//总销售金额信号
output reg total_out//传递出的查看总共销售金额信号

    );
    always@*
    begin
    if(total)
    total_out<=1;
    else
    total_out<=0;
    end
endmodule
