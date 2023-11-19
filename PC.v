module PC(
    input          CLK,
    input  [31:0] PC_i,
    input Resetn,
    output reg [31:0]   PC
    
);

initial begin    
        PC <= 0;   
    end 

always @(negedge CLK) begin
    if(!Resetn)
        PC <= 32'b0;
    else
        PC <= PC_i;
end


endmodule 