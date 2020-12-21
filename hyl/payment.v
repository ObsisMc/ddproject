`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/13 18:14:24
// Design Name: 
// Module Name: payment
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


module payment(
    input wire en_p,
    input wire [2:0] money,//单张货币
    input wire [5:0] shouldpay,//应付多少�?
    input cancel,//取消
    output wire [5:0] payback,//返还多少�?
    output reg success,
    output successpay,
    output [3:0] paid1,
    output [3:0] paid10
   ); 
    reg [5:0] havepay;//实时已付金额
    reg [5:0] tmppayback;//实时返还金额

    assign payback=tmppayback;
    assign successpay=(havepay!=0&&payback==0)?1:0;
    assign paid1=havepay/10;
    assign paid10=havepay%10;
    
    always@*
    begin
    havepay=havepay+money;//更新已付钱金�?
    if(havepay>=shouldpay&&cancel&&en_p)//30秒结束时已付大于应付 付款成功
        begin
        tmppayback=havepay-shouldpay;
        success=1;
        end
    else if(havepay<shouldpay&&cancel&&en_p)//30秒结束已付小于应�? 付款失败 �?�?
        begin
        tmppayback=havepay;
        success=0;
        end
    else if(en_p)//30秒未结束
        begin
        tmppayback=0;
        success=0;
        end
    else//非付款状�?
        begin
        tmppayback=0;
        success=0;
        havepay=0;
        tmppayback=0;
        end
    end    

    
endmodule