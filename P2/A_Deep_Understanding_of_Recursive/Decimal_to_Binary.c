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

//�õݹ�д���Ķ�����ת��������ǰ���� 
//����ģ�����ȵó��Ľ��Ϊĩβ���֣�����ȵ����������ӡ��λ���� 
