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

//需要传入剩余量
module project_display_top(
input clk,
input rst,
input mode,//0为用户，1为管理员
input paysuccessful,
input istotalincome,//是否进入查看总销售额
input issoldnum,//是否查看销售量
//input [2:0] behavior,//键盘输入?
input [2:0] customerchoose,//用户选择货道
input [2:0] adminchoose,//管理员选择货道
input [3:0]turnover1,
input [3:0] turnover10,
input [3:0] sold1,
input [3:0] sold10,
input [3:0] paidone,
input [3:0] paidten,
input [3:0] costone,
input [3:0] costten,
input enterpay,
input [3:0] returnone,
input [3:0] returnten,
input [20:0] goodleft,//从0位开始为第一个货物剩余量
output [7:0] seg_en,
output [7:0] seg_out,
output cancel
    );

    wire [7:0] seg_en_main;
    wire [7:0] seg_out_main;

    wire [7:0] seg_en_select_cust;
    wire [7:0] seg_out_select_cust;

    wire [7:0] seg_en_select_admin;
    wire [7:0] seg_out_select_admin;

    wire [7:0] seg_en_earn;
    wire [7:0] seg_out_earn;

    wire [7:0] seg_en_soldnum;
    wire [7:0] seg_out_soldnum;

    wire [7:0] seg_en_pay;
    wire [7:0] seg_out_pay;

    wire [7:0] seg_en_endpay;
    wire [7:0] seg_out_endpay;

    reg [7:0] pre_seg_en;
    reg [7:0] pre_seg_out;

    reg [8:0] state;//0不显示，10主,100用户选择，1000用户付款，1_0000管理员选择
    
    reg [8:0] nostate=9'b0_0000_0000;
    reg [8:0] mainstate=9'b0_0000_0010;
    reg [8:0] custselstate=9'b0_0000_0100;
    reg [8:0] adminselstate=9'b0_0001_0000;
    reg [8:0] earnstate=9'b0_0010_0000;
    reg [8:0] soldstate=9'b0_0100_0000;
    reg [8:0] paystate=9'b0_1000_0000;
    reg [8:0] endpaystate=9'b1_0000_0000;
    reg [8:0] laststate=9'b0_0000_0000;

    wire feedbackcancel;
    wire out_endpaystate;

    always @(posedge clk,negedge rst)
    begin
        if(!rst)
        begin
            state=nostate;
        end
        else if(enterpay&&!feedbackcancel)//希望是对的，enterpay似乎一直有？
        begin
            state=paystate;
        end
        else if(laststate==paystate&&feedbackcancel)
        begin
            state=endpaystate;
        end
        else if(laststate==endpaystate&&out_endpaystate)
        begin
            state=mainstate;
        end
        else if(mode==0)
        begin
            if(customerchoose==0)
            begin
                state=mainstate;
            end
            else if(customerchoose>=1&&customerchoose<=7)
            begin
                state=custselstate;
            end
        end
        else if(mode==1)
        begin
            if(istotalincome)
            state=earnstate;
            else if(issoldnum)
            state=soldstate;
            else if(adminchoose==0)
            state=mainstate;
            else if(adminchoose>=1&&adminchoose<=7)
            state=adminselstate;            
        end
        else
            state=state;
        laststate=state;
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
        adminselstate:
        begin
            pre_seg_en<=seg_en_select_admin;
            pre_seg_out<=seg_out_select_admin;
        end
        earnstate:
        begin
            pre_seg_en<=seg_en_earn;
            pre_seg_out<=seg_out_earn;            
        end
        soldstate:
        begin
            pre_seg_en<=seg_en_sold;
            pre_seg_out<=seg_out_sold;            
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

    display_admin_main main(state[1],clk,goodleft,seg_en_main,seg_out_main);
    customer_select select(state[2],clk,customerchoose,goodleft,seg_en_select_cust,seg_out_select_cust);
    admin_replenish admin_rep(state[4],clk,adminchoose,goodleft,seg_en_select_admin,seg_out_select_admin);
    earn earnmode(state[5],clk,{turnover10,turnover1},seg_en_earn,seg_out_earn);
    display_soldnum soldins(state[6],clk,adminchoose,sold1,sold10,seg_en_sold,seg_out_sold);
    pay paydisplay(state[7],clk,paidone,paidten,costone,costten,seg_en_pay,seg_out_pay,feedbackcancel);
    endpay endpaydisplay(state[8],clk,paysuccessful,returnone,returnten,seg_en_endpay,seg_out_endpay,out_endpaystate);


    assign seg_en=pre_seg_en;
    assign seg_out=pre_seg_out;

endmodule