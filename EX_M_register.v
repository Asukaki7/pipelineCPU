module EX_M_register (
    input CLK,
    input Resetn,

    input [31:0] busB_EX, //从ID_EX busB的数据，
                  //一部分流入exe，一部分到下一寄存器 
    input [31:0] ALUout_EX, //ALU计算结果
    input [31:0] Target_EX,
    input [4:0] Rd_EX, //写入地址
    input [4:0] Rb_EX,

    //control signal
    input MemtoReg_EX,
    input RegWr_EX,
    input Jump_EX,
    input Branch_EX,
    input MemWr_EX,
    input Zero_EX, //判0

    output reg MemWr_M,
    output reg Branch_M,
    output reg Jump_M,
    output reg MemtoReg_M,
    output reg RegWr_M,
    output reg Zero_M,

    output reg [31:0] busB_M,
    output reg [31:0] Target_M,
    output reg [4:0] Rd_M,
    output reg [4:0] Rb_M,
    output reg [31:0] ALUout_M
 
);


always @(negedge CLK or negedge Resetn ) begin
    if(!Resetn) begin
        MemWr_M <= 1'b0;
        Branch_M <= 1'b0;
        Jump_M <= 1'b0;
        MemtoReg_M <= 1'b0;
        RegWr_M <= 1'b0;
        Zero_M <= 1'b0;
        busB_M <= 32'b0;
        ALUout_M <= 32'b0;
        Rd_M <= 5'b0;
        Target_M <= 32'b0;
        Rb_M <= 5'b0;
    end
        
    else begin
        MemWr_M <= MemWr_EX;
        Branch_M <= Branch_EX;
        Jump_M <= Jump_EX;
        MemtoReg_M <= MemtoReg_EX;
        RegWr_M <= RegWr_EX;
        Zero_M <= Zero_EX;
        busB_M <= busB_EX;
        ALUout_M <= ALUout_EX;
        Rd_M <= Rd_EX;
        Target_M <= Target_EX;
        Rb_M <= Rb_EX;
    end
end
    
endmodule