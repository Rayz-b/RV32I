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
    wire reg_wr,sel_A,sel_B; 
    wire [3:0] alu_op;
    wire [2:0] ImmSrc, br_type, ReadControl,WriteControl;
    wire [1:0] wb_sel;
    
    datapath dp(opcode, funct3, funct7, Result, rst,clk,reg_wr,sel_A,sel_B, wb_sel, ImmSrc, alu_op,br_type,ReadControl,WriteControl);
    controller con(ImmSrc,alu_op,br_type,ReadControl,WriteControl, reg_wr, sel_A, sel_B, wb_sel, opcode, funct3, funct7, clk, rst);
endmodule
