`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/06 17:53:06
// Design Name: 
// Module Name: rollingcse
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

//数码管显示顶层文件
module project_display_top(
input clk,
input rst,
input isenquire,//是否查询
input endpay,//是否结束付款
input [3:0] adminpasswd,//管理员密码
input issuccessfulpaid,//是否付款成功
input [1:0] canintopay,//是否进入付款
input [3:0] paidone,//实付个位
input [3:0] paidten,//十位
input [3:0] costone,//应付个位
input [3:0] costten,//十位
input [3:0] returnone,//找零/退钱个位
input [3:0] returnten,//十位
input isintoincome,//是否查看总营业额
input [3:0] income1,//总营业额个位
input [3:0] income2,//十位
input [3:0] sellnum1,//售出量个位
input [3:0] sellnum10,//十位
input [1:0] choose,//用户选择的货道
input [5:0] goodleft,//商品剩余量,0位开始为第一个货物剩余量
output [7:0] seg_en,
output [7:0] seg_out
    );
    //--------各个状态下数码管的显示--------
    //主界面
    wire [7:0] seg_en_main;
    wire [7:0] seg_out_main;
    //用户查看某一商品
    wire [7:0] seg_en_select_cust;
    wire [7:0] seg_out_select_cust;
    //剩余量为零的提示
    wire [7:0] seg_en_failintopay;
    wire [7:0] seg_out_failintopay;
    //补货界面
    wire [7:0] seg_en_replenish;
    wire [7:0] seg_out_replenish;
    //查看总营业额
    wire [7:0] seg_en_earn;
    wire [7:0] seg_out_earn;
    //查看卖出数量
    wire [7:0] seg_en_soldnum;
    wire [7:0] seg_out_soldnum;
    //付款阶段
    wire [7:0] seg_en_pay;
    wire [7:0] seg_out_pay;
    //结束付款阶段的提示/找零
    wire [7:0] seg_en_endpay;
    wire [7:0] seg_out_endpay;
    //中间变量
    reg [7:0] pre_seg_en;
    reg [7:0] pre_seg_out;

    //-------状态-------
    reg [10:0] state;
    reg [10:0] nostate=11'b000_0000_0000;//初始状态
    reg [10:0] mainstate=11'b000_0000_0010;//主界面
    reg [10:0] custselstate=11'b000_0000_0100;//用户查看某一商品
    reg [10:0] replenishstate=11'b000_0001_0000;//补货界面
    reg [10:0] earnstate=11'b000_0010_0000;//查看总营业额
    reg [10:0] soldstate=11'b000_0100_0000;//查看卖出数量
    reg [10:0] paystate=11'b000_1000_0000;//付款阶段
    reg [10:0] endpaystate=11'b001_0000_0000;//结束付款阶段的提示/找零
    reg [10:0] failintopaystate=11'b010_0000_0000;//剩余量为零的提示
    reg [10:0] laststate=11'b0_0000_0000;

    //---------状态机----------
    always @(posedge clk,negedge rst)
    begin
        if(!rst)
        begin
            state=nostate;
        end
        else
        begin
            if(endpay)
            begin
                state<=endpaystate;
            end
            else if(canintopay==0)
            begin
                state=failintopaystate;
            end
            else if(canintopay==1)
            begin
                state=paystate;
            end
            else if(adminpasswd==4'b1010)
            begin
                if(isintoincome)
                begin
                    state=earnstate;
                end
                else if(~isenquire)
                begin
                    if(choose==0)
                    state=mainstate;
                    else if(choose>=1&&choose<=3)
                    state=soldstate;
                end
                else if(isenquire)
                begin
                    if(choose>=1&&choose<=3)
                    state=replenishstate;
                    else if(choose==0)
                    state=mainstate;
                end
            end
            else if(adminpasswd!=4'b1010)
            begin
                if(isenquire)
                begin
                    if(choose>=1&&choose<=3)
                    state=custselstate;
                    else if(choose==0)
                    state=mainstate;
                end
                else
                state=mainstate;
            end
            else
            state=mainstate;
        end
    end

    always @(state)
    begin
        case(state)
        nostate:
        begin
            pre_seg_en<=8'b0000_0000;
            pre_seg_out<=8'b0000_0000;
        end
        mainstate:
        begin
            pre_seg_en<=seg_en_main;
            pre_seg_out<=seg_out_main;
        end
        custselstate:
        begin
            pre_seg_en<=seg_en_select_cust;
            pre_seg_out<=seg_out_select_cust;
        end
        failintopaystate:
        begin
            pre_seg_en<=seg_en_failintopay;
            pre_seg_out<=seg_out_failintopay;           
        end
        replenishstate:
        begin
            pre_seg_en<=seg_en_replenish;
            pre_seg_out<=seg_out_replenish;
        end
        earnstate:
        begin
            pre_seg_en<=seg_en_earn;
            pre_seg_out<=seg_out_earn;            
        end
        soldstate:
        begin
            pre_seg_en<=seg_en_soldnum;
            pre_seg_out<=seg_out_soldnum;            
        end
        paystate:
        begin
            pre_seg_en<=seg_en_pay;
            pre_seg_out<=seg_out_pay;            
        end
        endpaystate:
        begin
            pre_seg_en<=seg_en_endpay;
            pre_seg_out<=seg_out_endpay; 
        end
        default: 
        begin
            pre_seg_en<=8'b0000_0000;
            pre_seg_out<=8'b0000_0000;
        end
        endcase
    end

    //--------实例化各个子模块--------
    display_main_machine main(state[1],clk,goodleft,seg_en_main,seg_out_main);//主界面
    display_custselect_machine select(state[2],clk,choose,goodleft,seg_en_select_cust,seg_out_select_cust);//用户查看某一商品
    failintopay failintopaydisplay(state[9],clk,seg_en_failintopay,seg_out_failintopay);//剩余量为零的提示
    pay paydisplay(//付款阶段
        .EN(state[7]),
        .clk(clk),
        .paidone(paidone),
        .paidten(paidten),
        .costone(costone),
        .costten(costten),
        .seg_en(seg_en_pay),
        .seg_out(seg_out_pay)
    );
    endpay endpaydisplay(//结束付款阶段的提示/找零
        .EN(state[8]),
        .clk(clk),
        .mode(issuccessfulpaid),
        .returnone(returnone),
        .returnten(returnten),
        .seg_en(seg_en_endpay),
        .seg_out(seg_out_endpay)
    );
    admin_replenish replensihdisplay(//补货界面
        .EN(state[4]),
        .clk(clk),
        .behavior(choose),
        .left(goodleft),
        .seg_en(seg_en_replenish),
        .seg_out(seg_out_replenish)
    );
    earn earndisplay(//查看总营业额
        .EN(state[5]),
        .clk(clk),
        .earn({income2,income1}),
        .seg_en(seg_en_earn),
        .seg_out(seg_out_earn)
    );
    display_soldnum soldnumdisplay(//查看卖出数量
        .EN(state[6]),
        .clk(clk),
        .behavior(choose),
        .sold1(sellnum1),
        .sold2(sellnum10),
        .seg_en(seg_en_soldnum),
        .seg_out(seg_out_soldnum)
    );

    assign seg_en=pre_seg_en;
    assign seg_out=pre_seg_out;

endmodule