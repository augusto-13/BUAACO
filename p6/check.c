#include<string.h>
#include<stdio.h>
int main(){
    int i = 0;
    char s1[250], s2[250];
    FILE *fp1, *fp2;
    fp1 = fopen("ysy_13_mars.txt", "r");
    fp2 = fopen("ysy_13_mycpu.txt", "r");
    while((fgets(s1, 250, fp1) != NULL) && (fgets(s2, 250, fp2) != NULL)){
    	i++;
    	if(strcmp(s1, s2) == 0)
    	continue;
    	else break;
	}
	printf("%d", i);
	fclose(fp1);
	fclose(fp2);
}
