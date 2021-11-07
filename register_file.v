module register_file(output reg [31:0] RD1,RD2, input clk, WE3, rst, input [4:0] A1,A2,A3, input [31:0] WD3);
    reg [31:0] reg_file [31:0];
    integer i;
    always @(posedge clk ) begin //write at A3 if WE3
        if(!rst && WE3 && (A3!=0))begin //write WD3 at A3      -can't write at r0
            reg_file[A3]<=WD3;
        end
        else if(rst)begin //if reset, set all data to 0's
            for(i=0;i<32;i=i+1)begin
                reg_file[i]<=32'd0;
            end
        end
        else begin  //else retain current value
            for(i=0;i<32;i=i+1)begin
                reg_file[i]<=reg_file[i];
            end
        end
    end
    always @(*) begin
        RD1<=reg_file[A1];
        RD2<=reg_file[A2];
    end
endmodule
