module EX_Mul3BusAFW (
    //control port
    input [1:0] BusAFW,

    //input data
    input [31:0] busA_EX,
    input [31:0] Di,
    input [31:0] ALUout_M,
    

    output reg [31:0] BusAFW_out
);

always @(*) begin
    case (BusAFW)
        2'b00: begin
            BusAFW_out <= busA_EX;
        end 

        2'b01:begin
            BusAFW_out <= Di;
        end

        2'b10:begin
            BusAFW_out <= ALUout_M;
        end
        
        default:begin
            BusAFW_out <= 32'h0000_0000;
        end 
    endcase
end


endmodule