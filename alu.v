/* ALU Arithmetic and Logic Operations for RV32I
----------------------------------------------------------------------
|ALU_Sel|   ALU Operation
----------------------------------------------------------------------
| 0000  |   ALU_Out = A + B;
----------------------------------------------------------------------
| 0001  |   ALU_Out = A - B;
----------------------------------------------------------------------
| 0010  |   ALU_Out = A * B;                            not part of official RV32I
----------------------------------------------------------------------
| 0011  |   ALU_Out = A / B;                            //excluded, not part of official RV32I
----------------------------------------------------------------------
| 0100  |   ALU_Out = A << B;
----------------------------------------------------------------------
| 0101  |   ALU_Out = A >> B;
----------------------------------------------------------------------
| 0110  |   ALU_Out = A >>> B;
----------------------------------------------------------------------
| 0111  |   ALU_Out = A rotated right by 1;             //excluded,  not part of official RV32I
----------------------------------------------------------------------
| 1000  |   ALU_Out = A and B;
----------------------------------------------------------------------
| 1001  |   ALU_Out = A or B;
----------------------------------------------------------------------
| 1010  |   ALU_Out = A xor B;
----------------------------------------------------------------------
| 1011  |   ALU_Out = A;                                 not part of official RV32I
----------------------------------------------------------------------
| 1100  |   ALU_Out = B;                                 for lui
----------------------------------------------------------------------
| 1101  |   ALU_Out = 1 if signed(A) < signed(B) else 0; for slt
----------------------------------------------------------------------
| 1110  |   ALU_Out = 1 if A<B else 0;                   for sltu
----------------------------------------------------------------------
| 1111  |   ALU_Out = 1 if A=B else 0;                   not part of official RV32I
----------------------------------------------------------------------*/
module alu(input [31:0] A,B,  // ALU 8-bit Inputs
           input [3:0] ALU_Sel,// ALU Selection
           output [31:0] ALU_Out // ALU 8-bit Output
           );
    reg [31:0] ALU_Result;
    wire [32:0] tmp;
    assign ALU_Out = ALU_Result; // ALU out
    
    always @(*)begin
      case(ALU_Sel)//-*modify arrangement to facilitate exploitation using funct3
      4'b0000: // Addition
        ALU_Result <= A + B ;
      4'b0001: // Subtraction
        ALU_Result <= A - B ;
      4'b0010: // Multiplication
        ALU_Result <= A * B;
//    4'b0011: // Division          //excluded
//      ALU_Result <= A/B;
      4'b0100: // Logical shift left
        ALU_Result <= A<<B[4:0];//max shifting limit of 31 bits
      4'b0101: // Logical shift right
        ALU_Result <= A>>B[4:0];//max shifting limit of 31 bits
      4'b0110: // Arithmetic Shift right
        ALU_Result <= A>>>B[4:0];
      // 4'b0111: // Rotate right     //excluded
      //   ALU_Result = {A[0],A[31:1]};
      4'b1000: //  Logical and
        ALU_Result <= A & B;
      4'b1001: //  Logical or
        ALU_Result <= A | B;
      4'b1010: //  Logical xor
        ALU_Result <= A ^ B;
//       4'b1011: //  copy A                //excluded
//         ALU_Result <= A;
      4'b1100: //  copy B for lui
        ALU_Result <= B;
      4'b1101: // Greater comparison unsigned
        ALU_Result <= (A < B)?32'd1:32'd0 ;
      4'b1110: // Greater comparison signed
        ALU_Result <= ($signed(A) < $signed(B))?32'd1:32'd0 ;
      4'b1111: // Equal comparison
        ALU_Result <= (A==B)?32'd1:32'd0 ;
      default: ALU_Result <= A + B ;
      endcase
    end

endmodule
