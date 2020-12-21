`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 12:04:07
// Design Name: 
// Module Name: enter_pay
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


module enter_pay( //拨下来有问题吗？
    input cancel,
    input [2:0] count,//货物数量
    input[6:0]count_in,//用户购买数量
    input in,//是否查询
    output reg[2:0] buy_count,//实际购买数量
    output reg enterpay//进入付款
    );
     always@*
       begin
       if(in)
       begin
       if(count==0||cancel==1)
        enterpay<=0;
        else
        if(count_in==7'b1000000)
             begin
             enterpay<=1;
             buy_count=3'b001;
             end
       else if(count_in==7'b0100000)
             begin
                 enterpay<=1;
                 buy_count=3'b010;
                 end
        else if(count_in==7'b0010000)
                          begin
                              enterpay<=1;
                              buy_count=3'b011;
                              end
            else if(count_in==7'b0001000)
                                       begin
                                           enterpay<=1;
                                           buy_count=3'b100;
                                           end
               else if(count_in==7'b0000100)
                                                    begin
                                                        enterpay<=1;
                                                        buy_count=3'b101;
                                                        end
            else if(count_in==7'b0000010)
                                                                 begin
                                                                     enterpay<=1;
                                                                     buy_count=3'b110;
                                                                     end
               else if(count_in==7'b0000001)
                                                       begin
                                                                     enterpay<=1;
                                                                      buy_count=3'b111;
                                                 end                                                          
        end
        end
endmodule
