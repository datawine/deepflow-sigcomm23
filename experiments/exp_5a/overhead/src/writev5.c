#include <sys/uio.h>
#include <unistd.h>
#include <time.h>
#include <stdio.h>

int main() {
    clock_t start, end;
    start = clock();
    for (int i = 0; i < 100000; i++) {
        writev(0, NULL, 0);
    }
    end = clock();
    double time_taken = ((double)(end - start)) / CLOCKS_PER_SEC;
    printf("Time taken: %f seconds\n", time_taken);
    return 0;
}