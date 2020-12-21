`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 11:44:44
// Design Name: 
// Module Name: consumer
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


module consumer(
    input enc,//付款使能信号 “确定”
    input [2:0] num,//货道号
    input [6:0] buycount,//购买数量
    input cancel,//30秒
    input [2:0] money,//一元两元还是五元
    input [2:0] precount1,precount2,precount3,precount4,precount5,precount6,precount7,//补货前数量
    output reg [2:0] count1,count2,count3,count4,count5,count6,count7,//补货后数量
    output wire [3:0] pay1,//应付多少钱（用于显示）
    output wire [3:0] pay10,
    output wire [3:0] payback1,
    output wire [3:0] payback10,//找零/退款
    output wire [5:0] gain,//获利多少钱
    output successpay,
    output [3:0] paid1,
    output [3:0] paid10
    );
    reg [5:0] shouldpay;//应付多少钱
    reg [2:0] reducecount;//商品减少数量
    reg [2:0] price;//商品单价
    wire [5:0] payback;//找零/退款
    reg [2:0] count;
    
    always@(buycount)
    case(buycount)
    7'b1000000: count=3'b001;
    7'b0100000: count=3'b010;
    7'b0010000: count=3'b011;
    7'b0001000: count=3'b100;
    7'b0000100: count=3'b101;
    7'b0000010: count=3'b110;
    7'b0000001: count=3'b111;
    default:count=3'b001;
    endcase
    
    assign pay10=shouldpay/10;
    assign pay1=shouldpay-pay10*10;
    
    assign payback10=payback/10;
    assign payback1=payback-payback10*10;
    
    assign gain=price*reducecount;
    
    always@*
    if(enc)
        case(num)//确定购买商品单价
        3'b001: price=3'b010;
        3'b010: price=3'b011;
        3'b011: price=3'b011;
        3'b100: price=3'b100;
        3'b101: price=3'b101;
        3'b110: price=3'b101;
        3'b111: price=3'b111;
        default:price=3'b000;
        endcase
    
    always@*
    if(enc)
        begin 
         case(num)//应付金额
         3'b001: shouldpay=3'b010*count;
         3'b010: shouldpay=3'b011*count;
         3'b011: shouldpay=3'b011*count;
         3'b100: shouldpay=3'b100*count;
         3'b101: shouldpay=3'b101*count;
         3'b110: shouldpay=3'b101*count;
         3'b111: shouldpay=3'b111*count;
         endcase
        end
   
    payment upayment(
        .en_p(enc),
        .shouldpay(shouldpay),
        .payback(payback),
        .cancel(cancel),
        .money(money),
        .successpay(successpay),
        .paid1(paid1),
        .paid10(paid10)
        );//支付过程的实例化
    
    always@(upayment.success)
    if(upayment.success)
        reducecount=count;
    else reducecount=3'b000;//判断是否支付成功
        
    always@*
        if(enc)
         case(num)
         3'b001: count1=precount1-reducecount;
         3'b010: count2=precount2-reducecount;
         3'b011: count3=precount3-reducecount;
         3'b100: count4=precount4-reducecount;
         3'b101: count5=precount5-reducecount;
         3'b110: count6=precount6-reducecount;
         3'b111: count7=precount7-reducecount;
         endcase//改变商品数量
endmodule
