`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/22 18:57:07
// Design Name: 
// Module Name: machine
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



//售货机顶层设计，设计大致是分成输入、计算、输出三个模块
module machinex(
  input clk,
  input rst,//0为初始状态，1为主界面（滚动显示3个商品信息），用于复位
  input [3:0] row,//键盘行
  input isenquire,//是否进入管理员或用户的查询状态
  input setzero,//管理员将所有商品数量置为0的开关
  input replenish,//确认补货
  input [1:0] addcount,//补货时选择补货的数量，一次补货最多为3
  input [3:0] password,//管理员密码的输入
  input [1:0] buynum,//用户购买的商品数量
  input [1:0] money,//用户付的钱
  output reg [3:0] col,//键盘列     
  output reg key_pressed_flag, //显示键盘是否被按住 
  output[7:0]seg_en,//数码管使能
  output[7:0]seg_out,//数码管显示
  output beep//蜂鸣器
);

//货物属性
//货物剩余量
reg [1:0]count1=2'b11;//一号货物剩余量，初始为3，最多3个
reg [1:0]count2=2'b11;//2号货物剩余量，初始为3
reg [1:0]count3=2'b00;//3号货物剩余量，初始为0
reg [1:0]precount=2'b00;//选择某一货物并确定后，该商品的货物数
//货物单价
reg [1:0] price1=1;//1号单价，最高3元
reg [1:0] price2=2;//2号单价
reg [1:0] price3=3;//3号单价
reg [1:0] price=2'b00;//选择某一货物并确定后，该商品的单价
//每个商品卖出数量
reg [3:0] sellnum1=4'b0;//1号，最多15个
reg [3:0] sellnum2=4'b0;//2号
reg [3:0] sellnum3=4'b0;//3号
reg [3:0] presellnum=4'b0000;//选择的那个商品的卖出数量
wire [3:0] presellnum1;//选择的那个商品的卖出数量的个位，用于显示
wire [3:0] presellnum10;//选择的那个商品的卖出数量的十位，用于显示

//销售情况
//销售总金额
reg [3:0] income=4'b0;
wire [3:0] income1;//销售金额个位
wire [3:0] income2;//十位
reg intoincomedisplay=1'b0;//是否在查看总销售额状态
//应付金额
wire [3:0] shouldpay;//应付总金额，最多15元
wire [3:0] shouldpay1;//应付总金额的个位，用于显示
wire [3:0] shouldpay2;//应付总金额的十位，用于显示
//找零/退钱金额
reg [3:0] return;//找零，最多15元
wire [3:0] returnone;//找零个位，用于显示
wire [3:0] returnten;//找零十位，用于显示
//付款
reg [3:0] sumpaid=4'b0000;//实付金额
reg [1:0] cantopay=2'b10;//是否能进入付款，0为不能进入，1为进入，默认2无状态
reg issuccessfulpaid=1'b0;//是否成功付款
//补货
reg ifhasensure=1'b0;//是否已经拨上确认补货的开关

//其他
reg back;//返回键（未使用，已用其他方式实现返回）
reg ensure;//确认键
reg [1:0] keyboard_val;//键盘值（未使用）
reg [1:0]number=2'b00;//选择的货道号
reg [1:0]lastnumber=2'b00;//记录上一个选择的货道号

//倒计时有关
reg clkout;
reg [31:0] countdowncnt;
parameter counterdownperiod=100000000*30;//30秒
reg endpay=1'b0;//是否结束付款阶段，倒计时结束或者实付金额大于等于应付时结束


//--------计算模块，无实例化，直接放上代码--------
//wire的连续赋值
//选择的商品的售出量按基数为10的位输出
assign presellnum1=(presellnum>=10?presellnum-10:presellnum);
assign presellnum10=presellnum[3]&(presellnum[2]|presellnum[1]);
//营业额按位输出
assign income1=(income>=10?income-10:income);
assign income2=income[3]&(income[2]|income[1]);
//应付
assign shouldpay=buynum*price;//购买数量乘选择的货物的单价
assign shouldpay1=(shouldpay>=10?shouldpay-10:shouldpay);
assign shouldpay2=shouldpay[3]&(shouldpay[2]|shouldpay[1]);
//退钱找零
assign returnone=(return>=10?return-10:return);
assign returnten=return[3]&(return[2]|return[1]);

//选择的货道号的货物数
always@(posedge clk)
begin
  case (lastnumber)
    1: precount<=count1;
    2: precount<=count2;
    3: precount<=count3; 
    default: precount<=0;
  endcase
end
//选择的货道号的单价
always @(posedge clk,negedge rst)
begin
  if(!rst)
  price<=0;
  else
  case(lastnumber)
  1:price<=price1;
  2:price<=price2;
  3:price<=price3;
  default: price<=0;
  endcase
end
//付款金额
always@(posedge clk,negedge rst)
begin
  if(~rst)
  sumpaid<=0;
  else
  begin
    if(money==2'b01)
    sumpaid=1;
    else if(money==2'b10)
    sumpaid=5;
    else if(money==2'b11)
    sumpaid=10;
    else
    sumpaid=0;
  end
end

//选择查看的货道的卖出数
always @(posedge clk,negedge rst)
begin
  if(~rst)
  begin
    presellnum<=0;
  end
  else
  case(lastnumber)
  1: presellnum<=sellnum1;
  2: presellnum<=sellnum2;
  3: presellnum<=sellnum3;
  default: presellnum<=0;
  endcase
end

//判断是否要结束付款阶段
always@(posedge clk, negedge rst)
begin
  if(!rst)
  begin
    countdowncnt<=0;
    clkout<=0;
    endpay<=0;
    issuccessfulpaid<=0;
    return<=0;
    ifhasensure<=0;
  end
  else if(password!=4'b1010)//非管理员模式下
  begin
    if(cantopay==1&&~endpay)
    begin
      if(countdowncnt==counterdownperiod-1||sumpaid>=shouldpay)//若时间到30s或者实付大于等于应付
      begin
        endpay<=1;//结束付款阶段
        if(sumpaid>=shouldpay)//判断是否是购买成功，如果购买成功则改变营业额、销售量等
        begin
          return<=sumpaid-shouldpay;
          issuccessfulpaid<=1;  
          if(price==price1)
          begin
            sellnum1<=sellnum1+buynum;
            count1<=count1-buynum;
            income<=income+shouldpay;
          end
          else if(price==price2)
          begin
            sellnum2<=sellnum2+buynum;
            count2<=count2-buynum;
            income<=income+shouldpay;
          end
          else if(price==price3)
          begin
            sellnum3<=sellnum3+buynum;
            count3<=count3-buynum;
            income<=income+shouldpay;
          end      
        end
        else
        return<=sumpaid;
      end
      else
      countdowncnt<=countdowncnt+1;
    end
  end
  else//管理员模式
  begin
    if(setzero)//管理员复位
    begin
      count1<=0;
      count2<=0;
      count3<=0;
    end
    else if(replenish&&~ifhasensure)//补货操作
    begin
      if(lastnumber==1)
      begin
        count1<=count1+addcount;
      end
      else if(lastnumber==2)
      begin
        count2<=count2+addcount;
      end
      else if(lastnumber==3)
      begin
        count3<=count3+addcount;
      end
      ifhasensure<=1;
    end
    else if(~replenish)
    begin
      ifhasensure<=0;
    end
  end
end

//---------输出模块，有蜂鸣器和数码管的实例化---------
//蜂鸣器模块
Bgm used(
  .cantopay(cantopay),
  .endpay(endpay),
  .pay_success(issuccessfulpaid),
  .i_clk(clk),
  .rst(rst),
  .play_Bgm(isenquire),
  .key_pressed(key_pressed_flag),
  .beep(beep)
  );

//数码管模块
project_display_top display(
  .clk(clk),
  .rst(rst),
  .isenquire(isenquire),
  .endpay(endpay),
  .adminpasswd(password),
  .issuccessfulpaid(issuccessfulpaid),
  .canintopay(cantopay),
  .paidone(sumpaid%10),
  .paidten(sumpaid/10),
  .costone(shouldpay1),
  .costten(shouldpay2),
  .returnone(returnone),
  .returnten(returnten),
  .isintoincome(intoincomedisplay),
  .income1(income1),
  .income2(income2),
  .sellnum1(presellnum1),
  .sellnum10(presellnum10),
  .choose(number),
  .goodleft({count3,count2,count1}),
  .seg_en(seg_en),
  .seg_out(seg_out)
  );


//---------输入模块,对键盘的输入进行转换，没有实例化直接放入代码。拨码开关的输入不需要转换--------
//键盘
//++++++++++++++++++++++++++++++++++++++
reg [19:0] cnt;                      

always @ (posedge clk, negedge rst)
  if (!rst)
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
// ״̬�����٣����������????
parameter NO_KEY_PRESSED = 6'b000_001;  
parameter SCAN_COL0      = 6'b000_010;  
parameter SCAN_COL1      = 6'b000_100; 
parameter SCAN_COL2      = 6'b001_000;  
parameter SCAN_COL3      = 6'b010_000; 
parameter KEY_PRESSED    = 6'b100_000;  

reg [5:0] current_state, next_state;    

always @ (posedge key_clk, negedge rst)
  if (!rst)
    current_state <= NO_KEY_PRESSED;
  else
    current_state <= next_state;

// ��������ת��״̬
always @ *
  case (current_state)
    NO_KEY_PRESSED :                   
        if (row != 4'hF)
          next_state = SCAN_COL0;
        else
          next_state = NO_KEY_PRESSED;
    SCAN_COL0 :                      
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = SCAN_COL1;
    SCAN_COL1 :                     
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = SCAN_COL2;    
    SCAN_COL2 :                        
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = SCAN_COL3;
    SCAN_COL3 :                      
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = NO_KEY_PRESSED;
    KEY_PRESSED :                    
        if (row != 4'hF)
          next_state = KEY_PRESSED;
        else
          next_state = NO_KEY_PRESSED;                      
  endcase

     
reg [3:0] col_val, row_val;             


always @ (posedge key_clk, negedge rst)
  if (!rst)
  begin
    col              <= 4'h0;
    key_pressed_flag <= 0;
  end
  else
    case (next_state)
      NO_KEY_PRESSED :              
      begin
        col              <= 4'h0;
        row_val              <=4'hf;
        key_pressed_flag <=    0;       
      end
      SCAN_COL0 :                      
      begin
        col <= 4'b1110;
         row_val              <=4'hf;
        end
      SCAN_COL1 :                 
      begin
        col <= 4'b1101;
         row_val              <=4'hf;
         end
      SCAN_COL2 :                      
      begin
        col <= 4'b1011;
         row_val              <=4'hf;
         end
      SCAN_COL3 :                
      begin
        col <= 4'b0111;
         row_val              <=4'hf;
         end
      KEY_PRESSED :                 
      begin
        col_val          <= col;       
        row_val          <= row;        
        key_pressed_flag <= 1;         
      end
    endcase

//++++++++++++++++++++++++++++++++++++++
always @ (posedge key_clk, negedge rst)
  if (!rst)
  begin
    keyboard_val = 2'b0;
    number=0;
    cantopay=2;
    ensure=0;
    intoincomedisplay=0;
  end
  else
    if (key_pressed_flag)
    begin
      case ({col_val, row_val})
        8'b1110_1110 : 
        begin
        keyboard_val = 2'b01;
        number=2'b01;
        intoincomedisplay=0;
        end
        8'b1110_0111 :
        begin
          keyboard_val=0;
          number=0; 
          intoincomedisplay=0;
        end
        8'b1101_1110 : 
        begin
        keyboard_val = 2'b10;
        number=2'b10;
        intoincomedisplay=0;
        end
        8'b1011_1110 : 
        begin
        keyboard_val = 2'b11;
        number=2'b11;
        intoincomedisplay=0;
        end
        8'b0111_1110:
        begin
          intoincomedisplay=1;
        end
        8'b1011_0111 :
        begin
          if(precount>=1)
          begin
            ensure=1;
            cantopay=1;
          end
          else if(precount==0)
          begin
            ensure=0;
            cantopay=0;
          end
        end
        
        //8'b0111_1110 : keyboard_val <= 4'b1010; 
        //8'b0111_1101 : keyboard_val <= 4'b1011;
        //8'b0111_1011 : keyboard_val <= 4'b1100;
        //8'b0111_0111 : keyboard_val <= 4'b1101;  
        default:
        begin
          keyboard_val=2'b00;
          // number=2'b00;
          ensure=0;
          intoincomedisplay=0;
         // back<=0; number==0����������
        end
      endcase
      lastnumber=number;
    end
    else
    begin
        keyboard_val=2'b00;
        ensure<=0;//ensureһֱΪ1�����븶��ʱ
    end

//--------------------------------------
//  ɨ������ֵ���� ����
//--------------------------------------
      
endmodule
