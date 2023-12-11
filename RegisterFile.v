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




 initial begin
        registerF[0] <= 32'd0;
        registerF[1] <= 32'd0;
        registerF[2] <= 32'd0;
        registerF[3] <= 32'd0;
        registerF[4] <= 32'd0;
        registerF[5] <= 32'd0;
        registerF[6] <= 32'd0;
        registerF[7] <= 32'd0;
        registerF[8] <= 32'd0;
        registerF[9] <= 32'd0;
        registerF[10] <= 32'd0;
        registerF[11] <= 32'd0;
        registerF[12] <= 32'd0;
        registerF[13] <= 32'd0;
        registerF[14] <= 32'd0;
        registerF[15] <= 32'd0;
        registerF[16] <= 32'd0;
        registerF[17] <= 32'd0;
        registerF[18] <= 32'd0;
        registerF[19] <= 32'd0;
        registerF[20] <= 32'd0;
        registerF[21] <= 32'd0;
        registerF[22] <= 32'd0;
        registerF[23] <= 32'd0;
        registerF[24] <= 32'd0;
        registerF[25] <= 32'd0;
        registerF[26] <= 32'd0;
        registerF[27] <= 32'd0;
        registerF[28] <= 32'd0;
        registerF[29] <= 32'd0;
        registerF[30] <= 32'd0;
        registerF[31] <= 32'd0;
end 


//同步写
always @(negedge CLK ) begin
    if(RegWr == 1'b1) begin
        if(Rw == 1'b0)begin
            
        end
        else begin
            registerF[Rw] <= Di;
        end
    end
end

//异步读
assign busA = (~Resetn) ? 32'b0 : registerF[Ra];
assign busB = (~Resetn) ? 32'b0 : registerF[Rb];

endmodule  