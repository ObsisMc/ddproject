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


module duringpay(
    input enterpay,//是否进入付款
    input [2:0] keyboard_val,
    output reg[2:0] paid
    );

    always@(enterpay,keyboard_val)
    begin
        if(enterpay)
        paid<=keyboard_val;
        else
        paid<=0;
    end

    
    
endmodule
