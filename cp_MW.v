module cp_MW(output reg reg_wr_W, output reg [1:0] wb_sel_W, input reg_wr_M, input [1:0] wb_sel_M, input clk, rst);
	always @(posedge clk ) begin
	   if(!rst) begin
		reg_wr_W<=reg_wr_M;
		wb_sel_W<=wb_sel_M;
	   end
	   else begin
		reg_wr_W<=0;
		wb_sel_W<=0;
	   end
	end
endmodule