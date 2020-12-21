`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/14 08:57:45
// Design Name: 
// Module Name: countdown
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


module pay(
input EN,
input clk,
input [3:0] paidone,
input [3:0] paidten,
input [3:0] costone,
input [3:0] costten,
output [7:0] seg_en,
output [7:0] seg_out,
output cancel
);
    //字符显示时钟分频（不用改）
    reg clkout;
    reg [31:0] cnt;
    reg [6:0] scan_cnt;//显示不同字符的计数器
    parameter differentcharperiod=100000;

    //倒计时
    reg [31:0] multiplier_timer;
    reg [3:0] onedigit;
    reg [3:0] tendigit; 
    // wire [7:0] onesdigitdisplay;
    wire [7:0] onesdigitdisplay;
    wire [7:0] tensdigitdisplay;
    
    //显示
    reg [7:0] seg_en_r;
    reg [7:0] seg_out_r;
    assign seg_out=~seg_out_r;
    assign seg_en=~seg_en_r;

    //已付应付显示
    wire [7:0] paidonedispaly;
    wire [7:0] paidtendispaly;
    wire [7:0] costonedispaly;
    wire [7:0] costtendispaly;

    //倒计时位数转换
    num_display transone(onedigit,onesdigitdisplay);
    num_display transten(tendigit,tensdigitdisplay);
    //已付应付转换
    num_display transone_paid(paidone,paidonedispaly);
    num_display transten_paid(paidten,paidtendispaly);
    num_display transone_cost(costone,costonedispaly);
    num_display tranten_cost(costten,costtendispaly);

    reg precancel;
    assign cancel=precancel;

    always@(posedge clk,negedge EN)//分频计数器
    begin
            if(!EN)
            begin
                clkout<=0;
                cnt<=0;
                multiplier_timer<=1;
                onedigit<=0;
                tendigit<=3;
                precancel<=0;
            end
            else if(cnt==(differentcharperiod>>1)-1)
            begin
                cnt<=0;
                clkout<=~clkout;
                multiplier_timer<=multiplier_timer+1;
                if(multiplier_timer==2000)
                begin
                    multiplier_timer<=1;
                    if(onedigit==0) 
                    begin
                        if(tendigit==0)
                        begin
                            precancel<=1;
                        end
                        else
                        begin
                            tendigit<=tendigit-1;
                            onedigit<=9;  
                        end
                    end
                    else
                    onedigit<=onedigit-1;//要是倒计时结束该怎么搞
                end
            end
            else
            cnt<=cnt+1;
            if(paidten>costone||(paidten==costten&&paidone>=costone))
            precancel<=1;
    end

    always @(posedge clkout,negedge EN)
    begin
            if(!EN)
            scan_cnt<=0;
            else if(scan_cnt==15) //总共16个字符
            begin
                scan_cnt<=0;
            end
            else
            scan_cnt<=scan_cnt+1;

    end

//使能信号
    always @(scan_cnt)
    begin
            case(scan_cnt)
            0: seg_en_r=8'b0000_0001;
            1: seg_en_r=8'b0000_0010;
            2: seg_en_r=8'b0000_0100;
            3: seg_en_r=8'b0000_1000;
            4: seg_en_r=8'b0001_0000;
            5: seg_en_r=8'b0010_0000;
            6 :seg_en_r=8'b0100_0000;
            7:seg_en_r=8'b1000_0000;
            endcase

    end

//显示的字符
    always @(scan_cnt)
    begin
            case(scan_cnt)
            0: seg_out_r=onesdigitdisplay;
            1: seg_out_r=tensdigitdisplay;
            2: seg_out_r=8'b0000_0000;
            3: seg_out_r=costonedispaly;
            4: seg_out_r=costtendispaly;
            5: seg_out_r=8'b0000_0000;
            6: seg_out_r=paidonedispaly;
            7: seg_out_r=paidtendispaly;
            endcase
    end
endmodule