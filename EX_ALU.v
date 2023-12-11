//运算部件
module EX_ALU(

    input [31:0] PC,
    input wire [3:0] ALUctr,
    input wire ALUASrc,
    input wire [1:0] ALUBSrc,
    input wire [31:0] busA,
    input wire [31:0] busB,
    input wire [31:0] imm,

    output reg [31:0] ALUout,
    output reg [31:0] Target,
    output reg  Zero
);   

parameter ADD = 4'b0000;
parameter SUB = 4'b1000;
parameter SLT = 4'b0010;
parameter SLTU = 4'b0011;
parameter OR = 4'b0110;
parameter srcB = 4'b1111;  //lui


reg [31: 0] Mul_ALUAin;
reg [31: 0] Mul_ALUBin;


wire [31: 0] ALUAin;
wire [31: 0] ALUBin;





initial begin
    ALUout <= 32'h0000_0000;
    Target <= 32'h0000_0000;
end

always @(*) begin
    if(ALUASrc)
        Mul_ALUAin <= PC;
    else
        Mul_ALUAin <= busA;
end



always @(*) begin
    case (ALUBSrc)
        2'b00:begin
            Mul_ALUBin <= busB;
        end 
        2'b01:begin
            Mul_ALUBin <= 32'h0000_0004;
        end 
        2'b10:begin
            Mul_ALUBin <= imm;
        end
        default:;
    endcase
end


assign ALUAin = Mul_ALUAin;
assign ALUBin = Mul_ALUBin;

always @(*) begin
    Target <= imm +PC;
    case (ALUctr)
        ADD:begin//求和
            ALUout <= ALUAin + ALUBin;
        end 
        
        OR:begin //或
            ALUout <= ALUAin | ALUBin;
        end

        SLT:begin//slt
            if(ALUAin<ALUBin)
                ALUout <=  32'h0000_0001;
            else ALUout <= 0;
        end

        SLTU:begin //sltu
            if(ALUAin<ALUBin)
                ALUout <= 32'h0000_0001;
            else ALUout <= 0;
        end

        SUB:begin //sub
            ALUout <= ALUAin - ALUBin;
        end

        srcB:begin //lui
            ALUout <= ALUBin;
        end

        default:;
        
    endcase
    if(ALUout==0)
            Zero <= 1;
        else Zero <= 0;
end
        
endmodule 