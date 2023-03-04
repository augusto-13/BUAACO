#include<stdio.h>
int main(){
    int n;                  // $s0
    int i=0;                // $t0
    int is_tenet = 1;       // $a0
    char a[21];             // string: .space 20
    scanf("%d",&n);         // n -> $s0
    //getchar();
    while(i<n){
        a[i] = getchar();   // sw $v0,string($t0)
        i++;                //addi $t0, $t0, 1
    }

    for(i=0; i<n/2 ;i++)    // n/2 -> $s1
    if(a[i] != a[n-1-i])    // n-1-i -> $t1
    is_tenet = 0;           // a[i] -> $t2 a[n-1-i] -> $t1

    printf("%d",is_tenet);
}
