`timescale 1ns/1ps
module RiscVCPU_top_tb (
);

reg CLK;
reg Resetn;

wire [31:0] out_Instr;
wire [31:0] out_PC;
//ID
wire [2:0] out_Extop;
//EX
wire out_ALUASrc;
wire [1:0] out_ALUBSrc;
wire [3:0] out_ALUctr;
//Mem
wire out_MemWr;
wire out_Branch;
wire out_Jump;
//WB
wire out_MemtoReg;
wire out_RegWr;
wire [31:0] out_busA_ex;
wire [31:0] out_busB_ex;
wire [4:0]  out_Rd_ex;
wire [4:0] out_Ra;
wire [4:0] out_Rb;
//ex_alu_out;zero;target
wire [31:0] out_ALUout;
wire out_Zero;
wire [31:0] out_Target;
//m_do
wire [31:0] out_Di;
wire out_En;
wire [31:0] out_imm;
wire [31:0] out_PC_EX;

RiscVCPU_top u_RiscVCPU_top(
    .CLK          (CLK          ),
    .Resetn       (Resetn       ),
    .out_En       (out_En       ),
    .out_Instr    (out_Instr    ),
    .out_PC       (out_PC       ),
    .out_Extop    (out_Extop    ),
    .out_ALUASrc  (out_ALUASrc  ),
    .out_ALUBSrc  (out_ALUBSrc  ),
    .out_ALUctr   (out_ALUctr   ),
    .out_MemWr    (out_MemWr    ),
    .out_Branch   (out_Branch   ),
    .out_Jump     (out_Jump     ),
    .out_MemtoReg (out_MemtoReg ),
    .out_RegWr    (out_RegWr    ),
    .out_busA_ex  (out_busA_ex  ),
    .out_busB_ex  (out_busB_ex  ),
    .out_Rd_ex    (out_Rd_ex    ),
    .out_ALUout   (out_ALUout   ),
    .out_Zero     (out_Zero     ),
    .out_Target   (out_Target   ),
    .out_Di       (out_Di       ),
    .out_Ra    (out_Ra),
    .out_Rb         (out_Rb),
    .out_imm (out_imm),
    .out_PC_EX(out_PC_EX)

);




//begin
initial begin
    CLK <= 1'b0;
    Resetn <= 1'b0;
    #10
    Resetn <= 1'b1;
    #460
    $stop;
 
end



always #10 CLK <= ~CLK;

endmodule 