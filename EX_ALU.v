module EX_ALU(

    input PC,
    input wire [3:0] ALUctr,
    input wire ALUASrc,
    input wire [1:0] ALUBSrc,
    input wire [31:0] busA,
    input wire [31:0] busB,
    input wire [31:0] imm,

    output reg [31:0] ALUout,
    output reg  Zero
);   

reg [31: 0] Mul_ALUAin;
reg [31: 0] Mul_ALUBin;

wire [31: 0] ALUAin;
wire [31: 0] ALUBin;
wire [31: 0] Target;
assign Target = PC + imm;

always @(*) begin
    if(ALUASrc)
        Mul_ALUAin <= PC;
    else
        Mul_ALUAin <= busA;
end

always @(*) begin
    case (ALUBSrc)
        2'b0:begin
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

always @(ALUctr) begin
    ALUout <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;
    case (ALUctr)
        4'b0000:begin//求和
            ALUout <= ALUAin + ALUBin;
        end 
        
        4'b0110:begin //或
            ALUout <= ALUAin | ALUBin;

        end

        4'b0010:begin//slt
            if(ALUAin<ALUBin)
                ALUout <=  32'h0000_0001;
            else ALUout <= 0;
        end

        4'b0011:begin //sltu
            if(ALUAin<ALUBin)
                ALUout <= 32'h0000_0001;
            else ALUout <= 0;
        end

        4'b1000:begin //sub
            ALUout <= ALUAin - ALUBin;
        end
       
    endcase
    if(ALUout==0)
            Zero <= 1;
        else Zero <= 0;
end
        
endmodule 