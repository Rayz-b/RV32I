module testing_rv_32i();
//    wire [6:0] LED;
//    wire [7:0] Anode;
    reg clk,rst;
    wire [31:0] Result;
//    reg user_wr,user_sel; 
//    reg [6:0] user_in;
    //RV32I rv(LED,Anode,clk,rst,user_wr,user_sel,user_in);
    RV32I rv(Result,clk,rst);
    
    initial begin
        forever #10 clk<=!clk;
    end
    
    initial begin
        clk<=0;
        rst<=1;
        #80
        rst<=0;
//        user_wr<=1;
//        user_sel<=0;
//        user_in<=24;
//        #10
//        user_sel<=1;
//        user_in<=10;
//        #20
//        user_wr<=0;
    end
endmodule