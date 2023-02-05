#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <time.h>
#include <errno.h>

int main() {
    char buffer[100];
    int fd = 0;  // 0 represents standard input (e.g. keyboard)
    int flags;
    int i;

    // Make the file descriptor non-blocking
    flags = fcntl(fd, F_GETFL, 0);
    flags |= O_NONBLOCK;
    fcntl(fd, F_SETFL, flags);

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    for (i = 0; i < 100000; i++) {
      int bytes_read = read(fd, buffer, 100);
      if (bytes_read == -1) {
        // EAGAIN is a normal error for non-blocking I/O
        if (errno == EAGAIN) {
          //printf("No data available\n");
        } else {
          //perror("read");
          return 1;
        }
      } else {
        //printf("Read %d bytes\n", bytes_read);
      }
    }

    clock_gettime(CLOCK_MONOTONIC, &end);
    double elapsed_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1000000000.0;
    printf("Elapsed time: %f seconds\n", elapsed_time);

    return 0;
}