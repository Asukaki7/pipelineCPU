module EX_M_register (
    input CLK,
    input Resetn,

    input busB_i, //从ID_EX busB的数据，
                  //一部分流入exe，一部分到下一寄存器 
    input Rd_data, //写入地址
    input ALUout_i, //ALU计算结果
    input zero_i, //判0




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


    output reg ALUout,
    output reg [:] ;
);


always @(negedge CLK ) begin
    if(Resetn)

end
    
endmodule