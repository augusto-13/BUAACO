#include<stdio.h>
#include<string.h>

int isPalindrome(char *str, int n){
	if( n == 0 || n == 1 ) 
	return 1;
	else{
		if( *str == *(str + n - 1))		
		return isPalindrome( ++str, n-2 );
		else 
		return 0;
	}
	
} 

int main(){
	char s[100];
	scanf("%s",s);
	printf("%d", isPalindrome(s, strlen(s)));
}
