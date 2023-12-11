module ID(
    input Resetn,
    input [31:0] Instr,

    output wire [4:0] Rd,

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
    output reg RegWr, //regfile写信号
    output reg MemRead //loaduse检测
);

wire [6:0] opcode = Instr[6:0];
wire [2:0] fun3 = Instr[14:12];

assign Rd = Instr[11:7];



 always @(*) begin
    if(~Resetn) begin//低有效 
        Jump <= 0;
        RegWr <= 0;
        MemWr <= 0;
        MemtoReg <= 0;
        Branch  <= 1'b0;
        ALUASrc <= 0;
        ALUBSrc <= 0;
        ALUctr <= 4'b0000; //不alu计算
        Extop <= 3'b000;
        MemRead <= 0;
    end 
    else begin

        case(opcode)
            //R型指令 add slt sltu
            7'b0110011:begin    
                RegWr <= 1;
                Extop <= 3'b000;
                Jump <= 0;
                RegWr <= 0;
                MemWr <= 0;
                MemtoReg <= 0;
                Branch  <= 1'b0;
                ALUASrc <= 0;
                ALUBSrc <= 0;
                
                MemRead <= 0;
                case (fun3)
                    3'b000:begin
                        ALUctr <= 4'b0000;
                    end 

                    3'b010:begin
                        ALUctr <= 4'b0010;
                    end

                    3'b011:begin
                        ALUctr <= 4'b0011;
                    end

                    default:begin
                        ALUctr <= 4'b0000;
                    end

                endcase
            end

            //I型指令 ori
            7'b0010011:begin
                
                
                Jump <= 0;
                RegWr <= 0;
                MemWr <= 0;
                MemtoReg <= 0;
                Branch  <= 1'b0;
                ALUASrc <= 0;
                
                Extop <= 3'b000;
                MemRead <= 0;
                
                ALUBSrc <= 2'b10;
                RegWr <= 1;
                Extop <= 3'b000;
                ALUctr <= 4'b0110;

            end
            

            //U型指令 lui
            7'b0110111:begin
                
                Extop <= 3'b000;
                Jump <= 0;
                RegWr <= 0;
                MemWr <= 0;
                MemtoReg <= 0;
                Branch  <= 1'b0;
                ALUASrc <= 0;
                MemRead <= 0;
                Extop <= 3'b001;
                ALUBSrc <= 2'b10;
                ALUctr <= 4'b1111;
                RegWr <= 1;
            end

            //I型指令 lw
            7'b0000011:begin
                
                Extop <= 3'b000;
                Jump <= 0;
                RegWr <= 0;
                MemWr <= 0;
                
                Branch  <= 1'b0;
                ALUASrc <= 0;
                
               

                Extop <= 3'b000;
                ALUBSrc <= 2'b10;
                ALUctr <= 4'b0000;
                MemtoReg <= 1;
                RegWr <= 1;
                MemRead <= 1;
            end

            //S型指令 sw
            7'b0100011:begin
                RegWr <= 1;             
                Jump <= 0;
                RegWr <= 0;
                Branch  <= 1'b0;  
                MemRead <= 0;

                Extop <= 3'b010;
                ALUBSrc <= 2'b10;
                ALUASrc <= 4'b0000;
                MemWr <= 1;    
                MemtoReg <= 1'bz;
                ALUctr <= 4'b0000;         
            end


            //B型 beq
            7'b1100011:begin
                RegWr <= 1;

                Jump <= 0;
                RegWr <= 0;
                MemWr <= 0;


                ALUASrc <= 0;
                ALUBSrc <= 0;
                MemRead <= 0;

                Extop <= 3'b011;
                ALUctr <= 4'b1000;
                Branch <= 1;
                MemtoReg <= 1'bz;
            end



            //J型指令 jal
            7'b1101111:begin


                RegWr <= 0;
                MemWr <= 0;
                MemtoReg <= 0;
                Branch  <= 1'b0;

                MemRead <= 0;

                Extop <= 3'b100;
                ALUctr <= 4'b0000;
                RegWr <= 1;
                ALUASrc <= 1;
                ALUBSrc <= 2'b01;
                Jump <= 1;
            end

            default: begin
                RegWr <= 1;
                Extop <= 3'b000;
                Jump <= 0;
                RegWr <= 0;
                MemWr <= 0;
                MemtoReg <= 0;
                Branch  <= 1'b0;
                ALUASrc <= 0;
                ALUBSrc <= 0;
                MemRead <= 0;
                ALUctr <= 4'b0;
            end
                


        endcase
    end
end
 

endmodule 