`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2021 01:13:58 PM
// Design Name: 
// Module Name: RV32I
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//output reg [6:0] LED, output reg [7:0] Anode, input clk,rst,user_wr,user_sel, input [6:0] user_in
module RV32I(output [31:0] Result, input clk,rst);//-*only mention names at top, fix types later
    wire [6:0] opcode;
    wire [14:12] funct3; 
    wire [31:25] funct7;
    wire sel_A,sel_B; 
    wire [3:0] alu_op;
    wire [2:0] ImmSrc, br_type, ReadControl,WriteControl;
    wire [1:0] wb_sel;

    wire stall_F,stall_D,flush_D,flush_E,br_taken;
    wire [1:0] forwardA_E,forwardB_E;
    wire [4:0] rs1_D, rs2_D, rs1_E, rs2_E, rd_E, rd_M, rd_W;
    wire reg_wr_M,reg_wr_W;
    wire [1:0] wb_sel_E;
    wire [31:0] IR_D, IR_E, IR_M, IR_W;
    
    datapath dp(opcode, funct3, funct7, Result, 
                IR_D, IR_E, IR_M, IR_W,
                //rs1_D, rs2_D, rs1_E, rs2_E, rd_E, rd_M, rd_W,
                br_taken,
                rst,clk,
                reg_wr_W,sel_A,sel_B, wb_sel, ImmSrc, alu_op,br_type,WriteControl,ReadControl,
                stall_F,stall_D,flush_D,flush_E,
                forwardA_E,forwardB_E);

    controller con(ImmSrc,alu_op,br_type,ReadControl,WriteControl, reg_wr_W, sel_A, sel_B, wb_sel, 
                    reg_wr_M, wb_sel_E,
                    opcode, funct3, funct7, clk, rst, 
                    flush_E);

    hazard_unit hzu(stall_F,stall_D,flush_D,flush_E,
					forwardA_E,forwardB_E, 
                    IR_D, IR_E, IR_M, IR_W,
					// rs1_D, rs2_D, rs1_E, rs2_E, rd_E, rd_M, rd_W, 
					br_taken, reg_wr_M, reg_wr_W, rst,
					wb_sel_E);
endmodule
