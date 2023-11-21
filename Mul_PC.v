module Mul_PC(
    input [31:0] Target,
    input [31:0] nextPc,
    input Zero,
    input Branch,
    input Jump,

    output wire [31:0] PC_i

);


assign PC_i = (Jump || (Branch && Zero)) ? Target : nextPc;



endmodule