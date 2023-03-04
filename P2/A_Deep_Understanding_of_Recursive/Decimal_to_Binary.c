#include<stdio.h>
#include<string.h>
int first_1_appear = 0;

DecimaltoBinary(int n){
	if(n == 0 || n == 1) 	printf("%d",n);
	else{
		DecimaltoBinary(n/2);
		printf("%d",n%2);
	}
}


int main(){
	int n;
	scanf("%d",&n);
	DecimaltoBinary(n);
}

//用递归写出的二进制转化程序无前导零 
//利用模运算先得出的结果为末尾数字，因此先调用自身，后打印该位数字 
