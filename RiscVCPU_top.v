module RiscVCPU_top(
    input CLK,
    input Resetn //
);



//***************************************//
//IF unit
wire [31:0] Target, nextpc, PC_i, PC;
wire Zero, Branch, Jump;
wire [31:0] Instr;
//***************************************//


//***************************************//
//IF_ID pipelineRegisters
wire [31:0] PC_ID;
wire [31:0] Instr_ID;
//***************************************//


//***************************************//
//ID Unit
wire [2:0]  Extop;
wire [31:0] imm;
wire [4:0] Rd, Ra, Rb;
wire ALUASrc;
wire [1:0] ALUBSrc;
wire [3:0] ALUctr;
wire MemWr, RegWr, MemtoReg;
wire [31:0] Di;
wire [31:0] Rw;
//***************************************//




//***************************************//
 //ID_EX pipelineRegisters
wire [31:0] busA_EX, busB_EX, PC_EX,imm_EX;
wire [4:0] Rd_EX;
wire MemWr_EX, Branch_EX, Jump_EX, MemtoReg_EX, RegWr_EX;
wire ALUASrc_EX;
wire [1:0] ALUBSrc_EX;
wire [3:0] ALUctr_EX;
//***************************************//



//***************************************//
//EX Unit
wire [31:0] ALUout;
//***************************************//


//***************************************//
 //EX_MEM pipelineRegisters

wire [31:0] busB_M, Target_M, ALUout_M ;
wire [4:0] Rd_M;
wire MemWr_M, Branch_M, Jump_M, MemtoReg_M, RegWr_M, Zero_M;

//***************************************//


//***************************************//
//Mem unit
wire [31:0] Do;
//***************************************//




//***************************************//
//MEM_WB pipelineRegisters
wire MemtoReg_WB, RegWr_WB;
wire [4:0] Rd_WB;
wire [31:0] Do_WB, ALUout_WB;
//***************************************//







//***************************************//
//IF unit

Mul_PC u_Mul_PC(
    //input port
    .Target (Target_M ),
    .nextpc (nextpc ),


    .Zero   (Zero_M   ),
    .Branch (Branch_M ),
    .Jump   (Jump_M   ),

    //ouput port
    .PC_i   (PC_i   )
);

PC u_PC(
    .CLK    (CLK    ),
    .PC_i   (PC_i   ),
    .Resetn (Resetn ),
    .PC     (PC     )
);

pcadder_IF u_pcadder_IF(
    .nowPc  (PC  ),
    .nextPc (nextPc )
);
InstMem u_InstMem(
    .PC     (PC     ),
    .Resetn (Resetn ),
    .Instr  (Instr  )
);

//***************************************//






//***************************************//
//IF_ID pipelineRegisters

IF_ID_register u_IF_ID_register(
    //input port
    .CLK     (CLK     ),
    .PC_i    (PC      ),
    .Instr_i (Instr   ),
    .Resetn  (Resetn  ),

    //output port
    .PC      (PC_ID   ),
    .Instr   (Instr_ID)
);

//***************************************//




//***************************************//
//ID Unit
IE u_IE(
    .Instr (Instr_ID ),

    .Extop (Extop ),

    .imm   (imm   )
);


ID u_ID(
    //input port
    .Resetn   (Resetn   ),
    .Instr    (Instr    ),

    //ouput port
    .Rd       (Rd       ),
    .Ra       (Ra       ),
    .Rb       (Rb       ),

    .Extop    (Extop    ),

    .ALUASrc  (ALUASrc  ),
    .ALUBSrc  (ALUBSrc  ),
    .ALUctr   (ALUctr   ),

    .MemWr    (MemWr    ),
    .Branch   (Branch   ),
    .Jump     (Jump     ),

    .MemtoReg (MemtoReg ),
    .RegWr    (RegWr    )
);

RegisterFile u_RegisterFile(
    .CLK    (CLK    ),
    .RegWr  (RegWr_WB  ),
    .Resetn (Resetn ),
    .Rw     (Rd_WB     ), //写入地址
    .Di     (Di     ), //写入数据
    .Ra     (Ra     ), //读取地址1
    .busA   (busA   ), //读取数据1
    .Rb     (Rb     ), //读取地址2
    .busB   (busB   )  //读取数据2
);

//***************************************//





//***************************************//
 //ID_EX pipelineRegisters
ID_EX_register u_ID_EX_register(

     //input port
    .CLK         (CLK         ),
    .Resetn      (Resetn      ),
    .imm         (imm         ),
    .nowPC       (PC_ID       ),
    .rs1_Data    (busA    ),
    .rs2_Data    (busB    ),
    .Rd_Data     (Rd     ),
    .MemWr_i     (MemWr     ),
    .Branch_i    (Branch    ),
    .Jump_i      (Jump      ),
    .MemtoReg_i  (MemtoReg  ),
    .RegWr_i     (RegWr     ),
    .ALUASrc_i   (ALUASrc   ),
    .ALUBSrc_i   (ALUBSrc   ),
    .ALUctr_i    (ALUctr    ),

    //output port
    .busA_EX     (busA_EX     ),
    .busB_EX     (busB_EX     ),
    .PC_EX       (PC_EX       ),
    .Rd_EX       (Rd_EX       ),
    .imm_EX      (imm_EX      ),
    .MemWr_EX    (MemWr_EX    ),
    .Branch_EX   (Branch_EX   ),
    .Jump_EX     (Jump_EX     ),
    .MemtoReg_EX (MemtoReg_EX ),
    .RegWr_EX    (RegWr_EX    ),
    .ALUASrc_EX  (ALUASrc_EX  ),
    .ALUBSrc_EX  (ALUBSrc_EX  ),
    .ALUctr_EX   (ALUctr_EX   )
);

//***************************************//




//***************************************//
parameter ADD = 4'b0000;
parameter SUB = 4'b1000;
parameter SLT = 4'b0010;
parameter SLTU = 4'b0011;
parameter OR = 4'b0110;
parameter srcB = 4'b1111;  

//EX Unit
EX_ALU 
#(
    .ADD  (ADD  ),
    .SUB  (SUB  ),
    .SLT  (SLT  ),
    .SLTU (SLTU ),
    .OR   (OR   ),
    .srcB (srcB )
)
u_EX_ALU(
    //input port
    .PC      (PC_EX      ),
    .ALUctr  (ALUctr_EX  ),
    .ALUASrc (ALUASrc_EX ),
    .ALUBSrc (ALUBSrc_EX ),
    .busA    (busA_EX    ),
    .busB    (busB_EX    ),
    .imm     (imm_EX     ),

    //output port
    .ALUout  (ALUout  ),
    .Target  (Target  ),
    .Zero    (Zero    )
);
//***************************************//



//***************************************//
 //EX_MEM pipelineRegisters
EX_M_register u_EX_M_register(
    //input port
    .CLK        (CLK        ),
    .Resetn     (Resetn     ),
    .busB_i     (busB_EX     ),
    .Rd_data    (Rd_EX    ),
    .ALUout_i   (ALUout   ),
    .zero_i     (Zero     ),
    .Target_i   (Target   ),

    .MemtoReg_i (MemtoReg_EX ),
    .Regwr_i    (RegWr_EX    ),
    .Jump_i     (Jump_EX     ),
    .Branch_i   (Branch_i   ),
    .MemWr_i    (MemWr_EX    ),


    //output port
    .MemWr      (MemWr_M      ),
    .Branch     (Branch_M     ),
    .Jump       (Jump_M       ),
    .MemtoReg   (MemtoReg_M   ),
    .Regwr      (RegWr_M      ),
    .Zero       (Zero_M       ),
    .busB       (busB_M       ),
    .Target     (Target_M     ),
    .Rd         (Rd_M         ),
    .ALUout     (ALUout_M     )
);
//***************************************//

//***************************************//
//Mem unit

MemData u_MemData(
    //异步读 同步写
    .CLK    (CLK    ),
    .RA     (ALUout_M     ),
    .WA     (ALUout_M     ),
    .Di     (busB_M     ),
    .Resetn (Resetn ),
    .MemWr  (MemWr_M  ),

    .Do     (Do     )
);

//***************************************//



//***************************************//
//MEM_WB pipelineRegisters
M_WB_register u_M_WB_register(
    //input port
    .CLK        (CLK        ),
    .MemtoReg_i (MemtoReg_M ),
    .RegWr_i    (RegWr_M    ),
    .Do_i       (Do       ),
    .Rd_i       (Rd_M       ),
    .ALUout_i   (ALUout_M   ),
    .Resetn     (Resetn     ),

    //output port
    .MemtoReg   (MemtoReg_WB   ),
    .RegWr      (RegWr_WB      ),
    .Do         (Do_WB         ),
    .Rd         (Rd_WB         ),
    .ALUout     (ALUout_WB     )
);
//***************************************//


//***************************************//
//WB unit

Mul_MemtoReg u_Mul_MemtoReg(
    .Do       (Do_WB       ),
    .ALUout   (ALUout_WB   ),

    .MemtoReg (MemtoReg_WB ),
    .Di       (Di       )
);
//***************************************//










endmodule