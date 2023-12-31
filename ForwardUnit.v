/* 
转发检测单元，可以解决：
①	相邻两条ALU运算类指令间的数据相关
②	相隔一条ALU运算类指令间的数据相关
③	相隔一条指令的Load和ALU运算指令之间的数据相关
*/
module ForwardUnit(
    input RegWr_M,
    input MemWr_M,
    input [4:0] Rd_M,
    
    input [4:0] Ra_EX,
    input [4:0] Rb_EX,
    input [4:0] Rb_M,
    input wire RegWr_WB,
    input wire [4:0] Rd_WB,
    
    output wire [1:0] BusAFw,
    output wire [1:0] BusBFw,
    output wire DiSrc
);

 //紧邻
assign BusAFw[1] = RegWr_M && (Rd_M != 5'b00000) && (Rd_M == Ra_EX);
assign BusBFw[1] = RegWr_M && (Rd_M != 5'b00000) && (Rd_M == Rb_EX);

//间隔
assign BusAFw[0] = RegWr_WB && (Rd_WB != 5'b00000) && (Rd_M != Ra_EX) && (Rd_WB == Ra_EX);
assign BusBFw[0] = RegWr_WB && (Rd_WB != 5'b00000) && (Rd_M != Rb_EX) && (Rd_WB == Rb_EX);

// R - S
assign DiSrc = RegWr_WB && (Rd_WB != 5'b00000) && (Rd_WB == Rb_M) && MemWr_M;




endmodule