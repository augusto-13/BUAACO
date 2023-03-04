#include<stdio.h>

int symbol[8], array[8];
int n;                              // n -> $s0

void FullArray(int index){          // $t0 -> i
    int i;
    if(index >= n){                 // if_1:
        for(i = 0; i < n; i++){     // for_1:
            printf("%d",array[i]);
            putchar(' ');
        }
        putchar('\n');              // for_1_end:
        return;                     // jr $ra
    }
    else{                           // else_1:
    for(i = 0; i < n; i++){         // for_2:
        if(symbol[i] == 0){         // if_2:
            array[index] = i+1;
            symbol[i] = 1;
            FullArray(index+1);     // jal FullArray
            symbol[i] = 0;          
        }                           // else_2: i++; j for_2
    }                               // for_2_end: i = 0; jr $ra
    return;
    }
}

int main(){
    scanf("%d", &n);            
    FullArray(0);        // index -> $a0
    return 0;           
}
