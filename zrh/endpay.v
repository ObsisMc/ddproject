module endpay(
input EN,
input clk,
input mode,//0为付款成功，1为不成功
input [3:0] returnone,
input [3:0] returnten,
output [7:0] seg_en,
output [7:0] seg_out,
output reg out_endpay
);
    //字符显示时钟分频（不用改）
    reg clkout;
    reg [31:0] cnt;
    reg [6:0] scan_cnt;//显示不同字符的计数器
    parameter differentcharperiod=25000;

    //切换显示
    reg [15:0] multi3sec;//三秒切换8000x3
    reg [1:0] endcounter;//两轮循环，一次加一，加到3结束
    
    //显示
    reg nextdisplay;//0为显示提示，1为显示退款
    reg [7:0] seg_out_r;
    reg [7:0] seg_en_r;
    assign seg_out=~seg_out_r;
    assign seg_en=~seg_en_r;

    //显示返还零钱
    wire [7:0] changeonedisplay;
    wire [7:0] changetendisplay;
    num_display changeone(returnone,changeonedisplay);
    num_display changeten(returnten,changetendisplay);

    //字符
    parameter S=7'b1101101;
    parameter U=7'b0111110;
    parameter C=7'b0111001;
    parameter e=7'b1111011;
    parameter d=7'b1011110;
    parameter H=7'b1110110;
    parameter n=7'b0110111;
    parameter g=7'b1101111;
    parameter I=7'b0110000;
    parameter L=7'b0111000;
    parameter F=7'b1110001;
    parameter A=7'b1110111 ;

    always @(posedge clk, negedge EN)
    begin
        if(!EN)
        begin
            clkout<=0;
            cnt<=0;
            multi3sec<=0;
            nextdisplay<=0;
            endcounter<=0;
        end
        else if(cnt==(differentcharperiod>>1)-1) 
        begin
            clkout<=~clkout;
            cnt<=0;
            multi3sec<=multi3sec+1;
            if(multi3sec==12000)
            begin
                nextdisplay<=~nextdisplay;
                multi3sec<=0;
                endcounter<=endcounter+1;
                if(endcounter==3)
                out_endpay=1;//直接将out_endpay传出去，在外面将EN变为0
            end
        end
        else
        cnt<=cnt+1;
    end

    always @(posedge clkout, negedge EN)
    begin
        if(!EN)
        begin
            scan_cnt<=0;
        end
        else if(scan_cnt==7) scan_cnt<=0;
        else
        scan_cnt<=scan_cnt+1;
    end

    always @(scan_cnt)
    begin
        case(scan_cnt)
        0:seg_en_r=8'b0000_0001;
        1:seg_en_r=8'b0000_0010;
        2:seg_en_r=8'b0000_0100;
        3:seg_en_r=8'b0000_1000;
        4:seg_en_r=8'b0001_0000;
        5:seg_en_r=8'b0010_0000;
        6:seg_en_r=8'b0100_0000;
        7:seg_en_r=8'b1000_0000;
        endcase
    end

    always  @(scan_cnt)
    begin
        if(!nextdisplay)
        begin
            if(!mode)
            begin
                case(scan_cnt)
                0:seg_out_r=8'b0000_0000;
                1:seg_out_r={1'b0,d};
                2:seg_out_r={1'b0,e};
                3:seg_out_r={1'b0,e};
                4:seg_out_r={1'b0,C};
                5:seg_out_r={1'b0,C};
                6:seg_out_r={1'b0,U};
                7:seg_out_r={1'b0,S};
                endcase
            end
            else
            case (scan_cnt)
            0:seg_out_r=8'b0000_0000;
            1:seg_out_r=8'b0000_0000;
            2:seg_out_r=8'b0000_0000;
            3:seg_out_r=8'b0000_0000;
            4:seg_out_r={1'b0,L};
            5:seg_out_r={1'b0,I};
            6:seg_out_r={1'b0,A};
            7:seg_out_r={1'b0,F}; 
            endcase
        end
        else
        case(scan_cnt)
            0:seg_out_r=changeonedisplay;
            1:seg_out_r=changetendisplay;
            2:seg_out_r={1'b1,e};
            3:seg_out_r={1'b0,g};
            4:seg_out_r={1'b0,n};
            5:seg_out_r={1'b0,A};
            6:seg_out_r={1'b0,H};
            7:seg_out_r={1'b0,C};
        endcase
    end


endmodule