`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 11:54:31
// Design Name: 
// Module Name: Inquire_top
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


module Inquire_top(
    input [2:0]in_number,//用户查看货道号
    input in,//是否在查询阶段
    input ensure,//确定
    output reg[2:0] number,//查询货道号
    output reg[2:0] buy_number//购买货道号
    );
    always@*
       begin
       if(in)
        number<=in_number;
       if(ensure)
       buy_number=number;
  end
    
    
endmodule
