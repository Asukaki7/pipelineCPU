module pcadder_IF(
    input [31:0] nowPc,

    output wire  [31:0]  nextPc
);

/* 
always @(*) begin
    nextPc <= nowPc+32'h0000_0004; //空跳转+4
end */

assign nextPc = nowPc + 32'h0000_0004;
endmodule 