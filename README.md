# pipelineCPU based on RISC-V

### NEU IOT Computer organization and design

implement 10 instructions:

* add     
`add rd ra rb`  **R[rd] = R[ra] + R[rb];**
* ori      
`ori R[rd] rs1,imm12 `  **R[rd] = R[rs1] + SEXT(imm12)**
* sub
`same as add`
* slt
`slt rd rs1 rs2` **R[rd] = R[rs1] < R[rs2] ? 1 : 0;**
* sltu
`sltu rd rs1 rs2` **R[rd] = R[rs1] < R[rs2] ? 1 : 0;**
* beq
`beq rs1 rs2 imm12` 
**Cond <- R[rs1] - R[rs2] 
if (Cond eq)   pc = pc + (SEXT(imm12) <<1)** 
* jal
`jal rd imm20` 
**R[rd] = pc +4
pc = pc + (SEXT(imm20)<<1)**
* lui
`lui rd imm20`
**R[rd] = imm20 || 000H**
* lw
`lw rd rs1 imm12`
**Addr = R[rs1] + SEXT(imm12)
R[rd] = M[Addr]**
* sw
`sw rs1 rs2 imm12`
**Addr = R[rs1] + SEXT(imm12)
R[rd] = M[Addr]**

