module PC(
    input CLK,
    input   [31:0] nowpc,
    input clear,
    output reg [31:0]   nextpc
    
);

initial begin    
        nextpc <= 0;   
    end 

always @(negedge CLK) begin
    if(clear)
        nextpc <= 32'b0;
    else
        nextpc <= nowpc;
end


endmodule 