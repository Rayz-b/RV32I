module branch_cond(output reg br_taken, input [0:2] br_type, input [0:31] A, B);
	always @(*) begin	//room for hardware exploitation by mapping with funct3+Branch confirmation?
		case (br_type)
			3'b000: br_taken = (A==B)? 1:0;	//beq
			3'b001: br_taken = (A!=B)? 1:0;	//bne
			3'b010: br_taken = 0;	//no jump
			3'b011: br_taken = 1;	//jalr,jal (unconditional jump)
			3'b100: br_taken = ($signed(A) < $signed(B))?  1:0;	//blt
			3'b101: br_taken = ($signed(A) >= $signed(B))? 1:0;	//bge
			3'b110: br_taken = (A<B)?  1:0;	//bltu
			3'b111: br_taken = (A>=B)? 1:0;	//bgeu
			default: br_taken = 0;
		endcase
	end
endmodule