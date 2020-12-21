`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 16:33:28
// Design Name: 
// Module Name: manager2
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


module manager2(
    input supply,//补货模式 高电平有效
    input reset,//复位
    input [2:0] num,//货道号
    input [2:0] count,//补货数量或取货数量
    input [2:0] precount1,precount2,precount3,precount4,precount5,precount6,precount7,//补货前数量
    output reg [2:0] count1,count2,count3,count4,count5,count6,count7//补货后数量
    );
    always @*
        if(reset)
        begin
            count1=3'b000;
            count2=3'b000;
            count3=3'b000;
            count4=3'b000;
            count5=3'b000;
            count6=3'b000;
            count7=3'b000;
        end//复位 高电平有效
        else
        begin
            if(supply)
                case(num)
                3'b001: count1=precount1+count;
                3'b010: count2=precount2+count;
                3'b011: count3=precount3+count;
                3'b100: count4=precount4+count;
                3'b101: count5=precount5+count;
                3'b110: count6=precount6+count;
                3'b111: count7=precount7+count;
                endcase
          end
endmodule
