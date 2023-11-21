module RiscVCPU_top(
    input CLK,
    input Resetn, //


    output wire [31:0] out_Instr,
    output wire [31:0] out_PC,
    //ID
    output wire [31:0] out_Extop,
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
    output wire [31:0] out_Di
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
    .Instr    (Instr_ID    ),

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





wire [5:0] Ra_EX,Rb_EX;
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
    .Ra_ID       (Ra       ),
    .Rb_ID       (Rb       ),
    .MemWr_ID     (MemWr     ),
    .Branch_ID    (Branch    ),
    .Jump_ID      (Jump      ),
    .MemtoReg_ID  (MemtoReg  ),
    .RegWr_ID     (RegWr     ),
    .ALUASrc_ID   (ALUASrc   ),
    .ALUBSrc_ID   (ALUBSrc   ),
    .ALUctr_ID    (ALUctr    ),

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
    .ALUctr_EX   (ALUctr_EX   )
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
wire [31:0] BusAFW_out, BusBFW_out;

EX_Mul3BusAFW u_EX_Mul3BusAFW(
    .busA_EX    (busA_EX    ),
    .Di         (Di         ),
    .ALUout_M   (ALUout_M   ),
    
    .BusAFW     (BusAFW     ),
    
    .BusAFW_out (BusAFW_out )
);


EX_Mul3BusBFW u_EX_Mul3BusBFW(
    .busB_EX    (busB_EX    ),
    .Di         (Di         ),
    .ALUout_M   (ALUout_M   ),
    
    .BusBFW     (BusBFW     ),
    
    .BusBFW_out (BusBFW_out )
);





EX_ALU u_EX_ALU(
    //input port
    .PC      (PC_EX      ),
    .ALUctr  (ALUctr_EX  ),
    .ALUASrc (ALUASrc_EX ),
    .ALUBSrc (ALUBSrc_EX ),
    .busA    (BusAFW_out    ),
    .busB    (BusBFW_out    ),
    .imm     (imm_EX     ),

    //output port
    .ALUout  (ALUout  ),
    .Target  (Target  ),
    .Zero    (Zero    )
);
//***************************************//




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
    .Branch_i   (Branch_EX   ),
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
wire [1:0] BusAFw,BusBFw;
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


 //output!
assign out_Instr = Instr;
assign out_PC = PC_ID;
//control signal
//ID
assign out_Extop = Extop;
//EX
assign out_ALUASrc = ALUASrc;
assign out_ALUBSrc = ALUBSrc;
assign out_ALUctr  = ALUctr;
assign out_ALUout  = ALUout;
assign out_Zero    = Zero;
assign out_Target  = Target;
//M
assign out_MemWr = MemWr;
assign out_Branch = Branch;
assign out_Jump = Jump;
//WB
assign out_MemtoReg = MemtoReg;
assign out_RegWr = RegWr;
assign out_Di      = Di;

//id_rs1,rs2
assign out_busA_ex = busA_EX;
assign out_busB_ex = busB_EX;
assign out_Rd_ex   = Rd_EX;
//m_do






endmodule