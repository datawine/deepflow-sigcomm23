all: server client privkey.pem cacert.pem

server: server.c helper.h
	gcc -Wall -O0 server.c -o server -lssl -lcrypto

client: client.c helper.h
	gcc -Wall -O0 client.c -o client -lssl -lcrypto

clean:
	rm -rf client server cacert.pem privkey.pem

privkey.pem:
	openssl genrsa -out privkey.pem 4096

cacert.pem:
	openssl req -new -x509 -key privkey.pem -out cacert.pem -days 90

.PHONY: all clean
