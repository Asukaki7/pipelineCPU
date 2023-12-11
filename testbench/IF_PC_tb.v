module IF_PC_tb();



reg CLK;
reg Resetn;



wire [31:0] nextPc;
wire [31:0] PC_i;
wire [31:0] PC;

Mul_PC u_Mul_PC(
    .Target (32'd50 ),
    .nextPc (nextPc ),
    .Zero   (1'b0   ),
    .Branch (1'b0 ),
    .Jump   (1'b0   ),
    .PC_i   (PC_i   )
);     

PC u_PC(
    .CLK    (CLK    ),
    .PC_i   (PC_i   ),
    .Resetn (Resetn ),
    .En     (1'b0     ),
    .PC     (PC     )
);

pcadder_IF u_pcadder_IF(
    .nowPc  (PC  ),
    .nextPc (nextPc )
);


initial begin
        CLK <= 1'b0;
        Resetn <= 1'b0;
        #10
        Resetn <= 1'b1;
        #1000
        $stop;
    end


always #10 CLK <= ~CLK;


endmodule