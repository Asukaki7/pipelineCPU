module Mul_ctr_loadUse (
    input MemWr,
    input Branch,
    input Jump,
    input MemtoReg,
    input RegWr,
    input ALUASrc,
    input [1:0] ALUBSrc,
    input [3:0]  ALUctr,
    input MemRead,

    input CLoad_Use,

    output wire MemWr_ID,
    output wire Branch_ID,
    output wire Jump_ID,
    output wire MemtoReg_ID,
    output wire RegWr_ID,
    output wire ALUASrc_ID,
    output wire [1:0] ALUBSrc_ID,
    output wire [3:0]  ALUctr_ID

);
    

assign MemWr_ID = CLoad_Use? 1'b0: MemWr;
assign Branch_ID = CLoad_Use? 1'b0:Branch;
assign Jump_ID = CLoad_Use? 1'b0:Jump;
assign MemtoReg_ID = CLoad_Use? 1'b0:MemtoReg;
assign RegWr_ID = CLoad_Use? 1'b0:RegWr;
assign ALUASrc_ID = CLoad_Use? 1'b0:ALUASrc;
assign ALUBSrc_ID = CLoad_Use? 2'b0:ALUBSrc;
assign ALUctr_ID = CLoad_Use? 4'b0:ALUctr;

endmodule