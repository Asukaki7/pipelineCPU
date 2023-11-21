module ID(
    input Resetn,
    input [31:0] Instr,

    output reg [4:0] Rd,
    output reg [4:0] Ra,
    output reg [4:0] Rb,

    //control signal
    //-ID段-
    output reg [2:0] Extop, //imm拓展信号

    //-EX-段
    output reg ALUASrc,
    output reg [1:0] ALUBSrc,
    output reg [3:0] ALUctr,

    //-M-段
    output reg MemWr,
    output reg Branch, //分支跳转
    output reg Jump, //J型跳转
    
    //-WB-段
    output reg MemtoReg, //wb段写入源
    output reg RegWr //regfile写信号
);

wire [6:0] opcode = Instr[6:0];
wire [2:0] fun3 = Instr[14:12];
wire [6:0] fun7=Instr[31:25];



always @(*) begin
    if(~Resetn) begin//低有效 
        Rd <= 0;
        Ra <= 0;
        Rb <= 0;
        Jump <= opcode[6] & opcode[5] & ~opcode[4] & opcode[3] & opcode[2] & opcode[1] & opcode[0];
        RegWr <= 0;
        MemWr <= 0;
        MemtoReg <= 0;
        Branch  <= 2'b00;
        ALUASrc <= 0;
        ALUBSrc <= 0;
        ALUctr <= 4'b0000; //不alu计算
        Extop <= 3'b000;
    end 
    else begin

        Rd <= Instr[11:7];
        Ra <= Instr[19:15];
        Rb <= Instr[24:20];
        case(opcode)
            //R型指令 add slt sltu
            7'b0110011:begin    
                RegWr = 1;
                case (fun3)
                    3'b000:begin
                        ALUctr <=4'b0000;
                    end 

                    3'b010:begin
                        ALUctr <= 4'b0010;
                    end

                    3'b011:begin
                        ALUctr <= 4'b0011;
                    end

                    default:;
                endcase
            end

            //I型指令 ori
            7'b0010011:begin
                ALUBSrc <= 2'b10;
                RegWr <= 1;
                Extop <= 3'b000;
                ALUctr <= 4'b0110;

            end
            

            //U型指令 lui
            7'b0110111:begin
                Extop <= 3'b001;
                ALUBSrc <= 2'b10;
                ALUctr <= 4'b1111;
                RegWr <= 1;
            end

            //I型指令 lw
            7'b0000011:begin
                Extop <= 3'b000;
                ALUBSrc <= 2'b10;
                ALUctr <= 4'b0000;
                MemtoReg <= 1;
            end

            //S型指令 sw
            7'b0100011:begin
                Extop <= 3'b010;
                ALUBSrc <= 2'b10;
                ALUASrc <= 4'b0000;
                MemWr <= 1;    
                MemtoReg <= 1'bz;         
            end


            //B型 beq
            7'b1100011:begin
                Extop <= 3'b011;
                ALUctr <= 4'b1000;
                Branch <= 1;
                MemtoReg <= 1'bz;
            end



            //J型指令 jal
            7'b1101111:begin
                Extop <= 3'b100;
                ALUctr <= 4'b0000;
                RegWr <= 1;
                ALUASrc <= 1;
                ALUBSrc <= 2'b01;
                Jump <= 1;
            end

            default:;


        endcase
    end
end

endmodule