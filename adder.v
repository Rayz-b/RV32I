module adder(output  [31:0] y,input   [31:0] a, b, input rst);
     assign y = rst ? 0 : a + b;
endmodule