`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/13 16:01:15
// Design Name: 
// Module Name: processor
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


module processor(
    input wire enm3,//查看营业额销售量使能信号
    input wire enc,//确认付款使能信号
    input wire supply,//补货模式 高电平有�?
    input wire reset,//复位 高电平有�?
    input wire [2:0] num,//货道�?
    input wire [2:0] count,//补货数量
    input wire [6:0] buycount,//顾客购买数量
    input wire [2:0] money,//投币1�?2元or5�?
    input wire cancel,//30秒过了还没付款取消订单（1取消�?
    output wire [3:0] sellnum10,//售货量十�?
    output wire [3:0] sellnum1,//售货量个�?
    output wire [2:0] count1,count2,count3,count4,count5,count6,count7,//商品现存数量
    output wire [2:0] maxsupply,//�?大可补数�?
    output wire [3:0] pay1,//应付多少钱（用于显示�?
    output wire [3:0] pay10,
    output wire [3:0] payback1,
    output wire [3:0] payback10,//找零
    output wire [3:0] turnover1,//营业额个�?
    output wire [3:0] turnover10,//营业额十�?
    output successpay,
    output [3:0] paid1,
    output [3:0] paid10
    );
    reg [2:0] precount1=3'b111;
    reg [2:0] precount2=3'b111;
    reg [2:0] precount3=3'b111;
    reg [2:0] precount4=3'b111;
    reg [2:0] precount5=3'b111;
    reg [2:0] precount6=3'b111;
    reg [2:0] precount7=3'b111;
    
    wire [5:0] sell1,sell2,sell3,sell4,sell5,sell6,sell7;//商品已卖数量
    
    reg [6:0] turnover;
    
    reg [2:0] price1=3'b010;//2
    reg [2:0] price2=3'b011;//3
    reg [2:0] price3=3'b011;//3
    reg [2:0] price4=3'b100;//4
    reg [2:0] price5=3'b101;//5
    reg [2:0] price6=3'b101;//5
    reg [2:0] price7=3'b111;//7商品单价
    
    assign count1=precount1;
    assign count2=precount2;
    assign count3=precount3;
    assign count4=precount4;
    assign count5=precount5;
    assign count6=precount6;
    assign count7=precount7;
    
    manager umanager(.reset(reset),.supply(supply),.num(num),.precount1(precount1),.precount2(precount2),.precount3(precount3),.precount4(precount4),.precount5(precount5),.precount6(precount6),.precount7(precount7),.count1(count1),.count2(count2),.count3(count3),.count4(count4),.count5(count5),.count6(count6),.count7(count7),.maxsupply(maxsupply));
    manager2 umanager2(.reset(reset),.supply(supply),.num(num),.precount1(precount1),.precount2(precount2),.precount3(precount3),.precount4(precount4),.precount5(precount5),.precount6(precount6),.precount7(precount7),.count1(count1),.count2(count2),.count3(count3),.count4(count4),.count5(count5),.count6(count6),.count7(count7),.count(count));
    manager3 umanager3(.enm3(enm3),.turnover(turnover),.num(num),.sell1(sell1),.sell2(sell2),.sell3(sell3),.sell4(sell4),.sell5(sell5),.sell6(sell6),.sell7(sell7),.turnover10(turnover10),.turnover1(turnover1));
    consumer uconsumer(
        .enc(enc),
        .num(num),
        .buycount(buycount),
        .money(money),
        .cancel(cancel),
        .pay1(pay1),
        .pay10(pay10),
        .payback1(payback1),
        .payback10(payback10),
        .precount1(precount1),
        .precount2(precount2),
        .precount3(precount3),
        .precount4(precount4),
        .precount5(precount5),
        .precount6(precount6),
        .precount7(precount7),
        .count1(count1),.count2(count2),.count3(count3),.count4(count4),.count5(count5),.count6(count6),.count7(count7),
        .successpay(successpay),
        .paid1(paid1),
        .paid10(paid10)
        );
    always@(uconsumer.gain)  
    turnover=turnover+uconsumer.gain;
    endmodule
