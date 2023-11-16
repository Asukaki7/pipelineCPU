module M_WB_register (

    input CLK,
    input MemtoReg_i,
    input RegWr_i,
    input Do_i,
    input Rd_i,
    input ALUout_i,
    input Resetn,

    //control signal
    output reg MemtoReg,
    output reg RegWr,

    output reg [31:0] Do, //lw写入数据
    output reg [31:0] Rd,// lw写入地址
    output reg [31:0] ALUout //jal 写入的pc+4 存至Rd
);

always @(negedge CLK ) begin
    if(!Resetn) begin
        MemtoReg <= 1'b0;
        RegWr <= 1'b0;
        Do <= 32'b0;
        Rd <= 32'b0;
        ALUout <=32'b0;
    end
    
    else begin
        MemtoReg <= MemtoReg_i;
        RegWr <= RegWr_i;
        Do <= Do_i;
        Rd <= Rd_i;
        ALUout <= ALUout_i;
        
    end
end

    
endmodule