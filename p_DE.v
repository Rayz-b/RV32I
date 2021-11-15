module p_DE(output reg [31:0] PC_E, rs1_E, rs2_E, Imm_E, IR_E, input [31:0] PC_D, rs1_D, rs2_D, Imm_D, IR_D, input clk, rst);
	always @(posedge clk ) begin
		if(!rst)begin
            PC_E<=PC_D;
            rs1_E<=rs1_D;
            rs2_E<=rs2_D;
            Imm_E<=Imm_D;
            IR_E<=IR_D;
		end
		else begin
            PC_E<=0;
            rs1_E<=0;
            rs2_E<=0;
            Imm_E<=0;
            IR_E<=0;
		end
	end
endmodule