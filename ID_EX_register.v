module ID_IE_register(
    input CLK,
    input Resetn, 

    
    input [31:0] imm,
    input [31:0] nowpc,
    input [31:0] rs1_Data, //data from rs1
    input [31:0] rs2_Data, //data from rs2
    input [5:0] Rd_Data, //read address
    

    //control signal 
    input MemWr_i,
    input Branch_i,
    input Jump_i,
    input MemtoReg_i,
    input RegWr_i,
    input AluActr_i,
    input AluBctr_i,
    input AluCctr_i,

    output reg [31:0] busA,
    output reg [31:0] busB,
    output reg [31:0] pc,
    output reg [5:0] Rd,
    output reg MemWr,
    output reg Branch,
    output reg Jump,
    output reg MemtoReg,
    output reg RegWr,
    output reg AluActr,
    output reg AluBctr,
    output reg AluCctr
);


always @(negedge CLK ) begin
    if(Resetn) begin
        busA <= 32'b0;
        busB <= 32'b0;
        pc <= 32'b0;
        Rd <= 6'b0;
        MemWr <= 1'b0;
        Branch <= 1'b0;
        Jump <= 1'b0;
        MemtoReg <= 1'b0;
        RegWr <= 1'b0;
        AluActr <= 1'b0;
        AluBctr <= 1'b0;
        AluCctr <= 1'b0;
    end
    else begin
        busA <= rs1_Data;
        busB <= rs2_Data;
        pc <= nowpc;
        Rd <= Rd_Data;
        MemWr <= MemWr_i;
        Branch <= Branch_i;
        Jump <= Jump_i;
        MemtoReg <= MemtoReg_i;
        RegWr <= RegWr_i;
        AluActr <= AluActr_i;
        AluBctr <= AluBctr_i;
        AluCctr <= AluCctr_i;
    end
end



endmodule