                                                                               module ID_EX_register(
    input CLK,
    input Resetn, 

    
    input [31:0] imm,
    input [31:0] nowPC,
    input [31:0] rs1_Data, //data from rs1
    input [31:0] rs2_Data, //data from rs2
    input [4:0] Rd_Data, //read address
    input [4:0] Ra_ID, 
    input [4:0] Rb_ID,

    //control signal 
    input MemWr_ID,
    input Branch_ID,
    input Jump_ID,
    input MemtoReg_ID,
    input RegWr_ID,
    input ALUASrc_ID,
    input [1:0] ALUBSrc_ID,
    input [3:0]  ALUctr_ID,


    output reg [4:0]  Ra_EX,
    output reg [4:0]  Rb_EX,
    output reg [31:0] busA_EX,
    output reg [31:0] busB_EX,
    output reg [31:0] PC_EX,
    output reg [4:0] Rd_EX,
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
        Ra_EX <= 5'b0;
        Rb_EX <= 5'b0;
    end
    else begin
        busA_EX <= rs1_Data;
        busB_EX <= rs2_Data;
        PC_EX <= nowPC;
        Rd_EX <= Rd_Data;
        MemWr_EX <= MemWr_ID;
        Branch_EX <= Branch_ID;
        Jump_EX <= Jump_ID;
        MemtoReg_EX <= MemtoReg_ID;
        RegWr_EX <= RegWr_ID;
        ALUASrc_EX <= ALUASrc_ID;
        ALUBSrc_EX <= ALUBSrc_ID;
        ALUctr_EX <= ALUctr_ID;
        Ra_EX <= Ra_ID;
        Rb_EX <= Rb_ID;
    end
end



endmodule