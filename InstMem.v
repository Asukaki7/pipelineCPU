module InstMem(
    input [31:0] PC,
    input Resetn,
    
    output reg [31:0] Instr
);

reg [31:0] instMem_text[0:255];

initial begin
        instMem_text[0]<=32'b0000000_00001_00000_000_00001_0010011;
end 
   
       

 //initial $readmemh("C:/Users/Desktop/RISCV_CPU/Instr.txt",instMem_text);

always @(*) begin
        if(!Resetn)
            Instr<=0;
        else
          Instr<=instMem_text[PC[9:2]];
    end
endmodule