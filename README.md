# BUAA-CO-2021

2021年秋季北航计算机组成原理课程设计源码 by augusto-13

## introduction

北航的计组课程目标是开发支持`MIPS`指令集的CPU，在这个过程中学习数字电路，汇编语言，计算机软硬件组成等基础知识。

## Code

### Pre 基础知识学习

主要是`logisim`，`verilog`，`MIPS`以及相关工具（`ISE，Mars`等）的基本使用，为之后的各个Project打基础

### P0 logisim搭建基本电路

利用logisim搭建一些小的元件和状态机，难点主要在状态机搭建，要区分好`Moore`和`Mealy`

### P1 verilog搭建基本电路

P1和P0内容差不多，只是工具变了，主要就是用verilog搭建小元件和状态机。

### P2 MIPS汇编语言

基本就是用MIPS写一些基本的简单算法题，如果有类似快排，二分查找这样的复杂一些的算法题会给参考的C源代码。

### P3 logisim单周期CPU开发(8条指令)

课下:利用logisim搭建一个支持`{addu, subu, ori, lw, sw, beq, lui, nop}`指令集的单周期CPU

课上:扩展给定的指令

### P4 Verilog单周期CPU开发(10条指令)

课下:利用Verilog搭建一个支持`{addu, subu, ori, lw, sw, beq, lui, jr,nop,jal}`指令集的单周期CPU

课上:扩展给定的指令

### P5 Verilog简单流水线CPU开发(11条指令)

课下:利用Verilog搭建一个支持`{ addu, subu, ori, lw, sw, beq, lui, j, jal, jr, nop }`指令集的流水线CPU

课上:扩展给定的指令

### P6 Verilog复杂流水线CPU开发(51条指令)

课下:利用Verilog搭建一个支持`{LB、LBU、LH、LHU、LW、SB、SH、SW、ADD、ADDU、SUB、 SUBU、 MULT、 MULTU、 DIV、 DIVU、 SLL、 SRL、 SRA、SLLV、SRLV、SRAV、AND、OR、XOR、NOR、ADDI、ADDIU、ANDI、ORI、XORI、LUI、SLT、SLTI、SLTIU、SLTU、BEQ、BNE、BLEZ、BGTZ、BLTZ、BGEZ、J、JAL、JALR、JR、MFHI、MFLO、MTHI、MTLO}`指令集的流水线CPU

课上:扩展给定的指令
