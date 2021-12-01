`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////      
//opcode    Type     Description             ALU     sel_A   sel_B   wb_sel  imm_gen     br_type   alu_op  reg_wr      d_wr
// 3:       I-Type   Load                    yes     1       1       2       0           none      0       1           0
// 19:      I-Type   immediate operation     yes     1       1       1       0           none      xxxx    1           0
// 23:      U-Type   auipc                   yes     0       1       1       4(u)        none      0       1           0
// 35:      S-Type   Store                   yes     1       1       z       1           none      0       0           1
// 51:      R-Type   register operation      yes     1       0       1       z           none      xxxx    1           0
// 55:      U-Type   lui                     no      1       1       1       4(u)        none      copy    1           0
// 99:      B-Type   conditional branch      yes     0       1       z       2           xxx       0       0           0
// 103:     I-Type   jalr                    yes     1       1       0       0           uncond    0       1           0
// 111:     J-Type   jal                     yes     1       1       0       3           uncond    0       1           0
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////      
//opcode    Type     Description             ALU     sel_A   sel_B   wb_sel  imm_gen     br_type   alu_op  reg_wr      d_wr
// 99:      B-Type   conditional branch      yes     0       1       z       2           xxx       0       0           0
// 51:      R-Type   register operation      yes     1       0       1       z           none      xxxx    1           0
// 23:      U-Type   auipc                   yes     0       1       1       4(u)        none      0       1           0
// 55:      U-Type   lui                     no      1       1       1       4(u)        none      copy    1           0
// 35:      S-Type   Store                   yes     1       1       z       1           none      0       0           1
// 3:       I-Type   Load                    yes     1       1       2       0           none      0       1           0
// 19:      I-Type   immediate operation     yes     1       1       1       0           none      xxxx    1           0
// 103:     I-Type   jalr                    yes     1       1       0       0           uncond    0       1           0
// 111:     J-Type   jal                     yes     1       1       0       3           uncond    0       1           0
//////////////////////////////////////////////////////////////////////////////////
//categories:   R,Ii,S,L,B,J

module controller(output reg [2:0] ImmSrc, output [3:0] alu_op_E, output [2:0] br_type_E, rd_en_M, wr_en_M,
                    output reg_wr_W, sel_A_E, sel_B_E,
                    output [1:0] wb_sel_W,
                    output reg_wr_M, output [1:0] wb_sel_E,
                    input [6:0] opcode,    //for all instructions
                    input [14:12] funct3, //for R,I,S,B and R4 Type   not for U and J Type
                    input [31:25] funct7, //only for R-Type         //-*change to base x:0
                    input clk, rst,
                    input flush_E);
                    
        reg [3:0] alu_op;
        reg [2:0] br_type, rd_en, wr_en;
        reg [1:0] wb_sel;
        reg reg_wr, sel_A, sel_B;
        reg R,Ii,S,L,B,auipc,lui,jal,jalr;
        
        wire [2:0] wr_en_E, rd_en_E;
        wire [1:0] wb_sel_M ;
        wire reg_wr_E;
        `define Type {R,Ii,S,L,B,auipc,lui,jal,jalr}
        `define Control {ImmSrc,sel_A, sel_B,wb_sel,reg_wr}

        //pipeline stages
        cp_DE control_pipe_Decode_Execute(alu_op_E, reg_wr_E, sel_A_E, sel_B_E, wr_en_E, rd_en_E, wb_sel_E, br_type_E, 
                    alu_op, reg_wr, sel_A, sel_B, wr_en, rd_en, wb_sel, br_type, clk, rst, flush_E);
        
        cp_EM control_pipe_Execute_Memory(reg_wr_M, wr_en_M, rd_en_M, wb_sel_M, 
                    reg_wr_E, wr_en_E, rd_en_E, wb_sel_E, clk, rst);
        
        cp_MW control_pipe_Memory_Writeback(reg_wr_W, wb_sel_W, 
                    reg_wr_M, wb_sel_M, clk, rst);


        //determine instruction type
    always@(*)begin    
        if (!rst) begin //what to do for lui, auipc,
            case(opcode)//Type {R,Ii,S,L,B,auipc,lui,jal,jalr}  Type     Description             ALU     sel_A   sel_B   wb_sel  imm_gen     br_type   alu_op  reg_wr      d_wr
                3: `Type<= 'b000100000;                         //I-Type   Load                    yes     1       1       2       0           none      0       1           0
                19:`Type<= 'b010000000;                         //I-Type   immediate operation     yes     1       1       1       0           none      xxxx    1           0
                23:`Type<= 'b000001000;                         //U-Type   auipc                   yes     0       1       1       4(u)        none      0       1           0
                35:`Type<= 'b001000000;                         //S-Type   Store                   yes     1       1       z       1           none      0       0           1
                51:`Type<= 'b100000000;                         //R-Type   register operation      yes     1       0       1       z           none      xxxx    1           0
                55:`Type<= 'b000000100;                         //U-Type   lui                     yes?    1       1       1       4(u)        none      copy    1           0
                99:`Type<= 'b000010000;                         //B-Type   conditional branch      yes     0       1       z       2           xxx       0       0           0
                103:`Type<='b000000001;                         //I-Type   jalr                    yes     1       1       0       0           uncond    0       1           0
                111:`Type<='b000000010;                         //J-Type   jal                     yes     1       1       0       3           uncond    0       1           0
                default:`Type<='b000000000;
            endcase    
        end   
        else begin
            `Type<=0;
        end
    end
    
    always @(*) begin
        if (R||Ii) begin    //determine aluop using: R,Ii,lui,funct3,funct7
            casex({R,funct7[30],funct7[25],funct3})//does not? cater for some Immediate instructions with faulty opcode
                6'b100000:alu_op<=0;//add
                6'b110000:alu_op<=1;//sub
                6'b0xx000:alu_op<=0;//addi
                6'b100001:alu_op<=4;//sll
                6'b000001:alu_op<=4;//slli
                6'b100010:alu_op<=14;//slt
                6'b0xx010:alu_op<=14;//slti
                6'b100011:alu_op<=13;//sltu
                6'b0xx011:alu_op<=13;//sltiu
                6'b100100:alu_op<=10;//xor
                6'b0xx100:alu_op<=10;//xori
                6'b100101:alu_op<=5;//srl
                6'b000101:alu_op<=5;//srli
                6'b110101:alu_op<=6;//sra
                6'b010101:alu_op<=6;//srai
                6'b100110:alu_op<=9;//or
                6'b0xx110:alu_op<=9;//ori
                6'b100111:alu_op<=8;//and
                6'b0xx111:alu_op<=8;//andi
                6'b101000:alu_op<=2;//mul
                default:alu_op<=0;
            endcase    
        end
        else if(lui)begin
            alu_op<=4'b1100;//aluop for result=B
        end
        else begin
            alu_op<=0;//all other instructions use operation A+B of ALU
        end            
    end
    
    always @(*) begin//for wr_en
        case ({S})
            1: wr_en<=funct3;
            default: wr_en<=7;//retain current value
        endcase
    end

    always @(*) begin//for rd_en
        case ({L})
            1: rd_en<=funct3;
            default: rd_en<=7;//output 0
        endcase
    end

    always @(*) begin//for br_type
        casex({jal,jalr,B})
            3'b100: br_type <= 3 ;
            3'b010: br_type <= 3 ;//jal,jalr
            3'b001: br_type <= funct3 ;//possible due to exploitable design of branch_cond 
            default: br_type<= 2; //no jump
        endcase
    end
    //Fix control signals for each instruction type
    always@(*)begin
        case(`Type)//Type {R,Ii,S,L,B,auipc,lui,jal,jalr}
        //Control {ImmSrc,sel_A, sel_B,wb_sel,reg_wr}
            10'b100000000:`Control<=8'bzzz10011;//R         //does zzz propagate?
            10'b010000000:`Control<=8'b00011011;//Ii
            10'b001000000:`Control<=8'b00111000;//S
            10'b000100000:`Control<=8'b00011101;//L
            10'b000010000:`Control<=8'b01001000;//B
            10'b000001000:`Control<=8'b01101011;//auipc
            10'b000000100:`Control<=8'b01111011;//lui
            10'b000000010:`Control<=8'b10001001;//jal
            10'b000000001:`Control<=8'b00001001;//jalr
            default: `Control<=0;
        endcase
    end
    
endmodule