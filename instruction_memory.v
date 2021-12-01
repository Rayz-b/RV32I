module instruction_memory (output reg [31:0] Instr, input [31:0] PC);
    reg [31:0] instr_mem [48:0];
    
    initial
    $readmemh("Test_Imem.mem", instr_mem);
//      testing hazards
//    addi x10,x0,11
//    addi x11,x0,14
//    addi x12,x0,13
//    addi x13,x0,19
//    addi x14,x0,24
//    or  x19,x10,x11
//    sll x20,x11,x12
//    sub x21,x13,x14
//    addi x10,x0,10
//    addi x11,x0,12
//    addi x12,x0,15
//    addi x13,x0,20
//    add x15,x10,x13
//    add x16,x13,x15
//    sw x10,12(x0)
//    lw x17,12(x0)
//    add x18,x0,x17
//    beq x0,x0,taken
//    addi x22,x0,22
// taken:
// 	addi x22,x0,23
//    beq x22,x0,taken1
// stop:
// 	nop
//    beq x0,x0,stop
// taken1:
// 	addi x23,x0,23
//    $readmemh("INSTRUCTION_MEM.mem", instr_mem);
    
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


//      testing hazards
//    addi x10,x0,11
//    addi x11,x0,14
//    addi x12,x0,13
//    addi x13,x0,19
//    addi x14,x0,24
//    or  x19,x10,x11
//    sll x20,x11,x12
//    sub x21,x13,x14
//    addi x10,x0,10
//    addi x11,x0,12
//    addi x12,x0,15
//    addi x13,x0,20
//    add x15,x10,x13
//    add x16,x13,x15
//    sw x10,12(x0)
//    lw x17,12(x0)
//    add x18,x0,x17
//    beq x0,x0,taken
//    addi x22,x0,22
// taken:
// 	addi x22,x0,23
//    beq x22,x0,taken1
// stop:
// 	nop
//    beq x0,x0,stop
// taken1:
// 	addi x23,x0,23
    
    

    
    

    
//ASSEMBLER
//https://riscvasm.lucasteske.dev/#