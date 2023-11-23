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
 

    /* wire [2:0] func;

    assign opcode = Instr[6:0];
    assign func = Instr[14:12];

    // reg [2:0] Extop_data;
    // assign Extop = Extop_data;

    //Resetn
    

    //ID
    always @(*) begin
        if(~Resetn) begin
            Extop = 3'd0;
            MemRead = 1'd0;
        end
        else begin
        case(opcode)
            //R
            7'b0110011: begin
                Extop = 3'd5;
                MemRead = 1'd0;
            end
            //I--ori
            7'b0010011: begin
                Extop = 3'd0;
                MemRead = 1'd0;
            end
            //I--lw
            7'b0000011: begin
                Extop = 3'd0;
                MemRead = 1'd1;
            end
            //U
            7'b0110111: begin
                Extop = 3'd1;
                MemRead = 1'd0;
            end
            //S
            7'b0100011: begin
                Extop = 3'd2;
                MemRead = 1'd0;
            end
            //B
            7'b1100011: begin
                Extop = 3'd3;
                MemRead = 1'd0;
            end
            //J
            7'b1101111: begin
                Extop = 3'd4;
                MemRead = 1'd0;
            end
            default: begin
                Extop = 3'd5;
                MemRead = 1'd0;
            end
        endcase
        end
    end

    //EX
    always @(*) begin
        if(~Resetn) begin
            ALUASrc = 1'd0;
            ALUBSrc = 2'd0;
            ALUctr = 4'd0;
        end
        else begin
        case(opcode)
            //R
            7'b0110011: begin
                ALUASrc = 1'd0;
                ALUBSrc = 2'd0;
                case(func)
                    //add/sub
                    3'b000: begin
                        ALUctr = (Instr[30]) ? 4'd4 : 4'd0;  //sub/add
                    end
                    //slt
                    3'b010: begin
                        ALUctr = 4'd2;  //slt
                    end
                    //sltu
                    3'b011: begin
                        ALUctr = 4'd2;  //sltu
                    end
                    //or
                    3'b110: begin
                        ALUctr = 4'd1;  //or
                    end
                    //and
                    3'b111: begin
                        ALUctr = 4'd5;  //and
                    end
                    //xor
                    3'b100: begin
                        ALUctr = 4'd3;  //xor
                    end
                    //srl
                    3'b101: begin
                        ALUctr = 4'd6;  //srl
                    end
                endcase
            end
            //I--ori
            7'b0010011: begin
                ALUASrc = 1'd0;
                ALUBSrc = 2'd2;
                ALUctr  = 4'd1;      //or
            end
            //I--lw
            7'b0000011: begin
                ALUASrc = 1'd0;
                ALUBSrc = 2'd2;
                ALUctr  = 4'd0;      //add
            end
            //U
            7'b0110111: begin
                ALUASrc = 1'd0;      //x
                ALUBSrc = 2'd2;
                ALUctr  = 4'd7;      //lui <<12
            end
            //S
            7'b0100011: begin
                ALUASrc = 1'd0;
                ALUBSrc = 2'd2;
                ALUctr  = 4'd0;      //add
            end
            //B
            7'b1100011: begin
                ALUASrc = 1'd0;
                ALUBSrc = 2'd0;
                ALUctr  = 4'd4;      //sub
            end
            //J
            7'b1101111: begin
                ALUASrc = 1'd1;
                // ALUBSrc = 2'd2;             ////////和书上不一样？
                ALUBSrc = 2'd1;             ////////和书上不一样？
                ALUctr  = 4'd0;      //add
            end
            default: begin
                ALUASrc = 1'd0;
                ALUBSrc = 2'd0;
                ALUctr  = 4'd0;      //or
            end
        endcase
        end
    end

    //M
    always @(*) begin
        if(~Resetn) begin
            MemWr = 1'd0;
            Branch = 1'd0;
            Jump = 1'd0;
        end
        else begin
        case(opcode)
            //R
            7'b0110011: begin
                MemWr = 1'd0;
                Branch = 1'd0;
                Jump = 1'd0;
            end
            //I--ori
            7'b0010011: begin
                MemWr = 1'd0;
                Branch = 1'd0;
                Jump = 1'd0;
            end
            //I--lw
            7'b0000011: begin
                MemWr = 1'd0;
                Branch = 1'd0;
                Jump = 1'd0;
            end
            //U
            7'b0110111: begin
                MemWr = 1'd0;
                Branch = 1'd0;
                Jump = 1'd0;
            end
            //S
            7'b0100011: begin
                MemWr = 1'd1;
                Branch = 1'd0;
                Jump = 1'd0;
            end
            //B
            7'b1100011: begin
                MemWr = 1'd0;
                Branch = 1'd1;
                Jump = 1'd0;
            end
            //J
            7'b1101111: begin
                MemWr = 1'd0;
                Branch = 1'd0;
                Jump = 1'd1;
            end
            default: begin
                MemWr = 1'd0;
                Branch = 1'd0;
                Jump = 1'd0;
            end
        endcase
        end
    end

    //WB
    always @(*) begin
        if(~Resetn) begin
            MemtoReg = 1'd0;
            RegWr = 1'd0;
        end
        else begin
        case(opcode)
            //R
            7'b0110011: begin
                MemtoReg = 1'd0;
                RegWr = 1'd1;
            end
            //I--ori
            7'b0010011: begin
                MemtoReg = 1'd0;
                RegWr = 1'd1;
            end
            //I--lw
            7'b0000011: begin
                MemtoReg = 1'd1;
                RegWr = 1'd1;
            end
            //U
            7'b0110111: begin
                MemtoReg = 1'd0;
                RegWr = 1'd1;
            end
            //S
            7'b0100011: begin
                MemtoReg = 1'd0;        //x
                RegWr = 1'd0;
            end
            //B
            7'b1100011: begin
                MemtoReg = 1'd0;        //x
                RegWr = 1'd0;
            end
            //J
            7'b1101111: begin
                MemtoReg = 1'd0;
                RegWr = 1'd1;
            end
            default: begin
                MemtoReg = 1'd0;        //x
                RegWr = 1'd0;           //x
            end
        endcase
        end
    end */

endmodule 