module Load_UseUnit (

    input [4:0] ID_Ra_out,
    input [4:0] ID_Rb_out,
    input [4:0] Rd_EX,
    input MemRead_EX,

    output CLoad_Use //loaduse control
);

assign CLoad_Use = MemRead_EX && ((Rd_EX == ID_Ra_out) || (Rd_EX == ID_Rb_out));
    
endmodule
