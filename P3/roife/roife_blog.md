「BUAA-CO-Lab」 P3
单周期 CPU - 1
用 Logisim 搭建单周期 CPU
Posted by roife on November 15, 2020
课下总结
一定要多做测试

按照课上说的, 将 CPU 分为 NPC, PC, IM, EXT, GRF, ALU, DM 然后依次连起来就好了.

需要注意的有以下几点:

nop 指令: 不需要在 CU 里面特殊处理

移位指令: 需要 shamt, 因此要在 ALU 里面加新的接口

CU: CU 中可以用 Priority Encoder (Decoder 的逆操作) 发出信号

存储指令: 对于半字或者位指令, 因为 DM 是按字存储的, 需要在 DM 的前后都加上组合电路处理读入和输出的数据

跳转指令: 注意 jr 是 r-type 指令, jal 和 j 在跳转上使用相同的位

复位: 注意同步复位和异步复位的区别, 复习 P0

控制信号和 ALUControl 可以多设置几位, 方便课上直接连线

学长的经验: 课上一般是一个跳转+一个计算+一个访存

我课下实现的指令有 addu, subu, and, or, sll, sllv, slt, jr / addi, ori, lui, slti / beq, blez / j, jal / sw, sh / lw, lh, lhu. 基本是把每种类型的都做一个, 课上心里才有底.

课下实现
主要看 Digital Design and Computer Architecture 这本书，按照上面的方法搭建 CPU 即可。

PC
没什么好说的, 就是一个寄存器. 可能要注意一下复位方式 (同步还是异步).

NPC
NPC 注意要和 ALU/CU 配合. beq 需要 ALUzero 这个信号才能使用, 但是实际上比较麻烦 (比如实现小于转移指令, 这里建议或许可以直接用 ALUout 代替, 因为我们的目标是做题, 这样写更方便 (溜)).

P3-lab-npc-0

P3-lab-npc-1

IM
IM 用 ROM 实现, 注意截掉最低两位.

P3-lab-IM

SPLT
为了方便取位而设置的一个元件.

P3-lab-splt

EXT
为了方便, EXT一般需要一个 EXTOp 信号控制扩展方式.

P3-lab-ext

GRF
耐心点排线, 推荐写代码生成元件. 这里是一个例子.

1
2
3
4
5
6
7
for (int i=0; i<=31; ++i) {
    int x = X, y = Y + i * 30;
    printf("<comp lib=\"0\" loc=\"(1540,%d)\" name=\"Tunnel\">\n", y);
    printf("<a name=\"width\" val=\"32\"/>\n");
    printf("<a name=\"label\" val=\"i%d\"/>\n", i);
    printf("</comp>\n");
}
P3-lab-grf-0

P3-lab-grf-1

P3-lab-grf-2

ALU
相对比较好做, 可以先写个支持加减与或的, 然后慢慢扩展.

P3-lab-alu-0

P3-lab-alu-1

DM
使用 RAM, 注意输入要截掉两位地址.

P3-lab-dm

MW/MR
如果你也做了半字/字节的存储指令, 那么一般需要这两个电路对写入数据进行预处理 (MW), 并且处理 DM 输出的数据 (MR).

MR
P3-lab-mr-0

P3-lab-mr-1

MW
P3-lab-mw-0

P3-lab-mw-1

CU
建议用这种模块化的方式做, 更容易加指令.

P3-lab-cu-0

P3-lab-cu-1

P3-lab-cu-2