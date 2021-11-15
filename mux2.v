module mux2 #(parameter WIDTH = 8)
                      (output [WIDTH-1:0] y,
                       input [WIDTH-1:0] d0, d1,
                       input              s, rst);
                       
     assign y[WIDTH-1:0] = rst ? 0 : (s ? d1 : d0);
endmodule


// To call this module:
//  mux2 #(32)   mux(RegisterData, ImmValue, ContSelector, OutB);
