#include<stdio.h>


hanoi(int n, int from, int via, int to){
	if(n == 1) printf("move %d from %d to %d\n", n, from, to);
	else{
		hanoi(n-1, from, to, via);
		printf("move %d from %d to %d\n", n, from, to);
		hanoi(n-1, via, from, to);
	}
}

int main()
{
	int n;
	scanf("%d", &n);		// $s0 -> n
	hanoi(n,1,2,3);			// $a0(n), $a1(from), $a2(via), $a3(to)
	return 0;				
 } 
 

