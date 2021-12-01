module hazard_unit(output stall_F,stall_D,flush_D,flush_E,
					output reg [1:0] forwardA_E,forwardB_E, 
					input [31:0] IR_D, IR_E, IR_M, IR_W,
                    // input [4:0] rs1_D, rs2_D, rs1_E, rs2_E, rd_E, rd_M, rd_W, 
					input pcsrc_E, regwrite_M, regwrite_W, rst,
					input [1:0] wb_sel_E);
    wire lwStall;
    wire [4:0] ra1_D, ra2_D, ra1_E, ra2_E, rd_E, rd_M, rd_W;
    //set address as 0 when it is not relevant to instruction  so that it will not be forwarded
    assign rd_E = (IR_E[6:0]!=35 & IR_E[6:0]!=99)? IR_E[11:7] : 0;  //  not S-Type or B-Type
	assign rd_M = (IR_M[6:0]!=35 & IR_M[6:0]!=99)? IR_M[11:7] : 0;  //  not S-Type or B-Type
	assign rd_W = (IR_W[6:0]!=35 & IR_W[6:0]!=99)? IR_W[11:7] : 0;  //  not S-Type or B-Type
	assign ra1_E = (IR_E[6:0]!=23 & IR_E[6:0]!=111)? IR_E[19:15] : 0;   // not U-Type or J-Type
	assign ra1_D = (IR_D[6:0]!=23 & IR_D[6:0]!=111)? IR_D[19:15] : 0;   // not U-Type or J-Type
	assign ra2_E = (IR_E[6:0]==35 | IR_E[6:0]==51 | IR_E[6:0]==99)? IR_E[24:20] : 0;    //R-Type, S-Type or B-Type
	assign ra2_D = (IR_D[6:0]==35 | IR_D[6:0]==51 | IR_D[6:0]==99)? IR_D[24:20] : 0;    //R-Type, S-Type or B-Type


	always @(*) begin	//for forwarding operand A
	   if(!rst)begin
            if( ((ra1_E == rd_M) & regwrite_M) & ra1_E!=0 )begin
                forwardA_E=0;
            end
            else if(((ra1_E == rd_W) & regwrite_W) & ra1_E!=0 )begin
                forwardA_E=2;
            end
            else begin
                forwardA_E=1;
            end
       end
       else begin
        forwardA_E=0;
       end
	end
	
	always @(*) begin	//for forwarding operand B
	   if(!rst)begin
            if( ((ra2_E == rd_M) & regwrite_M) & ra2_E!=0 )begin
                forwardB_E=0;
            end
            else if(((ra2_E == rd_W) & regwrite_W) & ra2_E!=0 )begin
                forwardB_E=2;
            end
            else begin
                forwardB_E=1;
            end
       end
       else begin
        forwardB_E=0;
       end
	end
	//stalling for load hazard
	assign lwStall = (rst)? 0 : (wb_sel_E[1] & ( (ra1_D == rd_E) | (ra2_D == rd_E) ) );
	assign stall_F = (rst)? 0 : lwStall;
	assign stall_D = (rst)? 0 : lwStall;
	
	//flush at branch or bubble from load
	assign flush_D = (rst)? 0 : pcsrc_E;
	assign flush_E = (rst)? 0 : lwStall | pcsrc_E;

endmodule