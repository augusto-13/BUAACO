## `6.` 时序逻辑相关

###  `always` 块
* 若 `always` 之后紧跟 `@(...)`, 表示当括号中的条件满足时，将会执行 `always`, 用于时序逻辑 (`posedge` 表示上升沿, `negedge` 表示下降沿, 默认为都敏感, 多个条件用 `,` 或 `or` 隔开, 当一个触发时就执行)

* 若 `always` 之后紧跟 `@*` 或`@(*)`, 表示当紧跟语句中信号变化时，将会执行 `always`, 一般与 `reg` 型和阻塞赋值配合使用, 用于组合逻辑
* 若 `always` 之后紧跟语句, 表示当反复执行, 一般用来产生周期信号

``` js 
always @(posedge clk) // clk 到达上升沿触发
always @(a)

always @(*)

always #10
```
* 两个 always 语句如果同时触发就会产生竞争, 触发的先后顺序不确定.

* 并且多个 always 语句间是并行执行的.

### `initial` 块 
* `initial` 一般用来初始化 `reg` 型, 是* 不可综合 *的!

``` js
initial begin
    mem = 0;
end
```
### 基本语句 -- 循环
#### `repeat`

* 格式为 `repeat(constant_num)`, 括号内为常量表达式, 用来重复数次操作.
``` js
parameter size = 8;
repeat(size) begin

end
```
#### `for`
* 一般会定义一个 `integer` 作为循环变量.
``` js
for (i=0; i<7; i=i+1) begin
end
```
#### `while`
``` js
while () begin

end
```
### 时间控制

#### `#时间` 
* 表示延时一段时间, 可以用来产生时间信号.
``` js
always #5 clk = ~clk; // 产生周期为 10 的时钟信号
assign #5 b = a;      // 延时 5 个时间单位后赋给 b
#5 b = a;             // 延迟 5 个时间单位后执行赋值语句
```
#### `@(时序条件)` 
* 表示等待时序条件 (如 posedge 等) 满足.

##块语句

#### `begin…end`
* `begin...end` 块用来表示顺序执行的语句, 其中每条语句的延迟时间表示针对于上一条语句的延迟, 执行完所有语句后跳出块.
``` js
begin
    areg = breg;
    #10 creg = areg; // 上一个语句执行完 10 个单位时间后执行
end
```
#### `fork…join`
* `fork...join` 块用来表示并行执行的语句, 其中每条语句的延迟时间表示针对进入块的时间, 执行完所有语句或者遇到 `disable` 后跳出块.
* 因此在 `fork...join` 中, 语句先后顺序无所谓.
``` js
fork
    # 50 r = 'h35;
    # 100 r = 'hE2; // 上一条语句执行完 50 个单位时间后执行
join
```
### 命名块与 `disable`
* 可以给块命名, 并且用 `disable` 跳出对应的块 (类似于 `break`).
``` js
begin : block1
    // ...
    disable block1;
end
```
### `generate`/`generate-for`/`generate-if`
* `generate..endgenerate` 可以用来生成一些重复的语句.
``` js
genvar i; // 可以定义到 generate 语句里面
generate
    for(i=0;i<SIZE;i=i+1)
        begin:bit
            assign bin[i]=^gray[SIZE-1:i];
        end
endgenerate
// 等同于
assign bin[0]=^gray[SIZE-1:0];
// ...
assign bin[7]=^gray[SIZE-1:7];
```

* `generate-for` 必须用 `genvar` 定义的变量作为循环变量, 必须用 `begin...end` 包裹语句且定义命名块.

* 命名块的名字可以用来对 `generate-for` 语句中的变量进行层次化引用.

``` js
generate
       genvar i;
       for(i=0;i<SIZE;i=i+1)
       begin:shifter
              always@(posedge clk)
                     shifter[i]<=(i==0)?din:shifter[i-1];
       end
endgenerate

// 等价于
always@(posedge clk)
       shifter[0]<=din;
always@(posedge clk)
       shifter[1]<=shifter[0];
// ...
```

* `generate-if` 和 `generate-for` 类似, 注意判断条件必须是常量.
``` js
generate
   if(KSiZE == 3)
      begin: MAP16
       //针对尺寸为3的算法进行处理
     end
```
* `generate-case`
``` js
generate
     case (WIDE)
        9:
                  assign  d   =  a | b | c;
        12:       assgin  d   =  a & b & c;
        default:  assgin  d   =  a & b | c;
     endcase
endgenerate
```
### 寄存器
* 可复位的寄存器分为 *同步复位寄存器* 和 *异步复位寄存器* .
``` js
module flopr(input clk
             input reset,
             input [3:0] d,
             output [3:0] q);
    // asynchronous reset
    always @(posedge clk, posedge reset)
        if (reset) q<= 4'b0;
        else q <= d;
endmodule
```
``` js
module flopr(input clk
             input reset,
             input [3:0] d,
             output [3:0] q);
    // synchronous reset
    always @(posedge clk)
        if (reset) q<= 4'b0;
        else q <= d;
endmodule
```
``` js
// 使能复位寄存器
module flopr(input clk
             input reset,
             input en,
             input [3:0] d,
             output [3:0] q);
    // synchronous reset
    always @(posedge clk)
        if (reset) q<= 4'b0;
        else if(en) q <= d;
endmodule
```