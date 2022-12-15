FROM ubuntu:22.04

RUN apt update \
    && apt install -y build-essential git make

WORKDIR /
RUN git clone https://github.com/giltene/wrk2.git

WORKDIR /wrk2
RUN make \
    && cp wrk /usr/local/bin

ENTRYPOINT ["/usr/local/bin/wrk"]