//拓展器 Instr expend
module IE(
    input wire [31:0] Instr,//输入指令
    input wire [2:0] Extop,
    output reg [31:0] imm
    );
    
always @(*) begin
    imm<=32'b0000_0000_0000_0000_0000_0000_0000_0000;
    case (Extop)
        3'b000:begin//I型指令 ori  lw immI
            imm<={{20{Instr[31]}},Instr[31:20]};
        end 

        3'b001:begin//U型指令 lui immU
            imm<={Instr[31:12],12'b0};
        end
        
        3'b010:begin //S型指令 sw immS
            imm<={{20{Instr[31]}},Instr[31:25],Instr[11:7]};
        end

        3'b011:begin //B 型指令 beq 
            imm<={{20{Instr[31]}},Instr[7],Instr[30:25],Instr[11:8],1'b0};
        end
        
        3'b100:begin//J型指令 jal immJ sext(20)
            imm<={{12{Instr[31]}},Instr[19:12],Instr[20],Instr[30:21],1'b0};    
        end
        
        default:begin
        end

    endcase
end
endmodule 

//0000000  00001  00000 000 00010 011 0011