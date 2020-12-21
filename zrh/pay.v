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
input rst,
input [3:0] paidone,
input [3:0] paidten,
input [3:0] costone,
input [3:0] costten,
output [7:0] seg_en,
output [7:0] seg_out
);
    //字符显示时钟分频（不用改）
    reg clkout;
    reg [31:0] cnt;
    reg [6:0] scan_cnt;//显示不同字符的计数器
    parameter differentcharperiod=25000;

    //倒计时
    reg [31:0] multiplier_timer;
    reg [3:0] onedigit;
    reg [3:0] tendigit; 
    wire [7:0] onesdigitdisplay;
    wire [7:0] tensdigitdisplay;
    
    //滚动相关
    reg [15:0] multiplier_roll;
    reg [6:0] offset_roll;
    
    //显示
    reg [4:0] seg_en_roll_r;
    reg [7:0] seg_out_r;
    reg [1:0] seg_en_time_r;
    assign seg_out=~seg_out_r;
    assign seg_en={~seg_en_time_r,1'b1,~seg_en_roll_r};

    //已付应付显示
    wire [7:0] paidonedispaly;
    wire [7:0] paidtendispaly;
    wire [7:0] costonedispaly;
    wire [7:0] costtendispaly;
    
    //字符
    parameter T=7'b0000111;
    parameter O=7'b0111111;
    parameter A=7'b1110111;
    parameter L=7'b0111000;
    parameter P=7'b1110011;
    parameter Y=7'b1100110;

    //倒计时位数转换
    num_display transone(onedigit,onesdigitdisplay);
    num_display transten(tendigit,tensdigitdisplay);
    //已付应付转换
    num_display transone_paid(paidone,paidonedispaly);
    num_display transten_paid(paidten,paidtendispaly);
    num_display transone_cost(costone,costonedispaly);
    num_display tranten_cost(costten,costtendispaly);

    always@(posedge clk,negedge rst)//分频计数器
    begin
        if(EN)
        begin
            if(!rst)
            begin
                clkout<=0;
                cnt<=0;
                multiplier_timer<=0;
                multiplier_roll<=0;
                offset_roll<=0;
                onedigit<=0;
                tendigit<=3;
            end
            else if(cnt==(differentcharperiod>>1)-1)
            begin
                cnt<=0;
                clkout<=~clkout;
                multiplier_roll<=multiplier_roll+1;
                multiplier_timer<=multiplier_timer+1;
                if(multiplier_roll==2800)
                begin
                    multiplier_roll<=0;
                    offset_roll<=offset_roll+1;
                    if(offset_roll==13) offset_roll<=0;//只有14个字符滚动
                end
                if(multiplier_timer==8000)
                begin
                    multiplier_timer<=0;
                    if(onedigit==0) 
                    begin
                        onedigit<=9;
                        tendigit<=tendigit-1;
                    end
                    else
                    onedigit<=onedigit-1;//要是倒计时结束该怎么搞
                end
            end
            else
            cnt<=cnt+1;
        end
        else
        cnt<=0;
    end

    always @(posedge clkout)
    begin
        if(EN)
        begin
            if(!rst)
            scan_cnt<=0;
            else if(scan_cnt==15) //总共16个字符
            begin
                scan_cnt<=0;
            end
            else
            scan_cnt<=scan_cnt+1;
        end
    end

//使能信号
    always @(scan_cnt)
    begin
        if(EN)
        begin
            if(scan_cnt==14)
            seg_en_time_r=2'b01;
            else if(scan_cnt==15)
            seg_en_time_r=2'b10;
            else
            case((scan_cnt+offset_roll)%14)
            9: seg_en_roll_r=5'b0_0001;
            10: seg_en_roll_r=5'b0_0010;
            11: seg_en_roll_r=5'b0_0100;
            12: seg_en_roll_r=5'b0_1000;
            13: seg_en_roll_r=5'b1_0000;
            default: seg_en_roll_r=8'b0000_0000;
            endcase
        end
        else
        begin
            seg_en_roll_r=5'b0;
            seg_en_time_r=2'b0;
        end
    end

//显示的字符
    always @(scan_cnt)
    begin
        if(EN)
        begin
            case(scan_cnt)
            0: seg_out_r={1'b0,L};
            1: seg_out_r={1'b0,A};
            2: seg_out_r={1'b0,T};
            3: seg_out_r={1'b0,O};
            4: seg_out_r={1'b0,T};
            5: seg_out_r=costonedispaly;
            6: seg_out_r=costtendispaly;
            7: seg_out_r=8'b0000_0000;
            8: seg_out_r={1'b0,Y};
            9: seg_out_r={1'b0,A};
            10: seg_out_r={1'b0,P};
            11: seg_out_r=paidonedispaly;
            12: seg_out_r=paidtendispaly;
            13: seg_out_r=8'b0000_0000;
            14: seg_out_r=onesdigitdisplay;
            15: seg_out_r=tensdigitdisplay;
            endcase
        end
        else
        seg_out_r=8'b0000_0000;
    end
endmodule