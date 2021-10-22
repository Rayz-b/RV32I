module instruction_fetch(
		output [6:0] opcode, 
		output [11:7] rd, 
		output [14:12] funct3,
		output [19:15] rs1,
		output [24:20] rs2,
		output [31:25] funct7,
		output [31:7] imm,
		input [31:0] Instr);
	assign opcode=Instr[6:0];
	assign rd=Instr[11:7];
	assign funct3=Instr[14:12];
	assign rs1=Instr[19:15];
	assign rs2=Instr[24:20];
	assign funct7=Instr[31:25];
	assign imm=Instr[31:7];
	
endmodule