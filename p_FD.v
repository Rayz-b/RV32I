module p_FD(output reg[31:0] PC_D, IR_D, input[31:0] PC_F, IR_F, input clk, rst, en, clr);
	always @(posedge clk ) begin
	   if(rst) begin
		PC_D<=0;
		IR_D<=0;
	   end
	   else if(clr) begin
		PC_D<=0;			//pc value doesn't matter?
		IR_D<=32'h00000013;//insert no-op		addi x0,x0,0
	   end
	   else if(en) begin
		PC_D<=PC_F;
		IR_D<=IR_F;
	   end
	end
endmodule