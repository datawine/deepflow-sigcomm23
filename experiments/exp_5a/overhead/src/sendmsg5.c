#include <sys/syscall.h>
#include <unistd.h>
#include <sys/socket.h>
#include <time.h>
#include <stdio.h>

#define REPEAT 20

double getTime() {
    int i;
    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);
    for (i = 0; i < 100000; i++) {
        syscall(__NR_sendmsg, 0, 0, 0, 0, 0, 0);
    }
    clock_gettime(CLOCK_MONOTONIC, &end);
    double elapsed_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1000000000.0;
    printf("Elapsed time: %f seconds\n", elapsed_time);
    return elapsed_time;
}

int main(){
    double average = 0;
    for (int i=0; i<REPEAT+1; i++){
        if(i){ average += getTime(); }
        else{ getTime(); }
    }
    printf("average time: %f seconds\n", average/REPEAT);
    return 0;
}