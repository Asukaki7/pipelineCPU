module EX_ALU_tb();

reg [31:0] PC_EX;
reg [31:0]  BusAFw_out, BusBFw_out, imm_EX;
reg [3:0] ALUctr_EX;
reg ALUASrc_EX;
reg [1:0] ALUBSrc_EX;
wire [31:0] Target,ALUout;
wire Zero;

EX_ALU u_EX_ALU(
    //input port
    .PC      (PC_EX      ),
    .ALUctr  (4'b0000  ),
    .ALUASrc (ALUASrc_EX ),
    .ALUBSrc (ALUBSrc_EX ),
    .busA    (32'h0000_1111    ),
    .busB    (32'h1111_0000   ),
    .imm     (imm_EX     ),

    //output port
    .ALUout  (ALUout  ),
    .Target  (Target  ),
    .Zero    (Zero    )
);


initial begin
    #10
    PC_EX <= 32'h0000_0001;
    imm_EX <= 32'h0000_0001;
    ALUASrc_EX <= 1;
    ALUBSrc_EX <= 2'd2;
    #10;
end

endmodule