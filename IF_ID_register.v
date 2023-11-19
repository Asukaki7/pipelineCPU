module IF_ID_register(
    input CLK,
    input [31:0] PC_i,
    input [31:0] Instr_i,
    input Resetn,
    
    output reg [31:0] PC,
    output reg [31:0] Instr

);

always @(negedge CLK) begin
    if(Resetn) begin
        PC <= PC_i;
        Instr <= Instr_i;
    end
        
    else  begin
        PC <= 32'b0;
        Instr <= 32'b0;
    end
        
end


endmodule 
