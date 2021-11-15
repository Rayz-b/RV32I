module instruction_fetch(
		output [6:0] opcode, 
		output [11:7] rd, 
		output [14:12] funct3,
		output [19:15] rs1,
		output [24:20] rs2,
		output [31:25] funct7,
		output [31:7] imm,
		input [31:0] Instr,
		input rst);
	assign opcode= rst ? 0 : Instr[6:0];
	assign rd =    rst ? 0 : Instr[11:7];
	assign funct3= rst ? 0 : Instr[14:12];
	assign rs1 =   rst ? 0 : Instr[19:15];
	assign rs2 =   rst ? 0 : Instr[24:20];
	assign funct7= rst ? 0 : Instr[31:25];
	assign imm =   rst ? 0 : Instr[31:7];
	
endmodule