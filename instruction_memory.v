module instruction_memory (output reg [31:0] Instr, input [31:0] PC);
    reg [31:0] instr_mem [48:0];
    
    initial
    $readmemh("INSTRUCTION_MEM.mem", instr_mem);
    
    always@(PC) begin
        Instr <= instr_mem[PC>>2];
    end


	
endmodule
//        case (PC)
//		0: Instr<=32'h04000413;
//		4: Instr<=32'h03200493;
////		8: Instr<=32'h008000a3;//sb
////		12: Instr<=32'h009001a3;//sb
//		8: Instr<=32'h00801023;//sh
//		12: Instr<=32'h00901123;//sh
////		8: Instr<=32'h00802023;//sw
////		12:Instr<=32'h00902223;//sw
////		16: Instr<=32'h00100483;//lb
////		20: Instr<=32'h00300403;//lb
//		16: Instr<=32'h00001483;//lh
//		20: Instr<=32'h00201403;//lh
////		16:Instr<=32'h00002483;//lw
////		20:Instr<=32'h00402403;//lw
//		16: Instr<=32'h00005483;//lhu
//		20: Instr<=32'h00005483;//lbu
//		24: Instr<=32'h00940e63;
//		28: Instr<=32'h00944663;
//		32: Instr<=32'h40940433;
//	        36: Instr<=32'hff5ff06f;
//	        40:	Instr<=32'h408484b3;
//	        44:	Instr<=32'hfedff06f;
//	        48:	Instr<=32'h00900123;
//	        52:	Instr<=32'h0000006f;
//		default: Instr<=32'd0;
//        endcase

//ASSEMBLY
//     addi x8 , x0 , 12
//     addi x9 , x0 , 9
//  gcd :
//     beq x8 , x9 , stop
//     blt x8 , x9 , less
//     sub x8 , x8 , x9
//     j gcd
//  less :
//     sub x9 , x9 , x8
//     j gcd
//  stop :
//     j stop


//      testing lb
//     addi x8 , x0 , 64
//     addi x9 , x0 , 50
//     sb   x8 , 0(x0)
//     sb   x9 , 1(x0)
//     lb   x9 , 0(x0)
//     lb   x8 , 1(x0)
//gcd :
//     beq x8 , x9 , stop
//     blt x8 , x9 , less
//     sub x8 , x8 , x9
//     j gcd
//less :
//     sub x9 , x9 , x8
//     j gcd
//     sb    x9 , 2(x0)
//stop :
//     j stop

//ASSEMBLER
//https://riscvasm.lucasteske.dev/#