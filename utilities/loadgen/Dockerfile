FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y build-essential ca-certificates vim curl git libssl-dev telnet python3 python3-pip \
    && update-ca-certificates

WORKDIR /
RUN git clone https://github.com/giltene/wrk2.git

WORKDIR /wrk2
RUN make

WORKDIR /

CMD ["sleep", "315360000"]
