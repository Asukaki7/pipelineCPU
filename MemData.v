//数据寄存器堆
module MemData (
    input CLK,
    input [31:0] RA,
    input [31:0] WA,
    input [31:0] Di, //data input
    input Resetn,
    
    input MemWr, //control signal

    output reg [31:0] Do //data output
);

//同步写 异步读
reg [31:0]  mem[0:255];

initial begin
    mem[0] <= 32'd0;
    mem[1] <= 32'd1;
    mem[2] <= 32'd2;
    mem[3] <= 32'd3;
    mem[4] <= 32'd4;
    mem[5] <= 32'd5;
    mem[6] <= 32'd6;
    mem[7] <= 32'd7;
    mem[8] <= 32'd8;
    mem[9] <= 32'd9;
end



always @(*) begin
    if (~Resetn) begin
        Do <= 32'b0;
    end
    else begin
        Do <= mem[RA];
    end
end

always @(negedge CLK ) begin
    if(MemWr && Resetn) begin
        mem[WA] <= Di;
    end
end

endmodule