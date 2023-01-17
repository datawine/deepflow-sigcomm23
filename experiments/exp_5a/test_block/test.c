#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <time.h>

int main(){    
    int start,end;  
    start = clock();
    for(int i=0; i<10000; i++){
        syscall(SYS_write, 1, "hello, world!\n", 14);
    }
    end = clock();  
    printf("time=%f\n",(double)(end - start)/CLOCKS_PER_SEC);  
    return 0;
}