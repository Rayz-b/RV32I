//adding support for lw,lb,lh,lbu,lhu
//memory is byte addressable and thus every word is at an address which is a multiple of 4
//for a byte read (no. of bytes of alignment - 1 - value of the 2 least significant digits) 
//represents the number of bytes to shift the addressed content to the right to obtain data in proper form
module data_memory(output reg [31:0] ReadData,input clk,rst, input [2:0] ReadControl, WriteControl, input [7:0] Address, input [31:0] WriteData);
    reg [31:0] data_mem_file [31:0];//change to 255:0 when not debugging
    reg [31:0] store_intermediate, load_intermediate1,load_intermediate2;
    integer i;
    always @(posedge clk ) begin //write at WD3 if WE3
        if(!rst)begin
            case(WriteControl)//room for exploitation with funct3 and S or decrease no. of selection bits to 2        //assuming that data is in least significant bits
                3'b000:begin
                    store_intermediate = {24'h000000,WriteData[7:0]}<<({3'd0,Address[1:0]}<<3) ;
                    data_mem_file[Address>>2] = ( (data_mem_file[Address>>2]) & ~(32'h000000ff<< ({3'd0,Address[1:0]}<<3) ) ) | store_intermediate;
                 end            //Store Byte at address without altering other bits
                3'b001:begin
                    store_intermediate = {16'h0000,WriteData[15:0]}<<({3'd0,(Address[1]),1'd0}<<3);
                    data_mem_file[Address>>2] = ( (data_mem_file[Address>>2]) & ~(32'h0000ffff<< ({3'd0,(Address[1]),1'd0}<<3) )) | store_intermediate;//Store Half Word at address without altering other bits
                 end
                3'b010: data_mem_file[Address>>2] <= WriteData;//Store Word
                default: begin
                    for(i=0;i<32;i=i+1)begin    //retain current value
                        data_mem_file[i] <= data_mem_file[i];
                    end 
                end 
            endcase
        end
        else begin
            for(i=0;i<32;i=i+1)begin    //set everything to 0
                data_mem_file[i]<=32'd0;
            end
            store_intermediate <= 0;
        end
    end
    always @(*) begin
        case (ReadControl)//room for exploitation with funct3 and L
            3'b000:begin
                load_intermediate1=((3-{3'd0,Address[1:0]})<<3);
                load_intermediate2=data_mem_file[Address >> 2]<<load_intermediate1;
                ReadData = load_intermediate2>>>24;//read Byte                       -shifts byte      to extreme left and then extreme right to discard extra bits
            end
            3'b001:begin
                load_intermediate1=(2-{3'd0,(Address[1]),1'd0})<<3;//increase no. of bits
                load_intermediate2=data_mem_file[Address >> 2]<<load_intermediate1;
                ReadData = load_intermediate2>>>16;//read half-word               -shifts half-word "                                                         "
            end
            3'b010: ReadData =  data_mem_file[Address >> 2];//read word
            3'b100:begin
                load_intermediate1=((3-{3'd0,(Address[1:0])})<<3);
                load_intermediate2=data_mem_file[Address >> 2]<<load_intermediate1;
                ReadData = load_intermediate2>>24;//read Byte unsigned               -shifts byte      "                                                          "
            end
            3'b101:begin
                load_intermediate1=((2-{3'd0,(Address[1]),1'd0})<<3);
                load_intermediate2=data_mem_file[Address >> 2]<<load_intermediate1;
                ReadData = load_intermediate2>>16;//read half-word unsigned       -shifts half-word "                                                          "
            end
            default: begin
            ReadData <= 0;
            load_intermediate1 <= 0;
            load_intermediate2 <= 0;
            end
        endcase
    end
endmodule


//old version for user input - without reset
//module data_memory(output reg [31:0] ReadData, output reg [6:0] user_out, input clk, user_wr, user_sel, input [2:0] ReadControl, WriteControl, input [7:0] Address, input [31:0] WriteData, input [6:0] user_in);
//    reg [31:0] data_mem_file [31:0];//change to 255:0 when not debugging
//    integer i;
//    always @(posedge clk ) begin //write at WD3 if WE3
//        if(user_wr)begin//store user input
//            data_mem_file[{5'd0,user_sel}]<={25'd0,user_in};
//        end
//        if(Address>1)begin //write at WD3
//            case(WriteControl)//room for exploitation with funct3 and S or decrease no. of selection bits to 2        //assuming that data is in least significant bits
//                3'b000: data_mem_file[Address>>2] <= data_mem_file[Address>>2] & {24'hffffff,WriteData[7:0]};//Store Byte at address without altering other bits
//                3'b001: data_mem_file[Address>>2] <= data_mem_file[Address>>2] & {16'hffff,WriteData[15:0]};//Store Half Word at address without altering other bits
//                3'b010: data_mem_file[Address>>2] <= WriteData;//Store Word
//                default: begin
//                    for(i=0;i<32;i=i+1)begin    //retain current value
//                        data_mem_file[i] <= data_mem_file[i];
//                    end 
//                end
                    
//            endcase
//        end
//        else begin
//            for(i=0;i<32;i=i+1)begin    //retain current value
//                data_mem_file[i] <= data_mem_file[i];
//            end
//        end
//    end
//    always @(*) begin
//        if(Address>1)begin
//            case (ReadControl)//room for exploitation with funct3 and L
//                3'b000: ReadData <= (data_mem_file[Address >> 2]<<({3'd0,(Address[1:0])}<<3))>>>24;//read Byte                       -shifts byte      to extreme left and then extreme right to discard extra bits
//                3'b001: ReadData <= (data_mem_file[Address >> 2]<<({3'd0,(Address[1]),1'd0}<<3))>>>16;//read half-word               -shifts half-word "                                                         "
//                3'b010: ReadData <=  data_mem_file[Address >> 2];//read word
//                3'b100: ReadData <= (data_mem_file[Address >> 2]<<({3'd0,(Address[1:0])}<<3))>>24;//read Byte unsigned               -shifts byte      "                                                          "
//                3'b101: ReadData <= (data_mem_file[Address >> 2]<<({3'd0,(Address[1]),1'd0}<<3))>>16;//read half-word unsigned       -shifts half-word "                                                          "
//                default: ReadData<=0;
//            endcase
//        end
//        else begin
//            ReadData<=0;
//        end
//        user_out=data_mem_file[2][6:0];//store user_out at index 2
//    end
//endmodule
//try compiling hardware while rearranging if conditions blocks



//rv32i implementation with reset without aligned byte and half word accessibility
// module data_memory(output reg [31:0] ReadData, input clk, WriteEnable, rst, input [7:0] Address, input [31:0] WriteData);
//     reg [31:0] data_mem_file [255:0];
//     integer i;
//     always @(posedge clk ) begin //write at WD3 if WE3
//         if(!rst && WriteEnable)begin //write at WD3
//             data_mem_file[Address]<=WriteData;
//         end
//         else if(rst)begin //set all data to 0's
//             for(i=0;i<32;i=i+1)begin
//                 data_mem_file[i]<=32'd0;
//             end
//         end
//         else begin
//             for(i=0;i<32;i=i+1)begin //retain current value
//                 data_mem_file[i]<=data_mem_file[i];
//             end
//         end
//     end
//     always @(*) begin
//         ReadData<=data_mem_file[Address];
//     end
// endmodule
