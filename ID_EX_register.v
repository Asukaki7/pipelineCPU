module ID_EX_register(
    input CLK,
    input Resetn, 

    
    input [31:0] imm,
    input [31:0] nowPC,
    input [31:0] rs1_Data, //data from rs1
    input [31:0] rs2_Data, //data from rs2
    input [5:0] Rd_Data, //read address
    

    //control signal 
    input MemWr_i,
    input Branch_i,
    input Jump_i,
    input MemtoReg_i,
    input RegWr_i,
    input ALUASrc_i,
    input ALUBSrc_i,
    input[3:0]  ALUctr_i,

    output reg [31:0] busA_EX,
    output reg [31:0] busB_EX,
    output reg [31:0] PC_EX,
    output reg [5:0] Rd_EX,
    output reg [31:0] imm_EX,
    output reg MemWr_EX,
    output reg Branch_EX,
    output reg Jump_EX,
    output reg MemtoReg_EX,
    output reg RegWr_EX,
    output reg ALUASrc_EX,
    output reg [1:0] ALUBSrc_EX,
    output reg [3:0] ALUctr_EX
);


always @(negedge CLK ) begin
    if(!Resetn) begin
        busA_EX <= 32'b0;
        busB_EX <= 32'b0;
        PC_EX <= 32'b0;
        Rd_EX <= 6'b0;
        MemWr_EX <= 1'b0;
        Branch_EX <= 1'b0;
        Jump_EX <= 1'b0;
        MemtoReg_EX <= 1'b0;
        RegWr_EX <= 1'b0;
        ALUASrc_EX <= 1'b0;
        ALUBSrc_EX <= 2'b0;
        ALUctr_EX <= 4'b0;
    end
    else begin
        busA_EX <= rs1_Data;
        busB_EX <= rs2_Data;
        PC_EX <= nowPC;
        Rd_EX <= Rd_Data;
        MemWr_EX <= MemWr_i;
        Branch_EX <= Branch_i;
        Jump_EX <= Jump_i;
        MemtoReg_EX <= MemtoReg_i;
        RegWr_EX <= RegWr_i;
        ALUASrc_EX <= ALUASrc_i;
        ALUBSrc_EX <= ALUBSrc_i;
        ALUctr_EX <= ALUctr_i;
    end
end



endmodule