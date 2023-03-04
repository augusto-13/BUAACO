#include<stdio.h>
int main()
{
    int a[8][8], b[8][8];       // matrix_A, matrix_B
    int n, i, j, k, ans;        // i: $t0, j: $t1, k: $t2
    scanf("%d", &n);            // n: $s0
    for(i=0; i<n; i++)
    for(j=0; j<n; j++)          
    scanf("%d",&a[i][j]);
    for(i=0; i<n; i++)
    for(j=0; j<n; j++)
    scanf("%d",&b[i][j]);

    for(i=0; i<n; i++){
         for(j=0; j<n; j++){
             ans = 0;
             for(k=0; k<n; k++)
             ans += (a[i][k] * b[k][j]);
             printf("%d", ans);
             printf(" ");
        }
    printf("\n");
    }

}
