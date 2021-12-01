module cp_DE(output reg [3:0] alu_op_E, output reg reg_wr_E, sel_A_E, sel_B_E, 
            output reg [2:0] wr_en_E, rd_en_E, output reg [1:0] wb_sel_E, 
            output reg [2:0] br_type_E, 
            input [3:0] alu_op, input reg_wr, sel_A, sel_B, 
            input [2:0] wr_en, rd_en, input [1:0] wb_sel, input [2:0] br_type, 
            input clk, rst, clr);
	always @(posedge clk) begin
	   if(rst) begin
	      alu_op_E<=0;
            reg_wr_E<=0;
            sel_A_E<=0;
            sel_B_E<=0;
            wr_en_E<=0;
            rd_en_E<=0;
            wb_sel_E<=0;
            br_type_E<=0;
	   end
      else if(clr)begin//insert no-op/flush
            alu_op_E=0;
            reg_wr_E=0;      //true no-op
            sel_A_E=1;
            sel_B_E=0;       //true no-op
            wr_en_E=0;
            rd_en_E=0;
            wb_sel_E=1;
            br_type_E=2;
      end
	   else begin
            alu_op_E<=alu_op;
            reg_wr_E<=reg_wr;
            sel_A_E<=sel_A;
            sel_B_E<=sel_B;
            wr_en_E<=wr_en;
            rd_en_E<=rd_en;
            wb_sel_E<=wb_sel;
            br_type_E<=br_type;
	   end
	end
endmodule