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

    clock_t start, end;
    start = clock();

    for (i = 0; i < NUM_ITERATIONS; i++) {
      int ret = write(fd, data, data_len);
      if (ret < 0) {
        perror("write");
        break;
      }
    }

    end = clock();
    double time_taken = ((double)(end - start)) / CLOCKS_PER_SEC;
    printf("Time taken: %f seconds\n", time_taken);

    return 0;
}