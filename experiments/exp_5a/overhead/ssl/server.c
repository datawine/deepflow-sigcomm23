#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <openssl/ssl.h>
#include <openssl/err.h>
#include <assert.h>
#include "helper.h"
#include <time.h>

int main(int argc, char **argv)
{
	int idx;
	SSL_CTX *ctx;
	socklen_t len;
	int sockfd, fd;
	//ticks begin, end, total;
	char *buffer;
	struct sockaddr_in addr, peer;

	buffer = malloc(BUFFER_SIZE);
	assert(buffer);

	// strcpy(buffer, "GET / HTTP/1.0\r\n\r\n");

	/* SSL 库初始化 */
	SSL_library_init();
	/* 载入所有 SSL 算法 */
	OpenSSL_add_all_algorithms();
	/* 载入所有 SSL 错误消息 */
	SSL_load_error_strings();
	/* 以 SSL V2 和 V3 标准兼容方式产生一个 SSL_CTX ，即 SSL Content Text */
	assert(ctx = SSL_CTX_new(SSLv23_server_method()));

	/* 载入用户的数字证书， 此证书用来发送给客户端。 证书里包含有公钥 */
	assert(SSL_CTX_use_certificate_file(ctx, "cacert.pem", SSL_FILETYPE_PEM) > 0);

	/* 载入用户私钥 */
	assert(SSL_CTX_use_PrivateKey_file(ctx, "privkey.pem", SSL_FILETYPE_PEM) > 0);

	/* 检查用户私钥是否正确 */
	assert(SSL_CTX_check_private_key(ctx));

	/* 开启一个 socket 监听 */
	assert((sockfd = socket(PF_INET, SOCK_STREAM, 0)) != -1);

	bzero(&addr, sizeof(addr));
	addr.sin_family = PF_INET;
	addr.sin_port = htons(SERVER_PORT);
	addr.sin_addr.s_addr = INADDR_ANY;
	assert(bind(sockfd, (struct sockaddr *)&addr, sizeof(struct sockaddr)) != -1);

	assert(listen(sockfd, 2) != -1);

	while (1)
	{
		SSL *ssl;
		len = sizeof(struct sockaddr);
		/* 等待客户端连上来 */
		fd = accept(sockfd, (struct sockaddr *)&peer, &len);
		assert(fd != -1);

		/* 基于 ctx 产生一个新的 SSL */
		ssl = SSL_new(ctx);
		/* 将连接用户的 socket 加入到 SSL */
		SSL_set_fd(ssl, fd);
		/* 建立 SSL 连接 */

		assert(SSL_accept(ssl) != -1);

		/* 发消息给客户端 */
		//total = 0;
		double total_time = 0;
		for (idx = 0; idx < 10000; ++idx)
		{
			struct timespec start, end;
    		clock_gettime(CLOCK_MONOTONIC, &start);
			len = SSL_write(ssl, buffer, BUFFER_SIZE);
			clock_gettime(CLOCK_MONOTONIC, &end);
    		double elapsed_time = ((end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1000000000.0)*1000;
			total_time += elapsed_time;
			assert(len > 0);
		}
		printf("%lf\n", total_time);

		/* 关闭 SSL 连接 */
		SSL_shutdown(ssl);
		/* 释放 SSL */
		SSL_free(ssl);
		/* 关闭 socket */
		close(fd);
	}

	/* 关闭监听的 socket */
	close(sockfd);
	/* 释放 CTX */
	SSL_CTX_free(ctx);
	free(buffer);
	return 0;
}