module RiscVCPU_top(
    input CLK,
    input Resetn, //

    output wire out_En,
    output wire [31:0] out_Instr,
    output wire [31:0] out_PC,
    //ID
    output wire [2:0] out_Extop,
    output wire [4:0] out_Ra,
    output wire [4:0] out_Rb,
    //EX
    output wire out_ALUASrc,
    output wire [1:0] out_ALUBSrc,
    output wire [3:0] out_ALUctr,
    //Mem
    output wire out_MemWr,
    output wire out_Branch,
    output wire out_Jump,
    //WB
    output wire out_MemtoReg,
    output wire out_RegWr,
    output wire [31:0] out_busA_ex,
    output wire [31:0] out_busB_ex,
    output wire [4:0]  out_Rd_ex,
    //ex_alu_out,zero,target
    output wire [31:0] out_ALUout,
    output wire out_Zero,
    output wire [31:0] out_Target,
    //m_do
    output wire [31:0] out_Di,
    output wire [31:0] out_imm,
    output wire [31:0] out_PC_EX
);



//***************************************//
//IF unit
wire [31:0] Target, PC_i, PC, nextPc;
wire Zero, Branch, Jump;
wire [31:0] Instr;
//***************************************//


//***************************************//
//IF_ID pipelineRegisters
wire [31:0] PC_ID;
wire [31:0] Instr_ID;
wire [4:0] ID_Ra_out, ID_Rb_out;
//***************************************//


//***************************************//
//ID Unit
wire [2:0]  Extop;
wire [31:0] imm;
wire [4:0] Rd;
wire [31:0] busA, busB;
wire ALUASrc, ALUASrc_ID;
wire [1:0] ALUBSrc, ALUBSrc_ID;
wire [3:0] ALUctr, ALUctr_ID;
wire MemWr, RegWr, MemtoReg, MemWr_ID, RegWr_ID, MemtoReg_ID;
wire [31:0] Di;
wire [31:0] Rw;
wire MemRead, CLoad_Use;
wire Branch_ID, Jump_ID;


//***************************************//




//***************************************//
 //ID_EX pipelineRegisters
wire [31:0] busA_EX, busB_EX, PC_EX,imm_EX;
wire [4:0] Rd_EX;
wire MemWr_EX, Branch_EX, Jump_EX, MemtoReg_EX, RegWr_EX;
wire ALUASrc_EX;
wire [1:0] ALUBSrc_EX;
wire [3:0] ALUctr_EX;
wire  MemRead_EX;
wire [4:0] Ra_EX,Rb_EX;
//***************************************//



//***************************************//
//EX Unit
wire [31:0] ALUout;
wire [31:0] BusAFw_out, BusBFw_out;
//***************************************//


//***************************************//
 //EX_MEM pipelineRegisters

wire [31:0] busB_M, Target_M, ALUout_M ;
wire [4:0] Rd_M, Rb_M;

wire MemWr_M, Branch_M, Jump_M, MemtoReg_M, RegWr_M, Zero_M;

//***************************************//


//***************************************//
//Mem unit
wire [31:0] Do;
wire [1:0] BusAFw,BusBFw;
wire DiSrc;
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
    .nextPc (nextPc ),


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
    .En     (CLoad_Use ),
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
    .CLK       (CLK       ),
    .PC_i      (PC_i      ),
    .Instr_i   (Instr   ),
    .Resetn    (Resetn    ),
    .En        (CLoad_Use ),
    //output port
    .PC        (PC_ID        ),
    .Instr     (Instr_ID     ),
    .ID_Ra_out (ID_Ra_out ), //load-use
    .ID_Rb_out (ID_Rb_out )  //load-use
);

//***************************************//




//***************************************//
//ID Unit


Load_UseUnit u_Load_UseUnit(

    .ID_Ra_out  (ID_Ra_out),
    .ID_Rb_out  (ID_Rb_out),
    .Rd_EX      (Rd_EX),
    .MemRead_EX (MemRead_EX),
    .CLoad_Use  (CLoad_Use)

);

IE u_IE(
    .Instr (Instr_ID ),

    .Extop (Extop ),

    .imm   (imm   )
);


ID u_ID(
    //input port
    .Resetn   (Resetn   ),
    .Instr    (Instr_ID    ),

    //ouput port
    .Rd       (Rd       ),

    .Extop    (Extop    ),

    .ALUASrc  (ALUASrc  ),
    .ALUBSrc  (ALUBSrc  ),
    .ALUctr   (ALUctr   ),

    .MemWr    (MemWr    ),
    .Branch   (Branch   ),
    .Jump     (Jump     ),

    .MemtoReg (MemtoReg ),
    .RegWr    (RegWr    ),
    .MemRead  (MemRead  )
);

RegisterFile u_RegisterFile(
    .CLK    (CLK    ),
    .RegWr  (RegWr_WB  ),
    .Resetn (Resetn ),
    .Rw     (Rd_WB     ), //写入地址
    .Di     (Di     ), //写入数据
    .Ra     (ID_Ra_out     ), //读取地址1
    .busA   (busA   ), //读取数据1
    .Rb     (ID_Rb_out     ), //读取地址2
    .busB   (busB   )  //读取数据2
);



//***************************************//






//***************************************//
 //ID_EX pipelineRegisters


Mul_ctr_loadUse u_Mul_ctr_loadUse(
    .MemWr       (MemWr       ),
    .Branch      (Branch      ),
    .Jump        (Jump        ),
    .MemtoReg    (MemtoReg    ),
    .RegWr       (RegWr       ),
    .ALUASrc     (ALUASrc     ),
    .ALUBSrc     (ALUBSrc     ),
    .ALUctr      (ALUctr      ),
    .MemRead     (MemRead     ),

    .CLoad_Use   (CLoad_Use   ),

    .MemWr_ID    (MemWr_ID    ),
    .Branch_ID   (Branch_ID   ),
    .Jump_ID     (Jump_ID     ),
    .MemtoReg_ID (MemtoReg_ID ),
    .RegWr_ID    (RegWr_ID    ),
    .ALUASrc_ID  (ALUASrc_ID  ),
    .ALUBSrc_ID  (ALUBSrc_ID  ),
    .ALUctr_ID   (ALUctr_ID   )
);



ID_EX_register u_ID_EX_register(

     //input port
    .CLK         (CLK         ),
    .Resetn      (Resetn      ),
    .imm         (imm         ),
    .nowPC       (PC_ID       ),
    .rs1_Data    (busA    ),
    .rs2_Data    (busB    ),
    .Rd_Data     (Rd     ),
    .Ra_ID       (ID_Ra_out       ),
    .Rb_ID       (ID_Rb_out       ),
    .MemWr_ID    (MemWr_ID    ),
    .Branch_ID   (Branch_ID   ),
    .Jump_ID     (Jump_ID     ),
    .MemtoReg_ID (MemtoReg_ID ),
    .RegWr_ID    (RegWr_ID    ),
    .ALUASrc_ID  (ALUASrc_ID  ),
    .ALUBSrc_ID  (ALUBSrc_ID  ),
    .ALUctr_ID   (ALUctr_ID   ),
    .MemRead_ID   (MemRead  ),

    //output port
    .Ra_EX       (Ra_EX       ),
    .Rb_EX       (Rb_EX       ),
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
    .ALUctr_EX   (ALUctr_EX   ),
    .MemRead_EX  (MemRead_EX  )
);

//***************************************//




//***************************************//
//EX Unit
/* parameter ADD = 4'b0000;
parameter SUB = 4'b1000;
parameter SLT = 4'b0010;
parameter SLTU = 4'b0011;
parameter OR = 4'b0110;
parameter srcB = 4'b1111;   */




EX_Mul3BusAFw u_EX_Mul3BusAFw(
    //input port
    .BusAFw     (BusAFw     ),
    .busA_EX    (busA_EX    ),
    .Di         (Di         ),
    .ALUout_M   (ALUout_M   ),

    //output port 
    .BusAFw_out (BusAFw_out )
);



EX_Mul3BusBFw u_EX_Mul3BusBFw(

    //input port
    .BusBFw     (BusBFw     ),
    .busB_EX    (busB_EX    ),
    .Di         (Di         ),
    .ALUout_M   (ALUout_M   ),

     //output port 
    .BusBFw_out (BusBFw_out )
);





EX_ALU u_EX_ALU(
    //input port
    .PC      (PC_EX      ),
    .ALUctr  (ALUctr_EX  ),
    .ALUASrc (ALUASrc_EX ),
    .ALUBSrc (ALUBSrc_EX ),
    .busA    (BusAFw_out    ),
    .busB    (BusBFw_out    ),
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
    .CLK         (CLK         ),
    .Resetn      (Resetn      ),
    .busB_EX     (busB_EX     ),
    .ALUout_EX   (ALUout   ),
    .Target_EX   (Target   ),
    .Rd_EX       (Rd_EX       ),
    .Rb_EX       (Rb_EX       ),
    .MemtoReg_EX (MemtoReg_EX ),
    .RegWr_EX    (RegWr_EX    ),
    .Jump_EX     (Jump_EX     ),
    .Branch_EX   (Branch_EX   ),
    .MemWr_EX    (MemWr_EX    ),
    .Zero_EX     (Zero     ),

    //output port
    .MemWr_M     (MemWr_M     ),
    .Branch_M    (Branch_M    ),
    .Jump_M      (Jump_M      ),
    .MemtoReg_M  (MemtoReg_M  ),
    .RegWr_M     (RegWr_M     ),
    .Zero_M      (Zero_M      ),
    .busB_M      (busB_M      ),
    .Target_M    (Target_M    ),
    .Rd_M        (Rd_M        ),
    .Rb_M        (Rb_M        ),
    .ALUout_M    (ALUout_M    )
);
//***************************************//



wire [31:0] Di_M_out;

//***************************************//
//Mem unit

Mul_MemDi u_Mul_MemDi(
    .busB_M   (busB_M   ),
    .Di       (Di       ),
    .DiSrc    (DiSrc    ),
    .Di_M_out (Di_M_out )
);


MemData u_MemData(
    //异步读 同步写
    .CLK    (CLK    ),
    .RA     (ALUout_M     ),
    .WA     (ALUout_M     ),
    .Di     (Di_M_out     ),
    .Resetn (Resetn ),
    .MemWr  (MemWr_M  ),

    .Do     (Do     )
);

ForwardUnit u_ForwardUnit(
    //input port
    .RegWr_M  (RegWr_M  ), 
    .MemWr_M  (MemWr_M  ),
    .Rd_M     (Rd_M     ),

    .Ra_EX    (Ra_EX    ),
    .Rb_EX    (Rb_EX    ),
    .Rb_M     (Rb_M     ),
    .RegWr_WB (RegWr_WB ),
    .Rd_WB    (Rd_WB    ),

    //output port
    .BusAFw   (BusAFw   ),
    .BusBFw   (BusBFw   ),
    .DiSrc    (DiSrc    )
);



//***************************************//



//***************************************//
//MEM_WB pipelineRegisters
M_WB_register u_M_WB_register(
    //input port
    .CLK         (CLK         ),
    .Resetn      (Resetn      ),
    .MemtoReg_M  (MemtoReg_M  ),
    .RegWr_M     (RegWr_M     ),
    .Do_M        (Do        ),
    .Rd_M        (Rd_M        ),
    .ALUout_M    (ALUout_M    ),

    //output port
    .MemtoReg_WB (MemtoReg_WB ),
    .RegWr_WB    (RegWr_WB    ),
    .Do_WB       (Do_WB       ),
    .Rd_WB       (Rd_WB       ),
    .ALUout_WB   (ALUout_WB   )
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

assign out_En = CLoad_Use;
 //output!
assign out_Instr = Instr;
assign out_PC = PC_ID;
assign out_PC_EX = PC_EX;
//control signal
//ID
assign out_Extop = Extop;
assign out_Ra = ID_Ra_out;
assign out_Rb = ID_Rb_out;
//EX
assign out_ALUASrc = ALUASrc_EX;
assign out_ALUBSrc = ALUBSrc_EX;
assign out_ALUctr  = ALUctr_EX;
assign out_ALUout  = ALUout;
assign out_Zero    = Zero;
assign out_Target  = Target;
assign out_imm = imm_EX;
//M
assign out_MemWr = MemWr;
assign out_Branch = Branch;
assign out_Jump = Jump;
//WB
assign out_MemtoReg = MemtoReg;
assign out_RegWr = RegWr;
assign out_Di      = Di;

//id_rs1,rs2
assign out_busA_ex = BusAFw_out;
assign out_busB_ex = BusBFw_out;
assign out_Rd_ex   = Rd;
//m_do







endmodule 