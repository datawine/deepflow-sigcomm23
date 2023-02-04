#include <sys/syscall.h>
#include <unistd.h>
#include <sys/socket.h>
#include <time.h>
#include <stdio.h>

int main() {
    int i;
    clock_t start, end;
    start = clock();
    for (i = 0; i < 100000; i++) {
        syscall(__NR_sendmmsg, 0, 0, 0, 0, 0, 0);
    }
    
    end = clock();
    double time_taken = ((double)(end - start)) / CLOCKS_PER_SEC;
    printf("Time taken: %f seconds\n", time_taken);
    return 0;
}