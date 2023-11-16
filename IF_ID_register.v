module IF_ID_register(
    input CLK,
    input [31:0] nowpc,
    input [31:0] Instr_i,
    input Resetn,
    
    output reg [31:0] pc,
    output reg [31:0] Instr

);

always @(negedge CLK) begin
    if(Resetn) begin
        pc <= nowpc;
        Instr <= Instr_i;
    end
        
    else  begin
        pc <= 32'b0;
        Instr <= 32'b0;
    end
        
end


endmodule 
