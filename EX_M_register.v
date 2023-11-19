module EX_M_register (
    input CLK,
    input Resetn,

    input busB_i, //从ID_EX busB的数据，
                  //一部分流入exe，一部分到下一寄存器 
    input Rd_data, //写入地址
    input ALUout_i, //ALU计算结果
    input zero_i, //判0
    input Target_i,



    //control signal
    input MemtoReg_i,
    input Regwr_i,
    input Jump_i,
    input Branch_i,
    input MemWr_i,
    

    output reg MemWr,
    output reg Branch,
    output reg Jump,
    output reg MemtoReg,
    output reg Regwr,
    output reg Zero,

    output reg [31:0] busB,
    output reg [31:0] Target,
    output reg [31:0] Rd,
    output reg [31:0] ALUout
 
);


always @(negedge CLK ) begin
    if(!Resetn) begin
        MemWr <= 1'b0;
        Branch <= 1'b0;
        Jump <= 1'b0;
        MemtoReg <= 1'b0;
        Regwr <= 1'b0;
        Zero <= 1'b0;
        busB <= 32'b0;
        ALUout <= 32'b0;
        Rd <= 32'b0;
        Target <= 32'b0;
    end
        
    else begin
        MemWr <= MemWr_i;
        Branch <= Branch_i;
        Jump <= Jump_i;
        MemtoReg <= MemtoReg_i;
        Regwr <= Regwr_i;
        Zero <= zero_i;
        busB <= busB_i;
        ALUout <= ALUout_i;
        Rd <= Rd_data;
        Target <= Target_i;
    end
end
    
endmodule