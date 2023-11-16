//指令译码 Instr decode
module ID(
    input Resetn, //低有效reset
    input [31:0] Instr,

    output reg [4:0]  Rd, //writeAddress
    output reg [4:0]  rs1,//rs1,rs2 readaddress
    output reg [4:0]  rs2,
    


    //部件控制信号
    output reg [1:0] branch, //分支ctr
    output reg jump,//pc跳转指令
    output reg RegWr,//寄存器写
    output reg MemWr,//内存写
    

    //多路选择控制信号
    output reg mrs1andpc_ctr, //选择rs还是pc->ALU,0-rs1 | 1->pc
    output reg mrs1andpc_ctr2, //同上-> pc
    output reg [2:0] maluandmem_ctr,//选择alu的输出还是储存器Mem的输出到reg
    output reg [1:0] mrs2andie_ctr,  //选择rs2，imm，4到ALU，ALUBSrc
    output reg [1:0] mrs2_ctr, //控制rs2的值到reg




    output reg [2:0] Extop, //imm拓展信号
    output reg [5:0]  ALUctr//六位ALU控制信号
    
   

);


wire [6:0] opcode=Instr[6:0];
wire [2:0] fun3=Instr[14:12];
wire [6:0] fun7=Instr[31:25];

always @(*) begin

     /* 初始化 */
        jump<=(opcode[6] & opcode[5] & ~opcode[4] & opcode[3] & opcode[2] & opcode[1] & opcode[0]) //1101111 jal
               | (opcode[6] & opcode[5] & ~opcode[4] & ~opcode[3] & opcode[2] & opcode[1] & opcode[0]);  //1100111 jalr Jump and Link Register  I型指令
        Rd<=Instr[11:7];
        rs1<=Instr[19:15];
        rs2<=Instr[24:20];
        RegWr=0;
        MemWr=0;
        branch=2'b00;//不译码
        ALUctr<=6'b011000; //不alu计算
        mrs1andpc_ctr<=0;
        mrs1andpc_ctr2<=0;
        mrs2andie_ctr<=2'b00;
        mrs2_ctr<=2'b00;
        maluandmem_ctr<=3'b000;
        Extop<=3'b000;
    if(~Resetn) begin
        Rd<=0;
        rs1<=0;
        rs2<=0;
    end //低有效 

    else begin
       
        case (opcode)
            7'b0110011: begin //R型指令
                mrs1andpc_ctr<=0;
                mrs1andpc_ctr2<=0;
                mrs2andie_ctr<=2'b00;
                maluandmem_ctr<=3'b000;
                RegWr=1;
                case (fun7)
                    7'b0000000:begin
                        case (fun3)
                            3'b000:begin
                                ALUctr<=6'b000000; //add 
                            end 
                            3'b111:begin
                                ALUctr<=6'b000001; //and
                            end
                            3'b110:begin
                                ALUctr<=6'b000010; //or
                            end
                            3'b100:begin
                                ALUctr<=6'b000011; //xor
                            end
                            3'b101:begin
                                ALUctr<=6'b000100; //srl  shift right logical
                            end
                            3'b001:begin
                                ALUctr<=6'b000101; //sll  shift left logical
                            end
                            3'b010:begin
                                ALUctr<=6'b000110; //slt  set less than 
                            end
                            3'b011:begin
                                ALUctr<=6'b000111; //sltu  set less than u
                            end
                        endcase    
                    end 

                    7'b0000001:begin
                        case (fun3)
                            3'b100:begin
                                ALUctr<=6'b001000;//div
                            end 

                            3'b101:begin
                                ALUctr<=6'b001001; //div unsigned
                            end
                            
                            3'b000:begin
                                ALUctr<=6'b001010; //mul
                            end

                            3'b001:begin
                                ALUctr<=6'b001011; //mulh multi high 
                            end 

                            3'b010:begin
                                ALUctr<=6'b001100; //mulhsu Multiply High Signed-Unsigned
                            end

                            3'b011:begin
                                ALUctr<=6'b001101; //mulhu
                            end

                            3'b110:begin
                                ALUctr<=6'b001110; //rem 取余数
                            end

                            3'b111:begin
                                ALUctr<=6'b001111; //remu
                            end
                        endcase
                    end


                    7'b0100000:begin//R型
                        case (fun3)
                            3'b101:begin
                                ALUctr<=6'b010000; //sra shiift righ arith
                            end 

                            3'b000:begin
                                ALUctr<=6'b010001; //sub
                            end
                             
                        endcase
                    end 
                endcase
            end 

            7'b0010011:begin //I型指令
                //imm expend
                //extop赋值 Instru      
                mrs1andpc_ctr<=0;
                mrs1andpc_ctr2<=0;
                mrs2andie_ctr<=0;
                maluandmem_ctr<=3'b000;
                case (fun3)
                     3'b000:begin
                        Extop<=3'b000;
                        ALUctr<=6'b000000; //addi  add imme
                     end 

                     3'b111:begin
                        Extop<=3'b000;
                        ALUctr<=6'b000001;  //andi And immediate
                     end

                     3'b110:begin
                        Extop<=3'b000;
                        ALUctr<=6'b000010; //ori   Or immediate
                     end

                     3'b001:begin
                        case (fun7)
                            7'b0000000:begin
                                Extop<=3'b101;
                                ALUctr<=6'b010010; //slli shift left logical imm
                            end      
                        endcase
    
                     end
                     3'b010:begin
                        Extop<=3'b000;
                        ALUctr<=6'b010011; //slti  set less than imm
                     end

                     3'b011:begin
                        Extop<=3'b110;
                        ALUctr<=6'b010011; //sltiu set less than imm u
                     end

                     3'b101:begin
                        case (fun7)
                            7'b0100000:begin
                                Extop<=3'b101;
                                ALUctr<=6'b010100; //srai      shift right arith imm                                
                            end 
                        endcase
                     end

                     3'b100:begin
                        Extop<=3'b000;
                        ALUctr<=6'b000011;
                     end    
                endcase
            end

             //I型指令
            7'b0000011:begin
                mrs1andpc_ctr<=0; //选择rs1
                mrs2andie_ctr<=2'b10;//选择 立即数
                RegWr=1'b1;

                case (fun3)
                    3'b000:begin  //取八位，符号拓展 byte
                        Extop<=3'b000;
                        ALUctr<=6'b000000; 
                        maluandmem_ctr<=3'b010; //lb load byte
                    end  

                    3'b100:begin //取八位，零拓展 byte
                        Extop<=3'b000;
                        ALUctr<=6'b000000;
                        maluandmem_ctr<=3'b100; //lbu 
                    end

                    3'b001:begin //取十六位 符号拓展
                        Extop<=3'b000;
                        ALUctr<=6'b000000;
                        maluandmem_ctr<=3'b011; //lh loadhalf
                    end

                    3'b101:begin //取十六位，零拓展
                        Extop<=3'b000;
                        ALUctr<=6'b000000;
                        maluandmem_ctr<=3'b101; //lhu 
                    end

                    3'b010:begin //取字 32位
                        Extop<=3'b000;
                        ALUctr<=6'b000000;
                        maluandmem_ctr<=3'b001; //lw load word
                    end

                    3'b110: begin //无符号取字?
                        Extop <= 3'b000;
                        ALUctr <= 6'b000000;
                        maluandmem_ctr<= 3'b001;                         
                    end
                endcase               
            end


            7'b0100011:begin    //S型指令
                mrs1andpc_ctr<=0;
                mrs2andie_ctr<=2'b10;
                maluandmem_ctr<=3'b000;
                mrs1andpc_ctr2<=0;
                MemWr=1;
                Extop<=3'b010;
                case (fun3)
                    3'b010: begin
                        ALUctr<=6'b000000;
                        mrs2_ctr<=2'b00; //sw  store word
                    end
                    
                    3'b000:begin
                        ALUctr<=6'b000000;
                        mrs2_ctr<=2'b10; //sb store byte  
                    end

                    3'b001:begin
                        ALUctr<=6'b000000; 
                        mrs2_ctr<=2'b11; //sh store half
                    end
                endcase
            end


            7'b1100011:begin    //B型指令
                ALUctr<=6'b010001; //sub通过减两个寄存器的值来判断
                Extop<=3'b011;
                mrs2andie_ctr<=2'b00;
                case (fun3)
                    3'b000:begin
                        branch=2'b01; //beq branch equal 
                    end 

                    3'b101:begin
                        branch=2'b11;
                        ALUctr<=6'b010101; //bge branch >=
                    end
                    
                    3'b111:begin
                        branch=2'b11;
                        ALUctr<=6'b010101; //bgeu:if (rs1 ≥urs2) pc += sext(offset)
                    end

                    3'b100:begin
                        ALUctr<=6'b010110;
                        branch=2'b11; //blt if(rs1<rs2) pc+=sext(offset)
                        
                    end

                    3'b110:begin
                        ALUctr<=6'b010110;
                        branch=2'b11; //bltu  branch<(u)
                    end

                    3'b001:begin
                        branch=2'b10; //bne  branch !=
                    end
                endcase
            end



            7'b1101111:begin //J型指令-jal  jump and link x[rd]=pc+4 ;pc+=sext(offset)
                Extop<=3'b100; //送到pc-adder
                mrs2andie_ctr<=2'b01; //送到alu的两个信号pc和4
                mrs1andpc_ctr<=1;//选pc
            end


            7'b1100111:begin//jalr I型 jump and link reg    t=pc+4 ;pc+=(x[rs1]+sext(offset))&-1;x[rd]=t
                case (fun3)
                    3'b010:begin
                        Extop<=3'b000;
                        mrs1andpc_ctr<=1;
                        mrs2andie_ctr<=2'b01;
                        mrs1andpc_ctr2<=1;
                    end 
                endcase
            end

            7'b0110111:begin    //U型指令 lui load upper imm
                Extop<=3'b001;
                ALUctr<=6'b010111; //rd=rs2
                mrs2andie_ctr<=2'b10;
                RegWr=1'b1;     
            end

            7'b0010111:begin //U型 //auipc  add upper imm to pc x[rd] = pc +sext(imm[31:12]<<12)
                Extop<=3'b001;
                ALUctr<=6'b000000;
                mrs1andpc_ctr<=1;
                mrs2andie_ctr<=2'b10; 
            end

        endcase
    end 

end

endmodule 