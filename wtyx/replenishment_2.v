`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/13 16:09:09
// Design Name: 
// Module Name: replenishment_2
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


module replenishment_2(
input en,re,[6:0]count_in,//用户输入补货数
output reg[2:0] re_count//补货数
    );
     always @*
          begin
          if(re&&en)
          begin
             if(count_in==7'b1000000)
              re_count<=3'b001;

                else if(count_in==7'b0100000)
                    re_count<=3'b010;
               
                 else if(count_in==7'b0010000)
                       re_count<=3'b011;
                            
                     else if(count_in==7'b0001000)
                     re_count=3'b100;
                                     
                        else if(count_in==7'b0000100)
                       re_count=3'b101;
           
                     else if(count_in==7'b0000010)
                       re_count=3'b110;
                                                         
                        else if(count_in==7'b0000001)
                       re_count=3'b111;
                                                                          
                 end
            else 
            re_count=0;
            end
        
    
    
  
endmodule
