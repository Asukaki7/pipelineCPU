module M_WB_register (

    input CLK,
    input Resetn,
    input MemtoReg_M,
    input RegWr_M,
    input [31:0] Do_M,
    input [4:0] Rd_M,
    input [31:0] ALUout_M,
    

    //control signal
    output reg MemtoReg_WB,
    output reg RegWr_WB,

    output reg [31:0] Do_WB, //lw写入数据
    output reg [4:0] Rd_WB,// lw写入地址
    output reg [31:0] ALUout_WB //jal 写入的pc+4 存至Rd
);

always @(negedge CLK ) begin
    if(!Resetn) begin
        MemtoReg_WB <= 1'b0;
        RegWr_WB <= 1'b0;
        Do_WB <= 32'b0;
        Rd_WB <= 5'b0;
        ALUout_WB <=32'b0;
    end
    
    else begin
        MemtoReg_WB <= MemtoReg_M;
        RegWr_WB <= RegWr_M;
        Do_WB <= Do_M;
        Rd_WB <= Rd_M;
        ALUout_WB <= ALUout_M;
        
    end
end

    
endmodule