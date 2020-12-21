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

module earn(
input EN,
input clk,
input [7:0] earn, 
output [7:0] seg_en,
output [7:0] seg_out
);
    //字符显示时钟分频（不用改�?
    reg clkout;
    reg [31:0] cnt;
    reg [6:0] scan_cnt;//显示不同字符的计数器
    parameter differentcharperiod=25000;
    
    //显示
    reg [7:0] seg_out_r;
    reg [7:0] seg_en_r;
    assign seg_out=~seg_out_r;
    assign seg_en=~seg_en_r;

    //显示总额
    wire [7:0] allone;
    wire [7:0] allten;
    wire [7:0] allhun;
    num_display ao(earn[3:0],allone);
    num_display at(earn[7:4],allten);

    //字符
    parameter E=7'b1111001;
    parameter n=7'b0110111;
    parameter A=7'b1110111;
    parameter r=7'b1110000;

    always @(posedge clk, negedge EN)
    begin
        if(!EN)
        begin
            clkout<=0;
            cnt<=0;
        end
        else if(cnt==(differentcharperiod>>1)-1) 
        begin
            clkout<=~clkout;
            cnt<=0;
        end
        else
        cnt<=cnt+1;
    end

    always @(posedge clkout, negedge EN)
    begin
        if(!EN)
        begin
            scan_cnt<=0;
        end
        else if(scan_cnt==7) scan_cnt<=0;
        else
        scan_cnt<=scan_cnt+1;
    end

    always @(scan_cnt)
    begin
        case(scan_cnt)
        0:seg_en_r=8'b0000_0001;
        1:seg_en_r=8'b0000_0010;
        2:seg_en_r=8'b0000_0100;
        3:seg_en_r=8'b0000_1000;
        4:seg_en_r=8'b0001_0000;
        5:seg_en_r=8'b0010_0000;
        6:seg_en_r=8'b0100_0000;
        7:seg_en_r=8'b1000_0000;
        endcase
    end

    always  @(scan_cnt)
    begin
    case(scan_cnt)
    0:seg_out_r=8'b0000_0000;
    1:seg_out_r=allone;
    2:seg_out_r=allten;
    3:seg_out_r=8'b0000_0000;
    4:seg_out_r={1'b0,n};
    5:seg_out_r={1'b0,r};
    6:seg_out_r={1'b0,A};
    7:seg_out_r={1'b0,E};
    endcase
    end


endmodule