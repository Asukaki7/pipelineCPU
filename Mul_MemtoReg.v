module Mul_MemtoReg (
    input [31:0] Do,
    input [31:0] ALUout,

    //control signal
    input MemtoReg,


    output [31:0] Di //写入数据
);

assign Di = MemtoReg? Do : ALUout;


endmodule