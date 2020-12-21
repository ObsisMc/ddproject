`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/06 20:51:13
// Design Name: 
// Module Name: reset_0
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


module reset_0(
input en,rst,
output reg reset
    );
     always @*
     begin
     if(rst&&en)
    
       reset<=1;
    
       else 
    
       reset<=0;
    
       end
endmodule
