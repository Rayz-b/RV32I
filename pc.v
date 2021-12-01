module pc(output reg [31:0] PC, input clk, reset, en, input [31:0] PCNext);
    always @(posedge clk ) begin
        if (reset) begin
            PC<=0;
        end
        else if(en) begin
            PC <= PCNext;
        end
    end
endmodule