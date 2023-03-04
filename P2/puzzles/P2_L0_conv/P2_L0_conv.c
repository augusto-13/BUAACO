#include<stdio.h>
int main()
{
    int m1,n1,m2,n2;
    scanf("%d%d%d%d", &m1, &n1, &m2, &n2);
    int i, j, k, l;
    int ans;
    int a[11][11], b[11][11];
    for(i=0; i<m1; i++)
    for(j=0; j<n1; j++)
    scanf("%d", &a[i][j]);
    for(i=0; i<m2; i++)
    for(j=0; j<n2; j++)
    scanf("%d", &b[i][j]);

    for(i=0; i<m1-m2+1; i++){
        for(j=0; j<n1-n2+1; j++){
        	ans = 0;
            for(k=0; k<m2; k++)
            for(l=0; l<n2; l++)
            ans += (a[i+k][j+l] * b[k][l]) ;
            printf("%d", ans);
            putchar(' ');
        }
        putchar('\n');
    }
    
}
