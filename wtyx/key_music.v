`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/18 19:35:38
// Design Name: 
// Module Name: key_music
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


module key_music(clk,en,beep );
    input	   clk;
    input      en;					//ϵͳʱ��50MHz	
    output    beep;                    //�����������
    reg        beep_r;                //�Ĵ���
    reg[5:0] state;                //����״̬��
    reg[16:0]count,count_end;
    reg[23:0]count1;
    //���ײ���:D=F/2K  (D:����,F:ʱ��Ƶ��,K:����Ƶ��)
    parameter     L_5 = 17'd63776,  //����5
                    L_7 = 17'd50618,    //����7
                    M_1 = 17'd47774,    //����1
                    M_2 = 17'd42568,    //����2
                    M_4=17'd35791,//����4
                    M_3 = 17'd37919,    //����3
                    M_5 = 17'd31888;   //����5
 parameter    TIME = 12000000;    //����ÿһ�����ĳ���(250ms)                                    
    assign beep = beep_r;            //�������
    always@(posedge clk) begin
        count <= count + 1'b1;        //��������1
        if(count == count_end) begin    
            count <= 17'h0;            //����������
            beep_r <= !beep_r;        //���ȡ��
        end
    end
    always @(posedge clk) begin
    if(en)
    begin
       if(count1 < TIME)             //һ������250mS
          count1 = count1 + 1'b1;
       else begin
          count1 = 24'd0;
          if(state == 8'd51)
             state = 8'd0;
          else
             state = state + 1'b1;
       case(state)
       8'd0:count_end = M_1;  
        8'd1,8'd2:count_end=M_1;
        8'd3,8'd4:count_end=M_1;
        8'd5,8'd6:count_end=L_5;
        8'd7:count_end=M_3;
        8'd8:count_end=M_3;
        8'd9,8'd10:count_end=M_3;
       
        8'd11,8'd12:count_end=M_1;
        8'd13:count_end=M_1;
        8'd14:count_end=M_1;
        8'd15:count_end=M_3;
        8'd16,8'd17:count_end=M_5;
        8'd18,8'd19:count_end=M_5;
        
        8'd20:count_end=M_4;
        8'd21:count_end=M_3;
        8'd22,8'd23,8'd24,8'd25:count_end=M_2;
        8'd26:count_end=M_2;
        8'd27:count_end=M_3;
        8'd28,8'd29:count_end=M_4;
        
        8'd30,8'd31:count_end=M_4;
        
        8'd32:count_end = M_3;  
        8'd33:count_end=M_2;
        8'd34,8'd35:count_end=M_3;
        8'd36,8'd37:count_end=M_1;
        8'd38:count_end=M_1;
        8'd39:count_end=M_3;
       
        8'd40,8'd41:count_end=M_2;
        8'd42,8'd43:count_end=L_5;
        8'd44:count_end=L_7;
        8'd45:count_end=M_2;
        8'd46,8'd47,8'd48,8'd49,8'd50,8'd51:count_end=M_1;
       
       default: count_end = 16'h0;
       endcase
       end
    end
    else
    count_end = 16'h0;
    end
   

endmodule
