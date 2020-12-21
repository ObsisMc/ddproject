`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/13 19:19:04
// Design Name: 
// Module Name: keyboard
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


module keyboard(
  input            i_clk,
  input            i_rst_n,
  input      [3:0] row,
  input [2:0] count1,//1~7�?有剩余数�?
  input [2:0] count2,
  input [2:0] count3,
  input [2:0] count4,
  input [2:0] count5,
  input [2:0] count6,
  input [2:0] count7,
  input [6:0] count_in,//用户购买数量
  input [4:0]password,//管理密码
  input rst,//管理员置�?
  input in,//管理员查�?
  input re,//补货状�??
  input total,
  output total_out,
  //output reg[2:0] paid,//输入的钱
  output en,//1为管理员状�??
  output reset,//给hyl复位
  output inquire,//给zrh查询
  output [2:0]re_count,//补货�?
  output [2:0]buy_count,//购买�?
  output      enterpay,//是否进入支付阶段
  output [2:0] number,//查询给zrh货道�?
  output [2:0] number_inquire,//用户查询货道�?
  output [2:0] buy_number,//购买的货物的货道�?
  output reg back,//返回
  output reg ensure,     //确认      
  output reg [3:0] col,   //键盘�?           
  output reg [2:0] keyboard_val ,//键盘输出�?
  output reg key_pressed_flag,  //是否按键�?
  output beep,
  output paid
);
reg [2:0] pre_count=3'b111;
wire [2:0] count;
Inquire_top used1(keyboard_val,i_rst_n,ensure,number_inquire,buy_number);//用户
enter_pay used2(count,count_in,i_rst_n,buy_count,enterpay);
manage used3(password,rst,in,re,keyboard_val,count_in,en,reset,number,inquire,re_count);//管理员顶�?
Bgm used4(i_clk,key_pressed_flag,in,beep);
total_sales used6(total,total_out);
duringpay dp(enterpay,keyboard_val,paid);


assign count=pre_count;

always @(keyboard_val)
begin
  case(keyboard_val)
  1:pre_count=count1;
  2:pre_count=count2;
  3:pre_count=count3;
  4:pre_count=count4;
  5:pre_count=count5;
  6:pre_count=count6;
  7:pre_count=count7;
  default: pre_count=3'b111;
  endcase
end

//++++++++++++++++++++++++++++++++++++++
// ��Ƶ���� ��ʼ
//++++++++++++++++++++++++++++++++++++++
reg [19:0] cnt;                         // ������

always @ (posedge i_clk, negedge i_rst_n)
  if (!i_rst_n)
    cnt <= 0;
  else
    cnt <= cnt + 1'b1;

wire key_clk = cnt[19];                // (2^20/50M = 21)ms 
//--------------------------------------
// ��Ƶ���� ����
//--------------------------------------

//++++++++++++++++++++++++++++++++++++++
// ״̬������ ��ʼ
//++++++++++++++++++++++++++++++++++++++
// ״̬�����٣����������?
parameter NO_KEY_PRESSED = 6'b000_001;  // û�а�������  
parameter SCAN_COL0      = 6'b000_010;  // ɨ���?0�� 
parameter SCAN_COL1      = 6'b000_100;  // ɨ���?1�� 
parameter SCAN_COL2      = 6'b001_000;  // ɨ���?2�� 
parameter SCAN_COL3      = 6'b010_000;  // ɨ���?3�� 
parameter KEY_PRESSED    = 6'b100_000;  // �а�������

reg [5:0] current_state, next_state;    // ��̬����̬

always @ (posedge key_clk, negedge i_rst_n)
  if (!i_rst_n)
    current_state <= NO_KEY_PRESSED;
  else
    current_state <= next_state;

// ��������ת��״̬
always @ *
  case (current_state)
    NO_KEY_PRESSED :                    // û�а�������
        if (row != 4'hF)
          next_state = SCAN_COL0;
        else
          next_state = NO_KEY_PRESSED;
    SCAN_COL0 :                         // ɨ���?0�� 
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = SCAN_COL1;
    SCAN_COL1 :                         // ɨ���?1�� 
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = SCAN_COL2;    
    SCAN_COL2 :                         // ɨ���?2��
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = SCAN_COL3;
    SCAN_COL3 :                         // ɨ���?3��
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = NO_KEY_PRESSED;
    KEY_PRESSED :                       // �а�������
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = NO_KEY_PRESSED;                      
  endcase

          // ���̰��±�־
reg [3:0] col_val, row_val;             // ��ֵ����ֵ

// ���ݴ�̬������Ӧ�Ĵ�����ֵ
always @ (posedge key_clk, negedge i_rst_n)
  if (!i_rst_n)
  begin
    col              <= 4'h0;
    key_pressed_flag <=    0;
  end
  else
    case (next_state)
      NO_KEY_PRESSED :                  // û�а�������
      begin
        col              <= 4'h0;
        row_val              <=4'hf;
        key_pressed_flag <=    0;       // ����̰��±��?
      end
      SCAN_COL0 :                       // ɨ���?0��
      begin
        col <= 4'b1110;
         row_val              <=4'hf;
        end
      SCAN_COL1 :                       // ɨ���?1��
      begin
        col <= 4'b1101;
         row_val              <=4'hf;
         end
      SCAN_COL2 :                       // ɨ���?2��
      begin
        col <= 4'b1011;
         row_val              <=4'hf;
         end
      SCAN_COL3 :                       // ɨ���?3��
      begin
        col <= 4'b0111;
         row_val              <=4'hf;
         end
      KEY_PRESSED :                     // �а�������
      begin
        col_val          <= col;        // ������ֵ
        row_val          <= row;        // ������ֵ
        key_pressed_flag <= 1;          // �ü��̰��±�־  
      end
    endcase
//--------------------------------------
// ״̬������ ����
//--------------------------------------


//++++++++++++++++++++++++++++++++++++++
// ɨ������ֵ���� ��ʼ
//++++++++++++++++++++++++++++++++++++++
always @ (posedge key_clk, negedge i_rst_n)
  if (!i_rst_n)
    keyboard_val <= 4'b0;
  else
    if (key_pressed_flag)
      case ({col_val, row_val})
        8'b1110_1110 : keyboard_val <= 3'b001;
        8'b1110_1101 : keyboard_val <= 3'b100;
        8'b1110_1011 : keyboard_val <= 3'b111;
        8'b1110_0111 : back<=1;
        
        8'b1101_1110 : keyboard_val <= 3'b010;
        8'b1101_1101 : keyboard_val <= 3'b101;
        //8'b1101_1011 : keyboard_val <= 4'b1000;
        8'b1101_0111 : keyboard_val <= 3'b000;
        
        8'b1011_1110 : keyboard_val <= 3'b011;
        8'b1011_1101 : keyboard_val <= 3'b110;
        //8'b1011_1011 : keyboard_val <= 4'b1001;
        8'b1011_0111 :ensure<=1;
        
        //8'b0111_1110 : keyboard_val <= 4'b1010; 
        //8'b0111_1101 : keyboard_val <= 4'b1011;
        //8'b0111_1011 : keyboard_val <= 4'b1100;
        //8'b0111_0111 : keyboard_val <= 4'b1101;  
        default:
        begin
          keyboard_val<=3'b000;
          ensure<=0;
          back<=0;
        end
      endcase
     else
     begin
         keyboard_val<=3'b000;
         ensure<=0;
         back<=0;
         end

//--------------------------------------
//  ɨ������ֵ���� ����
//--------------------------------------
      
endmodule
