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
module display_admin_main(
input EN,
input clk,
input [20:0] left,//从0位开始为第一个货物剩余量
output [7:0] seg_en,
output [7:0] seg_out
    );
    //属性
    parameter price1=7'b1011011;//2
    parameter price2=7'b1001111;//3
    parameter price3=7'b1001111;//3
    parameter price4=7'b1100110;//4
    parameter price5=7'b1101101;//5
    parameter price6=7'b1101101;//5
    parameter price7=7'b0000111;//7
    
    wire [7:0] left1; num_display displayleft1(left[2:0],left1);
    wire [7:0] left2; num_display displayleft2(left[5:3],left2);
    wire [7:0] left3; num_display displayleft3(left[8:6],left3);
    wire [7:0] left4; num_display displayleft4(left[11:9],left4);
    wire [7:0] left5; num_display displayleft5(left[14:12],left5);
    wire [7:0] left6; num_display displayleft6(left[17:15],left6);
    wire [7:0] left7; num_display displayleft7(left[20:18],left7);
    
    //字符显示时钟分频（不用改）
    reg clkout;
    reg [31:0] cnt;
    reg [6:0] scan_cnt;//显示不同字符的计数器
    parameter differentcharperiod=25000;
    
    //滚动相关
    reg [15:0] multiplier;
    reg [6:0] offset;
    
    //显示
    reg [7:0] seg_out_r;
    reg [7:0] seg_en_r;
    assign seg_out=~seg_out_r;
    assign seg_en=~seg_en_r;
    
    //字符
    parameter one=7'b0000110;
    parameter two=7'b1011011;
    parameter thr=7'b1001111;
    parameter fou=7'b1100110;
    parameter fiv=7'b1101101;
    parameter six=7'b1111100;
    parameter sev=7'b0000111;
    parameter H=7'b1110110;
    parameter L=7'b0111000;
    parameter e=7'b1111011;
    parameter f=7'b1110001;
    parameter t=7'b1111000;
    
    always @(posedge clk, negedge EN)//分频：为显示不同字符
    begin
        if(!EN)
        begin
            cnt<=32'b0;
            clkout<=0;
            multiplier<=0;
            offset<=0;
        end
        else if(cnt==(differentcharperiod>>1)-1)
        begin
            cnt<=0;
            clkout<=~clkout;
            multiplier<=multiplier+1;
            if(multiplier==2800)
            begin
                multiplier<=0;
                offset<=offset+1;
                if(offset==7'd90) offset<=0;
            end
        end
        else
        cnt<=cnt+1;        
    end
    
    always @(posedge clkout, negedge EN)//显示不同字符的计数器
    begin
        if(!EN)
        scan_cnt<=0;
        else
        begin
            scan_cnt<=scan_cnt+1;
            if(scan_cnt==7'd90) scan_cnt<=7'd0;
        end
    end
    
    always @(scan_cnt)//显示字符的形状
    begin
            case(scan_cnt)//eg. 1.H1 2 4.left
            0: seg_out_r={1'b0,{t}};//d
            1: seg_out_r={1'b0,{f}};//e
            2: seg_out_r={1'b0,{e}};//e
            3: seg_out_r={1'b0,{L}};//n
            4: seg_out_r=left7;//剩余量
            5: seg_out_r=8'b0100_0000;
            6: seg_out_r={1'b0,{price7}};//price
            7: seg_out_r=8'b0100_0000;
            8: seg_out_r={1'b0,{sev}};//H7-7
            9: seg_out_r={1'b0,{H}};//H7-H
            10: seg_out_r={1'b1,{sev}};//7.
            11: seg_out_r=8'b0000_0000;
            12: seg_out_r=8'b0000_0000;

            13: seg_out_r={1'b0,{t}};//d
            14: seg_out_r={1'b0,{f}};//e
            15: seg_out_r={1'b0,{e}};//e
            16: seg_out_r={1'b0,{L}};//n
            17: seg_out_r=left6;//剩余量
            18: seg_out_r=8'b0100_0000;
            19: seg_out_r={1'b0,{price6}};//price6
            20: seg_out_r=8'b0100_0000;
            21: seg_out_r={1'b0,{six}};//H6-6
            22: seg_out_r={1'b0,{H}};//H6-H
            23: seg_out_r={1'b1,{six}};//6.
            24: seg_out_r=8'b0000_0000;
            25: seg_out_r=8'b0000_0000;
    
            26: seg_out_r={1'b0,{t}};//d
            27: seg_out_r={1'b0,{f}};//e
            28: seg_out_r={1'b0,{e}};//e
            29: seg_out_r={1'b0,{L}};//n
            30: seg_out_r=left5;//剩余量
            31: seg_out_r=8'b0100_0000;
            32: seg_out_r={1'b0,{price5}};//price
            33: seg_out_r=8'b0100_0000;
            34: seg_out_r={1'b0,{fiv}};//H5-5
            35: seg_out_r={1'b0,{H}};//H5-H
            36: seg_out_r={1'b1,{fiv}};//5.
            37: seg_out_r=8'b0000_0000;
            38: seg_out_r=8'b0000_0000;
    
            39: seg_out_r={1'b0,{t}};//d
            40: seg_out_r={1'b0,{f}};//e
            41: seg_out_r={1'b0,{e}};//e
            42: seg_out_r={1'b0,{L}};//n
            43: seg_out_r=left4;//剩余量
            44: seg_out_r=8'b0100_0000;
            45: seg_out_r={1'b0,{price4}};//price
            46: seg_out_r=8'b0100_0000;
            47: seg_out_r={1'b0,{fou}};//H4-4
            48: seg_out_r={1'b0,{H}};//H4-H
            49: seg_out_r={1'b1,{fou}};//4.
            50: seg_out_r=8'b0000_0000;
            51: seg_out_r=8'b0000_0000;
    
            52: seg_out_r={1'b0,{t}};//d
            53: seg_out_r={1'b0,{f}};//e
            54: seg_out_r={1'b0,{e}};//e
            55: seg_out_r={1'b0,{L}};//n
            56: seg_out_r=left3;//剩余量
            57: seg_out_r=8'b0100_0000;
            58: seg_out_r={1'b0,{price3}};//price
            59: seg_out_r=8'b0100_0000;
            60: seg_out_r={1'b0,{thr}};//H3-3
            61: seg_out_r={1'b0,{H}};//H3-H
            62: seg_out_r={1'b1,{thr}};//3.
            63: seg_out_r=8'b0000_0000;
            64: seg_out_r=8'b0000_0000;
    
            65: seg_out_r={1'b0,{t}};//d
            66: seg_out_r={1'b0,{f}};//e
            67: seg_out_r={1'b0,{e}};//e
            68: seg_out_r={1'b0,{L}};//n
            69: seg_out_r=left2;//剩余量
            70: seg_out_r=8'b0100_0000;
            71: seg_out_r={1'b0,{price2}};//price
            72: seg_out_r=8'b0100_0000;
            73: seg_out_r={1'b0,{two}};//H2-2
            74: seg_out_r={1'b0,{H}};//H2-H
            75: seg_out_r={1'b1,{two}};//2.
            76: seg_out_r=8'b0000_0000;
            77: seg_out_r=8'b0000_0000;
            
            78: seg_out_r={1'b0,{t}};//d
            79: seg_out_r={1'b0,{f}};//e
            80: seg_out_r={1'b0,{e}};//e
            81: seg_out_r={1'b0,{L}};//n
            82: seg_out_r=left1;//剩余量
            83: seg_out_r=8'b0100_0000;
            84: seg_out_r={1'b0,{price1}};//price
            85: seg_out_r=8'b0100_0000;        
            86: seg_out_r={1'b0,{one}};//H1-1
            87: seg_out_r={1'b0,{H}};//H1-H
            88: seg_out_r={1'b1,{one}};//1.
            89: seg_out_r=8'b0000_0000;
            90: seg_out_r=8'b0000_0000;
            endcase
    end
       
    always @(scan_cnt)//显示字符的位置
    begin
            case((scan_cnt+offset)%91)
            7'd83:seg_en_r=8'b0000_0001;
            7'd84:seg_en_r=8'b0000_0010;
            7'd85:seg_en_r=8'b0000_0100;
            7'd86:seg_en_r=8'b0000_1000;
            7'd87:seg_en_r=8'b0001_0000;
            7'd88:seg_en_r=8'b0010_0000;
            7'd89:seg_en_r=8'b0100_0000;
            7'd90:seg_en_r=8'b1000_0000;
            default: seg_en_r=8'b0000_0000;
            endcase
    end
endmodule