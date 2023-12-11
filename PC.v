module PC(
    input CLK,
    input [31:0] PC_i,
    input Resetn,
    input En,
    output wire  [31:0]   PC
    
);
reg [31:0] PC0;

assign PC = PC0;

initial begin    
        PC0 <= 32'd0;   
    end  

always @(negedge CLK  ) begin

    if(~Resetn) begin
        PC0 <= 32'd0;
    end
        
    else begin
         if (En)begin
            PC0 <= PC0;
         end
         else begin
            PC0 <= PC_i;
         end
    end
end

endmodule 