module system_top(
    input clk,
    input rst,
    input [3:0] keyrow,
    input [4:0] password,
    input [6:0] customer_buycount,//用户购买数或管理员补�?
    input isenquire,//是否在查询阶�?
    input adminsetzero,//是否置为�?
    input isreplenish,//是否补货
    input istotalincome,//是否在�?�销售额状�??
    output [7:0] seg_en,
    output [7:0] seg_out,
    output beep
);

    //keyboard输出
    wire en;//1为管理员状�??
    wire reset;//给hyl复位
    wire inquire;//给zrh查询
    wire [2:0]re_count;//补货�?
    wire [2:0]buy_count;//购买�?
    wire enterpay;//是否进入支付阶段
    wire [2:0] number;//查询给zrh货道�?
    wire [2:0] number_inquire;//用户选择货道
    wire [2:0] buy_number;//购买的货物的货道�?
    wire back;//返回
    wire ensure;    //确认         
    wire [3:0] col;   //键盘�?           
    wire [2:0] keyboard_val ;//键盘输出�?
    wire key_pressed_flag;  //是否按键�?
    wire total_out;
    wire [2:0] onetimepaid;
    
     wire [2:0] count1,count2,count3,count4,count5,count6,count7;//商品现存数量

    keyboard keybd(
        .i_clk(clk),
        .i_rst_n(rst),
        .row(keyrow),
        .count1(count1),
        .count2(count2),
        .count3(count3),
        .count4(count4),
        .count5(count5),
        .count6(count6),
        .count7(count7),
        .count_in(customer_buycount),
        .password(password),
        .rst(adminsetzero),
        .in(isenquire),
        .re(isreplenish),
        .en(en),
        .reset(reset),
        .inquire(inquire),
        .re_count(re_count),
        .buy_count(buy_count),
        .enterpay(enterpay),
        .number(number),
        .number_inquire(number_inquire),
        .buy_number(buy_number),
        .back(back),
        .ensure(ensure),
        .col(col),
        .keyboard_val(keyboard_val),
        .key_pressed_flag(key_pressed_flag),
        .beep(beep),
        .total_out(total_out),
        .total(istotalincome),
        .paid(onetimepaid)
        //paid�?要写吗？
    );

    //processor输出
    wire [3:0] sellnum10;//售货量十�?
    wire [3:0] sellnum1;//售货量个�?
    wire [2:0] maxsupply;//�?大可补数�?
    wire [3:0] pay1;//应付多少钱（用于显示�?
    wire [3:0] pay10;
    wire [3:0] payback1;
    wire [3:0] payback10;//找零
    wire [3:0] turnover1;//营业额个�?
    wire [3:0] turnover10;//营业额十�?
    wire successpay;
    wire [3:0] paid1;
    wire [3:0] paid10;
    // //输入
    // reg preprocessor_num;
    // reg preprocessor_count;
    // reg preprocessor_money;
    // wire processor_num;
    // wire processor_count;
    // wire processor_money;
    // assign processor_num=preprocessor_num;
    // assign processor_count=preprocessor_count;
    // assign processor_money=preprocessor_money;

    // always @(keyboard_val)
    // begin
    //     if(keyboard_val!=0)
    //     begin
    //         if(isenquire)
    //         begin
    //         preprocessor_num<=keyboard_val;
    //         preprocessor_count<=keyboard_val;   
    //         preprocessor_money<=keyboard_val;         
    //         end           
    //     end
    // end
    
    wire cancel;

    processor calculate(
        .enm3(istotalincome),
        .enc(enterpay),
        .supply(isreplenish),
        .reset(reset),
        .num(number_inquire),
        .count(re_count),
        .buycount(buy_count),
        .money(onetimepaid),//使用键盘�?
        .cancel(cancel),//。�?��??
        .sellnum10(sellnum10),
        .sellnum1(sellnum1),
        .count1(count1),
        .count2(count2),
        .count3(count3),
        .count4(count4),
        .count5(count5),
        .count6(count6),
        .count7(count7),
        .maxsupply(maxsupply),
        .pay1(pay1),
        .pay10(pay10),
        .payback1(payback1),
        .payback10(payback10),
        .turnover1(turnover1),
        .turnover10(turnover10),
        .successpay(successpay),
        .paid1(paid1),
        .paid10(paid10)
    );


    project_display_top display(//显示某一商品，让keyboard_val的�?�为0用不为零的其他数值代替，避免防抖时置�?0
        .clk(clk),
        .rst(rst),
        .mode(en),
        .paysuccessful(successpay),
        .istotalincome(total_out),
        .issoldnum(inquire),//这里用wtyx的inqiure�?
        //.behavior(),
        .customerchoose(number_inquire),
        .adminchoose(number_inquire),//也用用户选择的货道？
        .turnover1(turnover1),
        .turnover10(turnover10),
        .sold1(sellnum1),
        .sold10(sellnum10),
        .paidone(paid1),
        .paidten(paid10),
        .costone(pay1),
        .costten(pay10),
        .enterpay(enterpay),
        .returnone(payback1),
        .returnten(payback10),
        .goodleft({count7,count6,count5,count4,count3,count2,count1}),//�?0位开始为第一个货物剩余量
        .seg_en(seg_en),
        .seg_out(seg_out),
        .cancel(cancel)
    );

    //付款直接对键盘�?�敏感，因为防抖后加0

endmodule 