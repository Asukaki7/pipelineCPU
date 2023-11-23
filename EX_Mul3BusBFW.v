module EX_Mul3BusBFw (
    //control port
    input [1:0] BusBFw,

    //input data
    input [31:0] busB_EX,
    input [31:0] Di,
    input [31:0] ALUout_M,
    

    output reg [31:0] BusBFw_out
);

always @(*) begin
    case (BusBFw)
        2'b00: begin
            BusBFw_out <= busB_EX;
        end 

        2'b01:begin
            BusBFw_out <= Di;
        end

        2'b10:begin
            BusBFw_out <= ALUout_M;
        end
        
        default:begin
            BusBFw_out <= 32'h0000_0000;
        end 
    endcase
end


endmodule