module RegisterFile(
    input  CLK,
    input RegWr,
    input Resetn,

    input [4:0] Rw,//写入地址
    input [31:0] Di, //写入数据

    input [4:0] Ra,//读取地址1
    output wire [31:0] busA,//读出数据1


    input [4:0] Rb,//读取地址2
    output wire [31:0] busB//读出数据2
);

reg [31:0] registerF [0:31];



//同步写
always @(posedge CLK ) begin
    if(RegWr&&Resetn)begin
        registerF[Rw] <= Di;
    end
end

//异步读
assign busA = (~Resetn) ? 32'b0 : registerF[Ra];
assign busB = (~Resetn) ? 32'b0 : registerF[Rb];

endmodule  