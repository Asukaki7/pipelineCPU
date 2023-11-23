module InstMem(
    input [31:0] PC,
    input Resetn,
    
    output reg [31:0] Instr
);

reg [31:0] instMem_text[0:255];

initial begin
        instMem_text[0]<=32'b00000000000100000010000010000011; //00102083 lw DM 1 to rs 1
        instMem_text[1]<=32'b00000000001000000010000100000011; //00202103 lw DM 2 to rs 2
        instMem_text[2]<=32'b00000000001100000010000110000011; //00302183 lw DM 3 to rs 3
        instMem_text[3]<=32'b00000000010000000010001000000011; //00402203 lw DM 4 to rs 4
        instMem_text[4]<=32'b00000000001100010000001010110011; //003102b3 add rs 2 + rs 3 to rs 5
        instMem_text[5]<=32'b00000000010100000010010100100011; //00502523 sw rs 5 to DM 10
        instMem_text[6]<=32'b01000000000100101000001100110011; //40128333 sub rs 5 - rs 1 to rs 6 
        instMem_text[7]<=32'b00000000001000001010001110110011; //0020a3b3  slt rs 1 < rs 2 ? 1 : 0 (1)  (to rs 7  = 1)
        instMem_text[8]<=32'b00000000000100010011010000110011; //00113433 sltu rs 2 < rs 1 ? 1 : 0 (0)  (to rs 8  = 0)
        instMem_text[9]<=32'b00000000000100011110010010010011;  //0011e493 ori imm 1 ^ rs 3 to rs 9  = 2
        instMem_text[10]<=32'b00000000000000000001010100110111; //00001537 lui imm 1 << 12 to rs 10  = 1 << 12
        instMem_text[11]<=32'b11111100000100111000100011100011; //fc1388e3 beq rs 1 == rs 7 ? jump to 0
        instMem_text[12]<=32'b00000010000000000000000011101111; //020000ef jal + 8;
        instMem_text[13]<=32'h0000_0000;
        instMem_text[14]<=32'h0000_0000;
        instMem_text[15]<=32'h0000_1111;
        instMem_text[16]<=32'h0001_0000;
        instMem_text[17]<=32'h0001_0001;
        instMem_text[18]<=32'h0000_0000;
        instMem_text[19]<=32'h0000_0000;
        instMem_text[20]<=32'h0000_0000;
        instMem_text[21]<=32'h0000_0000;
        
        

end  
   
       
/* initial $readmemh("e:/coding/Fpga_project_digital/pipelineCPU/Instr.txt",instMem_text); */

always @(*) begin
        if(!Resetn)
            Instr<=0;
        else
            Instr <= instMem_text[PC[9:2]];
    end
endmodule  