`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/13 15:49:00
// Design Name: 
// Module Name: replenishment
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


module replenishment(
input en,
input re,//补货信号
input [2:0]number,//补货货道号
output reg[2:0] numbers
    );
      always @*
       begin
       if(re&&en)
         numbers=number;
        
         else
         numbers=0;
         end
    
endmodule
