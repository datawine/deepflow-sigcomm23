#include <string.h>
#include <errno.h>
#include <sys/socket.h>
#include <resolv.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <openssl/ssl.h>
#include <openssl/err.h>
#include <assert.h>
#include "helper.h"
#include <time.h>

int main()
{
	int asdf;
	scanf("%d", &asdf);
	for(int xs=0; xs<21; xs++){
		SSL *ssl;
		SSL_CTX *ctx;
		int sockfd, len;
		char *buffer;
		struct sockaddr_in dest;
		//ticks begin, end, total;

		buffer = malloc(BUFFER_SIZE);
		assert(buffer);

		/* SSL 库初始化，参看 ssl-server.c 代码 */
		SSL_library_init();
		OpenSSL_add_all_algorithms();
		SSL_load_error_strings();
		assert(ctx = SSL_CTX_new(SSLv23_client_method()));

		/* 创建一个 socket 用于 tcp 通信 */
		assert((sockfd = socket(AF_INET, SOCK_STREAM, 0)) >= 0);

		/* 初始化服务器端（对方）的地址和端口信息 */
		bzero(&dest, sizeof(dest));
		dest.sin_family = AF_INET;
		dest.sin_port = htons(SERVER_PORT);
		assert(inet_aton(SERVER_ADDR, (struct in_addr *)&dest.sin_addr.s_addr));

		/* 连接服务器 */
		assert(!connect(sockfd, (struct sockaddr *)&dest, sizeof(dest)));

		/* 基于 ctx 产生一个新的 SSL */
		ssl = SSL_new(ctx);
		SSL_set_fd(ssl, sockfd);
		/* 建立 SSL 连接 */
		assert(SSL_connect(ssl) != -1);

		/* 接收服务器来的消息 */
		double total_time = 0;
		int number = 0;
		
		do
		{
			struct timespec start, end;
			clock_gettime(CLOCK_MONOTONIC, &start);
			len = SSL_read(ssl, buffer, BUFFER_SIZE);
			clock_gettime(CLOCK_MONOTONIC, &end);
			double elapsed_time = ((end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1000000000.0)*1000;
			total_time += elapsed_time;
			assert(len >= 0);
			number++;
		} while (len > 0);
		printf("%lf\n", total_time);
		// printf("%d\n", number);

		/* 关闭连接 */
		SSL_shutdown(ssl);
		SSL_free(ssl);
		close(sockfd);
		SSL_CTX_free(ctx);
		free(buffer);
	}
	return 0;
}