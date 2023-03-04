# `MIPS` 上机前注意事项
## `1.` 注释写再多也不为过
## `2.` 常用语句：
``` js
jal                         # factorial
j
jr      $ra

sw      $t1, 100($t2)       #save word
lw      $t1, 100($t2)       #load word
li      $t1, 0x00000001     #load immediate
la      $a0, space          #load address (usually label)

move    $s0, $v0

mflo    $v0         # $hi ->  higher_16bit_of_product/remainder
mfhi    $v0         # $lo ->  lower_16bit_of_product/quotient

li      $v0, 5      # 读入integer
syscall

move    $a0, $t0    # 输出$a0    
li      $v0, 1
syscall

li      $v0, 10     # 结束程序
syscall

la      $a0, str_space  # 输出字符串 
li      $v0, 4
syscall    
```
## `3.`
$t0 ~ $t9: 调用者保存
$s0 ~ $s7: 被调用者保存 

## `4.`
``` js
lui     $t1, imm    
# imm(0 ~ 65535), imm 输入-1编译器会报错
```
``` js
ori     $t2, $t1, imm
# imm -- zero-extended 16-bit immediate (unsigned)
# pseudoinstruction -- 32-bit immediate (signed or unsigned doesn't matter)
```
``` js
# the same:
# ori  		$t1, 42949672955
# ori  		$t1, -5 
```
## `5.` *失忆* -> *严重失忆*
+   从头开始：
    + `bit` 
    + `byte`        8_bit
    + #16进制表示为*2位*，也可用*1个字符*表示
    + `word`        32_bit  4_byte  <32-64>
    + `halfword`    16_bit  2_byte  <32-64>

地址一个单位存储一个字节(`byte`)，即 `8` 位

若要创建一个 $8 * 8$ 数组存储 $32$ 位的 `imm`，
则需要申请 $8 * 8 * 4$ 个字节 ( `Byte` ) 的空间
``` js
# 0x0000(16'd0)  -> a[0][0]
# 0x0004(16'd4)  -> a[0][1]
# 0x0010(16'd16) -> a[0][4]
# 0x0020(16'd32) -> a[1][0]
```



* 
``` js
.macro  getindex(%ans, %i, %j)
    sll %ans, %i, 3             # %ans = %i * 8
    add %ans, %ans, %j          # %ans = %ans + %j
    sll %ans, %ans, 2           # %ans = %ans * 4
.end_macro
```
**无分号；注释"#"；"sll" '3' 个操作数**

* 常用syscall 条件反射


* in_end 后写什么？
in_i_end:
li	$t0, 0

* 
``` js
in_i_end:
li	$t0, 0

in/out_j/k/l_end:
addi    $t0/$t1/$t2, $t0/$t1/$t2, 1
j       in/out_i/j/k

in/out_i:
beq     $s0, $t0, in/out_i_end
li      $t1, 0
```

* 递归
``` js
main:
    li      $v0, 5
    syscall
    move    $s0, $v0        # input is stored in $v0, $v0 -> $s0
    move    $a0, $s0        # $s0 -> $a0      $a0, $a1  (argument, 传递参数)
    jal     factorial       # go to factorial, $ra = PC + 4 (8)

    move    $a0, $v0        # end
    li      $v0, 1
    syscall
    li      $v0, 10
    syscall

factorial:
    bne     $a0, 1, work    # if( $a0 != 1 ) work; 
    li      $v0, 1          # (factorial(1) = 1)    $v0 = 1
    jr		$ra				# 31, 

work:
    move    $t0, $a0        # $a0 -> $t0

    sw		$ra, 0($sp)		# store $ra     1st: 8; 31
    subi	$sp, $sp, 4			
    sw		$t0, 0($sp)		# store $t0     1st: input; input-1; 
    subi	$sp, $sp, 4			

    subi    $t1, $t0, 1     # n - 1         
    move    $a0, $t1        # $a0 -> $t0 - 1
    jal     factorial       # go to factorial, $ra = (31)

    addi    $sp, $sp, 4     
    lw		$t0, 0($sp)	    # load $t0	    input-1; input
    addi    $sp, $sp, 4     
    lw      $ra, 0($sp)     # load $ra      31; 8

    mult	$t0, $v0	    # 1 * 2 * 3
    mflo	$v0				# 
    jr      $ra             # 31; 8
    
    # 父子函数间参量传递使用 $a 寄存器 (argument)
    # $v0 代表最终结果 (value)
```

C:
``` js
#include<stdio.h>
int factorial(int n){
    if(n == 1) return 1;
    else       return n * factorial(n - 1);
}

int main(){
    int n;
    scanf("%d", &n);
    printf("%d", factorial(n));
}
```
* 函数复用：`jal`进入子函数；
           `jr`返回主函数；
            寄存器出入栈：  + $t类寄存器调用者保存; $s类寄存器被调用者保存
* 函数嵌套：根函数与叶子函数无需将 `$ra` 入栈，其余中间函数均需入栈

* 发现自己的疑问在于“子函数”这一概念不清楚，出现相关代码就不太会写。

## Recursive:
  叶子函数 --> jr   $ra
  写代码时将 `return` 补全，遇见 `return` 即 `jr  $ra`
  递归调用自身  -->  将“发生变化”且“与调用者有关”的“状态变量”以及“跳转地址”储存起来。
                    譬如，全排列数递归，需要保存"$t0", "$a0"， “$ra”
  数组使用 -->  一维数组 `array($t0)` 属于典型的错误写法
                $t0 * 4 !!!!! 为什么我会把这件事情忘了呢（笑哭）
  写好C语言代码后，记得写注释，详细注释！！！
  主要目的： 预先设计标签名称，理清基本结构（if；for；子函数复用；子函数嵌套；递归 ...）
  标签命名： in_1; in_1_end; out_1; out_1_end; for_1; for_1_end; if_1; else_1; 

* 关于子函数使用的想法：
  其实仔细观察一下，从.text开始，到end_syscall为止，相当于主函数结构。
  end_syscall之后，才会出现子函数的使用。
  在编写MIPS程序时，先写出基本框架，基本结构成型后再“填肉”。

* 充分利用宏定义，消除冗余代码行
  但也要仔细检查，防止宏定义出错

.macro getindex(%ans, %i)
sll	%ans, %i, 2
.end_macro


.macro PI(%n)
move	$a0, %n
li	$v0, 1
syscall
.end_macro

.macro RI(%n)
li	$v0, 5
syscall
move	%n, $v0
.end_macro

.macro StackIn(%n)
sw	%n, 0($sp)
addi	$sp, $sp, -4
.end_macro 

.macro StackOut(%n)
addi	$sp, $sp, 4
lw	%n, 0($sp)
.end_macro 

.macro PS
li	$v0, 4
la	$a0, str_space
syscall
.end_macro

.macro PE
li	$v0, 4
la	$a0, str_enter
syscall
.end_macro

.macro END
li	$v0, 10
syscall
.end_macro

## 复习时 DEBUG 启示：
1. `label` : `la`
2. 一定要写注释，逐字还原，否则DEBUG过程将变得异常痛苦。。。
3. 栈中存储的指针为 "$ra" ，debug成功后对存储 "$ra" 的目的有了新的认识；
   + "`jal`"出现位置只有两处，一处在主函数第一次调用子函数时，另一处则在子函数调用自身形成递归结构时。
   + 若不将"`$ra`"存储在栈中，函数可以正常完成嵌套递归的过程，但无法返回主函数，
   + 因为第一次使用"`jal`"后"`$ra`"中存储的地址会被后续再次调用"jal"的过程中存储的新地址覆盖。
   + 那么为什么 “不将"`$ra`"存储在栈中，函数可以正常完成嵌套递归的过程” 呢？
   + 这是因为后续调用"`jal`"均在程序的同一位置进行，即使不存入栈中，PC返回的也是同一正确位置。

4. 还犯了一个愚蠢的小错误：其中一个"for"循环没有写跳出条件，
   导致程序无休止反复进行，把MARS4_5都搞不会了（笑哭）。

5. 改掉一个习惯：
   用"`$v0`"返回函数结果是一件很冒险的事情，
   其实也并没有很冒险，就是不好DEBUG
6. HAMILTON: "`$v0`"初始化错放在了"`Hamilton`"标签的前方。。。 (导致结果始终为"`5`/`1`/`0`")
7. 回溯代码一定要初始化( 初始位置 `f[0][0] = 1` )

## `P2` 考前临终关怀
最近 `脑子很乱` ，很难静下心来做好一件事。
即使现在，我敲击键盘的手仍在瑟瑟发抖。
这也是近两周以来让我最慌的一次考试，因为考前心态很不稳：
1. 因为进度落后了一周，心中总会暗暗产生一种慌张感。向大佬看齐，呵呵，实在是看不齐啊。。。
2. 最近由于季节交换，身体非常不适。肉体上的痛苦也进一步导致了精神上的煎熬，精神上的煎熬又进一步加剧了肉体上的折磨。这种显而易见的恶性循环，抓紧时间打破。
3. 最近大脑不够活跃，被一些琐碎无聊而消极的想法占据。Pro. Mihaly once said, A person can only focus on seven things simultaneously. 这些消极的想法已经耗费了我太多的精力，unnecessary, unhealthy, untrue，在mental power被耗尽前快走出来吧。
4. 情绪不稳定，是不够超脱，不够成熟的表现。我还是没有领悟到 the grand silence 的精髓。您看，我现在都不太会说出流畅的句子了，内心完全不平静，情绪不稳。
5. 因此，下面一整周我决定采用封闭疗法。拒绝一切想法对大脑的入侵，什么都不想，就专注于眼前的工作与任务. However, if you've got a chane, interact with people you like of course.
6. 关于周围人群的问题。还是那句话，It's not your surroundings make you feel agony, but your judgment and perceiving of your surroundings pain you. Numb yourself...
7. Appearance Anxiety: Phantom Pang

## 回归正题：
+ 现在最怕的就是de不出bug，前几天所有白痴的错误都叫我犯遍了。
  1. `StackIn($ra)`  (not `$sp` !!!)
   
  2. **2/3行顺序**
    ``` js
    .macro PI(%n)
    move    $a0, %n
    li      $v0, 1
    syscall
    .end_macro
    ```
  3. 使用数组时，务必记得使用`getindex` 
   
        寄存器灵活变换，有的时候中间变量没有存储的必要时，可以直接用新值覆盖原值
  4. 当`for`，`if` 函数嵌套较多时，不必慌乱。
        
        尤其千万不要忘记 `i++`， 跳出循环。

        `li     $t0, 0` 在 `for_2_end` 语句中写出。

  5. 关于多条件问题，C语言的逻辑是，逐个判断，如果第三个条件不满足，就不再看第四个条件了。
     如果我们采用位运算的方法来解决条件判断的话，可能会导致第三个条件不满足，但如果第三个条件不满足，第四个条件就会出现无意义的情况。
     比如，"01迷宫"一题，第一个条件为元素在数组中的位置不越界，然而如果在第一个条件没有满足的情况下，仍去提取越界地址的数组元素，编译器自然会报错。解决方案：不使用位运算的方法，而是采用逐个条件判定并`bne`的方法。这样，不仅避免了上述情况中错误的产生，同时也大大减小了 `MIPS` 执行语句数。