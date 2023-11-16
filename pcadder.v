module pcadder_IF(
    input [31:0] nowPc,

    output reg [31:0]  nextPc
);


always @(*) begin
    nextPc<=nowPc+32'h0000_0004; //空跳转+4
end

endmodule 