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
reg [31:0]  mem[0:31];

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