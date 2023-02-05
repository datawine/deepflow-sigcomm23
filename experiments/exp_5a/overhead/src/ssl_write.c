#include <openssl/ssl.h>
#include <openssl/err.h>
#include <unistd.h>
#include <time.h>
#include <stdio.h>

int main() {
    SSL_CTX *ctx;
    SSL *ssl;

    // Initialize the SSL library
    SSL_library_init();
    SSL_load_error_strings();
    OpenSSL_add_all_algorithms();

    // Create a new SSL context
    ctx = SSL_CTX_new(SSLv23_client_method());
    if (ctx == NULL) {
        // Handle error
    }

    // Create a new SSL connection
    ssl = SSL_new(ctx);
    if (ssl == NULL) {
        // Handle error
    }

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);
    for (int i = 0; i < 100000; i++) {
        SSL_write(ssl, NULL, 0);
    }
    clock_gettime(CLOCK_MONOTONIC, &end);
    double elapsed_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1000000000.0;
    printf("Elapsed time: %f seconds\n", elapsed_time);

    // Clean up
    SSL_free(ssl);
    SSL_CTX_free(ctx);
    return 0;
}
