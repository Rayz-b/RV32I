module p_EM(output reg [31:0] PC_M, ALU_M, WD_M, IR_M, input [31:0] PC_E, ALU_E, WD_E, IR_E, input clk, rst);
	always @(posedge clk ) begin
	   if(!rst) begin
            PC_M<=PC_E;
            ALU_M<=ALU_E;
            WD_M<=WD_E;
            IR_M<=IR_E;
		end
		else begin
            PC_M<=0;
            ALU_M<=0;
            WD_M<=0;
            IR_M<=0;		
		end
	end
endmodule