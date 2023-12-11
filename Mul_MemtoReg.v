//主要是对于lw和R型指令等WB，
//将相应的计算出的数据或者取到的数据写回到RegFile中
//另一种当信号为0时候表示的是jal指令将相应的跳转的结果写回。
module Mul_MemtoReg (
    input [31:0] Do,
    input [31:0] ALUout,

    //control signal
    input MemtoReg,


    output [31:0] Di //写入数据
);

assign Di = MemtoReg? Do : ALUout;


endmodule 