#include <openssl/ssl.h>
#include <openssl/err.h>
#include <sys/socket.h>
#include <resolv.h>
#include <netdb.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#define HOST "www.example.com"
#define PORT 443
#define REPEAT 100

SSL_CTX *ctx;
SSL *ssl;
int sock;
struct sockaddr_in dest_addr;
struct hostent *host;
char *request = "GET / HTTP/1.0\r\n\r\n";
char response[4096];
int bytes_read;

int main(int argc, char *argv[])
{
    double average = 0;
    for(int i=0; i<REPEAT; i++){
        SSL_library_init();
        SSL_load_error_strings();
        ctx = SSL_CTX_new(TLSv1_2_client_method());
    
        sock = socket(AF_INET, SOCK_STREAM, 0);
        host = gethostbyname(HOST);
        memset(&dest_addr, 0, sizeof(dest_addr));
        dest_addr.sin_family = AF_INET;
        dest_addr.sin_port = htons(PORT);
        dest_addr.sin_addr.s_addr = *(long*)(host->h_addr);
        connect(sock, (struct sockaddr*) &dest_addr, sizeof(dest_addr));
    
        ssl = SSL_new(ctx);
        SSL_set_fd(ssl, sock);

        struct timespec start, end;
        clock_gettime(CLOCK_MONOTONIC, &start);
        SSL_write(ssl, request, strlen(request));
        clock_gettime(CLOCK_MONOTONIC, &end);
        double elapsed_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1000000.0;
        
        bytes_read = SSL_read(ssl, response, sizeof(response) - 1);

        average += elapsed_time;
        response[bytes_read] = '\0';
    
        SSL_free(ssl);
        close(sock);
        SSL_CTX_free(ctx);
        sleep(0.5);
    }
    printf("milliseconds: %lf\n", average);
    return 0;
}
