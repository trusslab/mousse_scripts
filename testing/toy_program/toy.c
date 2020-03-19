#include <stdio.h>
#include <unistd.h>
#include <s2earm.h>
int main() {
    int i = 0;
    s2e_make_concolic(&i,4,"i");
    if(i < 100) {
        if(i < 50)
        {
            if(i < 25)
	            printf("test [0]\n");
            else
	            printf("test [1]\n");
        } 
        else {
            if(i < 75)
	            printf("test [2]\n");
            else
	            printf("test [3]\n");
        }
    } else {
        if(i < 200) {
            if(i < 150)
	            printf("test [4]\n");
            else
	            printf("test [5]\n");
        }
        else {
            if(i < 250)
	            printf("test [6]\n");
            else
	            printf("test [7]\n");
        }
    }
	return 0;
}
