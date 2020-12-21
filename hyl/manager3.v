`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 16:54:01
// Design Name: 
// Module Name: manager3
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


module manager3(
    input wire enm3,
    input [6:0] turnover,//营业额
    input [2:0] num,//货道号
    input [4:0] sell1,sell2,sell3,sell4,sell5,sell6,sell7,
    output reg [3:0] sellnum10,//售货量十位
    output reg [3:0] sellnum1,//售货量个位
    output wire [3:0] turnover10,//营业额十位
    output wire [3:0] turnover1//营业额个位
    );
    assign turnover1=turnover%10;
    assign turnover10=turnover-turnover1;
    always@*
    if(enm3)
        case(num)
        3'b001:
            begin
            sellnum1=sell1%10;
            sellnum10=sell1-sellnum1;
            end
        3'b010:
            begin
            sellnum1=sell2%10;
            sellnum10=sell2-sellnum1;
            end
        3'b011:
            begin
            sellnum1=sell3%10;
            sellnum10=sell3-sellnum1;
            end 
        3'b100:
            begin
            sellnum1=sell4%10;
            sellnum10=sell4-sellnum1;
            end
        3'b101:
            begin
            sellnum1=sell5%10;
            sellnum10=sell5-sellnum1;
            end 
        3'b110:
            begin
            sellnum1=sell6%10;
            sellnum10=sell6-sellnum1;
            end
        3'b111:
            begin
            sellnum1=sell7%10;
            sellnum10=sell7-sellnum1;
            end 
        default:
            begin
            sellnum1=0;
            sellnum10=0;
            end
        endcase                     
endmodule
