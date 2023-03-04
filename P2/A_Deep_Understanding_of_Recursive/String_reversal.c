#include<stdio.h>
#include<string.h>
reverse(char *str, int n){
    if(n == 0 || n == 1){ 
    printf("%c",*str); 
    return;
    } 
    
    else{
        reverse(++str, n-1);		// "12345" -> "1" + "2(++str)345" -> reverse("2345") + "1"
        printf("%c", *(--str));		// "1(--str)"
    }
}

int main(){
	char s[10];
	scanf("%s",s);
	reverse(s,strlen(s));
}
