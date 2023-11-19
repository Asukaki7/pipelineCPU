module Mul_PC(
    input Target,
    input nextpc,
    input Zero,
    input Branch,
    input Jump,

    output wire [31:0] PC_i

);


assign PC_i = (Jump || (Branch && Zero)) ? Target : nextpc;



endmodule