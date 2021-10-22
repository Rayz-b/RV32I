module pc(output reg [31:0] PC, input clk, reset, input [31:0] PCNext);
    always @(posedge clk ) begin
        if (reset) begin
            PC<=0;
        end
        else begin
            PC <= PCNext;
        end
    end
endmodule