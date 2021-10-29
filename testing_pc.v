`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2021 03:32:49 PM
// Design Name: 
// Module Name: testing_pc
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


module testing_pc();
    wire [31:0] PC, PCNext, PCPlus4;
    reg [31:0] PCTarget;
    reg clk, reset, PCSrc;
    
	mux2 #(32) pcnext(PCNext,PCPlus4,PCTarget,PCSrc);
	pc pc_inst(PC,clk,reset,PCNext);
	adder pc_plus4(PCPlus4,PC,32'd4);
	
	initial begin
	   forever #10 clk=~clk;
	end
	
	initial begin
	   clk=0;
	   reset=1;
	   PCSrc=0;
	   PCTarget=20;
	   #50
	   reset=0;
	   #60
	   PCSrc=1;
	   #10
	   PCSrc=0;
	end
endmodule
