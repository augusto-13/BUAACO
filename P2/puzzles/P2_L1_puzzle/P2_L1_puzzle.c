#include<stdio.h>

int a[10][10];                      // a:
int f[10][10];                      // f:
int p1, q1, p2, q2;                 // $s2, $s3, $s4, $s5
int n, m;                           // $s0, $s1
int cnt = 0;                        // $v0
int dirtp[] = {0, 0, 1, -1};        // dirtp:       
int dirtq[] = {1, -1, 0, 0};        // dirtq:

void DFS(int p, int q){             // 多条件判断使用$s6(main), $s7
    int i;                          // i -> $t0
    if(p == p2 && q == q2){         // $a0 == $s4 $a1 == $s5
        cnt++;                      // $v0++
        return;
    }
    for(i = 0; i < 4; i++){         // $t0 -> i
        int p_ = p + dirtp[i];      // $t1 -> p_; $t2 -> q_
        int q_ = q + dirtq[i];      // $t1 = $a0 + dirtp($t0) && $t2 = $a1 + dirtq($t0)
        if(p_ >= 0 && p_ < n && q_ >= 0 && q_ < m && f[p_][q_] == 0 && a[p_][q_] == 0){
            f[p_][q_] = 1;
            DFS(p_, q_);            // StackOut: p_, q_, p, q, i, $ra
            f[p_][q_] = 0;
        }

    }
    return;
}

int main(){
    int i, j;
    scanf("%d%d", &n, &m);  
    for(i = 0; i < n; i++){         // i -> $t0, j -> $t1
        for(j = 0; j < m; j++){
            scanf("%d",&a[i][j]);
        }
    }
    scanf("%d%d%d%d", &p1, &q1, &p2, &q2);
    p1--;
    p2--;
    q1--;
    q2--;
    f[p1][q1] = 1;  // ********
    DFS(p1, q1);
    printf("%d\n", cnt);
}
