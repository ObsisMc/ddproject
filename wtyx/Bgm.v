`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 23:37:40
// Design Name: 
// Module Name: pay_success
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


module Bgm(i_clk,play_successmusic,beep );
    input	   i_clk;		input play_successmusic;			//系统时钟50MHz	
    output    beep;                    //蜂鸣器输出端
    reg        beep_r;                //寄存器
    reg[5:0] state;                //乐谱状态机
    reg[16:0]count,count_end;
    reg[23:0]count1;
    //乐谱参数:D=F/2K  (D:参数,F:时钟频率,K:音高频率)
    parameter     L_5 = 17'd63776,  //低音5
                    L_7 = 17'd50618,    //低音7
                    M_1 = 17'd47774,    //中音1
                    M_2 = 17'd42568,    //中音2
                    M_4=17'd35791,//中音4
                    M_3 = 17'd37919,    //中音3
                    M_5 = 17'd31888;   //中音5
 parameter    TIME = 12000000;    //控制每一个音的长短(250ms)                                    
    assign beep = beep_r;            //输出音乐
    always@(posedge i_clk) begin
        count <= count + 1'b1;        //计数器加1
        if(count == count_end) begin    
            count <= 17'h0;            //计数器清零
            beep_r <= !beep_r;        //输出取反
        end
    end
    
    always @(posedge i_clk) begin
   if(play_successmusic)
    begin
       if(count1 < TIME)             //一个节拍250mS
          count1 = count1 + 1'b1;
       else begin
          count1 = 24'd0;
          if(state == 8'd17)
             state = 8'd0;
          else
             state = state + 1'b1;
       case(state)
       8'd0:count_end = M_1;  
        8'd1,8'd2:count_end=M_3;
        8'd3,8'd4:count_end=M_5;
        8'd5,8'd6:count_end=M_1;
        8'd7:count_end=M_3;
        8'd8:count_end=M_5;
        8'd9,8'd10:count_end=M_1;
       
        8'd11,8'd12:count_end=M_3;
        8'd13:count_end=M_5;
        8'd14:count_end=M_1;
        8'd15:count_end=M_3;
        8'd16,8'd17:count_end=M_5;
     
     
       default: count_end = 16'h0;
       endcase
       end
    end
    else
               count_end = 16'h0;
   end
   

endmodule

