module cp_EM (output reg reg_wr_M, output reg [2:0] wr_en_M, rd_en_M, output reg [1:0] wb_sel_M, input reg_wr_E, input [2:0] wr_en_E, rd_en_E, input [1:0] wb_sel_E, input clk, rst);
	always @(posedge clk ) begin
	   if(!rst) begin
            reg_wr_M<=reg_wr_E;
            wr_en_M<=wr_en_E;
            rd_en_M<=rd_en_E;
            wb_sel_M<= wb_sel_E;
	   end
	   else begin
            reg_wr_M<=0;
            wr_en_M<=0;
            rd_en_M<=0;
            wb_sel_M<=0;
	   
	   end
	end
endmodule