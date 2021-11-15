module p_MW(output reg [31:0] PC_W, ALU_W, RD_W, IR_W, input [31:0] PC_M, ALU_M, RD_M, IR_M, input clk, rst);
	always @(posedge clk ) begin
	   if(!rst) begin
            PC_W<=PC_M;
            ALU_W<=ALU_M;
            RD_W<=RD_M;
            IR_W<=IR_M;
		end
		else begin
            PC_W<=0;
            ALU_W<=0;
            RD_W<=0;
            IR_W<=0;
		end
	end
endmodule