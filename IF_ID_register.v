module IF_ID_register(
    input CLK,
    input [31:0] PC_i,
    input [31:0] Instr_i,
    input Resetn,
    input En,


    output reg [31:0] PC,
    output reg [31:0] Instr,
    output wire [4:0] ID_Ra_out,
    output wire [4:0] ID_Rb_out


);

always @(negedge CLK ) begin
    if(~Resetn) begin
        PC <= 32'b0;
        Instr <= 32'b0;
        
    end
        
    else  begin
        if(En) begin
            PC <= PC;
            Instr <= Instr; 
        end
        else begin
            PC <= PC_i;
            Instr <= Instr_i;    
        end
        
    end
        
end



assign ID_Ra_out = Instr_i[19:15];
assign ID_Rb_out = Instr_i[24:20];

endmodule 
