module Mul_MemDi (
    //input port
    input [31:0] busB_M,
    input [31:0] Di,

    //control port
    input DiSrc,
    //output
    output wire [31:0] Di_M_out //
);


assign Di_M_out = DiSrc ? Di : busB_M;

    
endmodule 