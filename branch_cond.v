module branch_cond(output reg br_taken, input [0:2] br_type, input [0:31] A, B, input rst);
    wire [0:31] C;
    wire z,n;
    assign C=A-B;
    assign z = (C==0)? 1:0;
    assign n = (C[31]==1)? 1:0;         //means A<B   for signed
	always @(*) begin	//room for hardware exploitation by mapping with funct3+Branch confirmation?
	   if (!rst) begin
            case (br_type)//determine branching using Z and N flags
                3'b000: br_taken = (A==B)? 1:0;	//beq   z=1
                3'b001: br_taken = (A!=B)? 1:0;	//bne   z=0
                3'b010: br_taken = 0;	//no jump
                3'b011: br_taken = 1;	//jalr,jal (unconditional jump)
                3'b100: br_taken = ($signed(A) < $signed(B))?  1:0;	//blt   z = 0   n = 
                3'b101: br_taken = ($signed(A) >= $signed(B))? 1:0;	//bge
                3'b110: br_taken = (A<B)?  1:0;	//bltu
                3'b111: br_taken = (A>=B)? 1:0;	//bgeu
                default: br_taken = 0;
            endcase
        end
        else begin
            br_taken = 0;
        end
	end
endmodule