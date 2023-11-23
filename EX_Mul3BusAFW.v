module EX_Mul3BusAFw (
    //control port
    input [1:0] BusAFw,

    //input data
    input [31:0] busA_EX,
    input [31:0] Di,
    input [31:0] ALUout_M,
    

    output reg [31:0] BusAFw_out
);

always @(*) begin
    case (BusAFw)
        2'b00: begin
            BusAFw_out <= busA_EX;
        end 

        2'b01:begin
            BusAFw_out <= Di;
        end

        2'b10:begin
            BusAFw_out <= ALUout_M;
        end

        default:begin
            BusAFw_out <= 32'h0000_0000;
        end 
    endcase
end

endmodule