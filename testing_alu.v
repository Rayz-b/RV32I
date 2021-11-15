module testing_alu;
    reg [31:0] A,B;
    reg[3:0] ALU_Sel;
    wire CarryOut,ZeroOut;
    wire [31:0] ALU_Out;
    alu aalu( A,B, ALU_Sel,ALU_Out,CarryOut,ZeroOut);

    initial begin
        A=5;
        B=5;
        ALU_Sel=0;
        #40
        ALU_Sel=ALU_Sel+1;
        #40
        ALU_Sel=ALU_Sel+1;
        #40
        ALU_Sel=ALU_Sel+1;
        #40
        ALU_Sel=ALU_Sel+1;
        #40
        ALU_Sel=ALU_Sel+1;
        #40
        ALU_Sel=ALU_Sel+1;
        #40
        ALU_Sel=ALU_Sel+1;
        #40
        ALU_Sel=ALU_Sel+1;
        #40
        ALU_Sel=ALU_Sel+1;
        #40
        ALU_Sel=ALU_Sel+1;
        #40
        ALU_Sel=ALU_Sel+1;
        #40
        ALU_Sel=ALU_Sel+1;
        #40
        ALU_Sel=ALU_Sel+1;
        #40
        ALU_Sel=ALU_Sel+1;
        #40
        ALU_Sel=ALU_Sel+1;
        
        
    end
endmodule