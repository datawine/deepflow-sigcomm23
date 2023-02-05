#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <time.h>

#define NUM_ITERATIONS 100000

int main() {
    int fd;
    char data[] = "";
    int data_len = strlen(data);
    int i;

    fd = STDOUT_FILENO;

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    for (i = 0; i < NUM_ITERATIONS; i++) {
      int ret = write(fd, data, data_len);
      if (ret < 0) {
        perror("write");
        break;
      }
    }

    clock_gettime(CLOCK_MONOTONIC, &end);
    double elapsed_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1000000000.0;
    printf("Elapsed time: %f seconds\n", elapsed_time);

    return 0;
}