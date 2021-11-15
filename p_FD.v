module p_FD(output reg[31:0] PC_D, IR_D, input[31:0] PC_F, IR_F, input clk, rst);
	always @(posedge clk ) begin
	   if(!rst) begin
		PC_D<=PC_F;
		IR_D<=IR_F;
	   end
	   else begin
	    PC_D<=0;
		IR_D<=0;
	   end
	end
endmodule