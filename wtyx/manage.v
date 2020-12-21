`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/06 20:27:55
// Design Name: 
// Module Name: manage
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


module manage(
   input[4:0] password,
   input rst,
   input in,
   input re,
   input[2:0]number,
   input[6:0]count_in,
   output reg en,
   output reset,//管理员将货物数置零->hyl
   output [2:0]numbers, //补货货道号zrh
   output inquire,
   output [2:0]re_count);

    reset_0 used1(en,rst,reset);
    replenishment used2(en,re,number,numbers);
    replenishment_2 used3(en,re,count_in,re_count);
    inquire used4(en,in,inquire);
      
   always @*
   begin
   casex({password[5],password[4],password[3],password[2],password[1],password[0]})
     5'b01011:en=1'b1;
   default:
    en=1'b0;
    endcase
    end
endmodule
