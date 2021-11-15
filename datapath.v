//5-stage pipeline
//Postfix after each signal indicating its stage of usage
//Fetch			F
//Decode		D
//Execute		E
//Memory		M
//Writeback		W
module datapath(output [6:0] opcode,
                output [14:12] funct3, 
                output [31:25] funct7, 
                output [31:0] Result,
                input rst,clk, reg_wr_W,sel_A_E,sel_B_E,
                input [1:0] wb_sel_W,
                input [2:0] ImmSrc,input [3:0] alu_op_E, input [2:0] br_type_E, wr_en_M, rd_en_M);
	
	wire [31:0] PC_F, PC_D, PC_E, PC_M, PC_W, IR_F, IR_D, IR_E, IR_W, IR_M;
	wire [31:0] rs1_E, rs2_E, rs1_D, rs2_D, Imm_D, Imm_E, ALU_E, ALU_M, ALU_W, RD_W, WD_M, RD_M;
	wire [31:0] PCNext, PCPlus4_1, PCPlus4_2, SrcA, SrcB;
	wire [24:20] rs2;
	wire [19:15] rs1;
	wire [11:7] rd;
    wire [31:7] imm;
    wire br_taken;
    
	//instantiate and join all modules of datapath here
	mux2 #(32) pcnext(PCNext,PCPlus4_1,ALU_E,br_taken, rst);
	pc pc_inst(PC_F,clk,rst,PCNext);
	adder pc_plus4(PCPlus4_1,PC_F,32'd4, rst);
	instruction_memory ins_mem(IR_F,PC_F);

	p_FD pipe_Fetch_Decode(PC_D, IR_D, PC_F, IR_F, clk, rst);

	instruction_fetch ins_fetch(opcode, rd, funct3, rs1, rs2, funct7, imm, IR_D, rst);
	extend ext(Imm_D, IR_D[31:7], ImmSrc, rst);
	register_file reg_file(rs1_D, rs2_D, clk, reg_wr_W, rst, rs1, rs2, IR_W[11:7], Result);
	
	p_DE pipe_Decode_Execute(PC_E, rs1_E, rs2_E, Imm_E, IR_E, PC_D, rs1_D, rs2_D, Imm_D, IR_D, clk, rst);

	branch_cond Br_taken(br_taken, br_type_E, rs1_E, rs2_E, rst);
	mux2 #(32) srcA(SrcA, PC_E, rs1_E, sel_A_E, rst);
	mux2 #(32) srcB(SrcB, rs2_E, Imm_E, sel_B_E, rst);
	alu aalu(ALU_E, SrcA, SrcB, alu_op_E, rst);
	
	p_EM pipe_Execute_Memory(PC_M, ALU_M, WD_M, IR_M, PC_E, ALU_E, rs2_E, IR_E, clk, rst);

	data_memory data_mem(RD_M, clk, rst, wr_en_M, rd_en_M, ALU_M, WD_M);//-*see if ALU_M needs to be masked
	
	p_MW pipe_Memory_Writeback(PC_W, ALU_W, RD_W, IR_W, PC_M, ALU_M, RD_M, IR_M, clk, rst);

	adder pc_plus4_2(PCPlus4_2, PC_W, 32'd4, rst);
	mux3 #(32) result(Result, PCPlus4_2, ALU_W, RD_W, wb_sel_W, rst);
	
endmodule