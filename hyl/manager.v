`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/13 19:10:56
// Design Name: 
// Module Name: manager
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


module manager(
    input supply,//����ģʽ �ߵ�ƽ��Ч
    input reset,//��λ
    input [2:0] num,//������
    input [2:0] precount1,precount2,precount3,precount4,precount5,precount6,precount7,//����ǰ����
    output reg [2:0] count1,count2,count3,count4,count5,count6,count7,//����������
    output reg [2:0] maxsupply//���ɲ�����
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
        end//��λ �ߵ�ƽ��Ч
        else
        begin
            count1=precount1;
            count2=precount2;
            count3=precount3;
            count4=precount4;
            count5=precount5;
            count6=precount6;
            count7=precount7;
       end
       always @*
            begin
            if(supply)
            case(num)
            3'b001:  maxsupply=3'b111-precount1;
            3'b010:  maxsupply=3'b111-precount2;
            3'b011:  maxsupply=3'b111-precount3;
            3'b100:  maxsupply=3'b111-precount4;
            3'b101:  maxsupply=3'b111-precount5;
            3'b110:  maxsupply=3'b111-precount6;
            3'b111:  maxsupply=3'b111-precount7;
            default: maxsupply=3'b000;
            endcase
            else maxsupply=3'b000;
            end
endmodule
