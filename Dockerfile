FROM ubuntu:18.04 as ubuntu-base
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true
RUN apt-get -qqy update \
    && apt-get -qqy --no-install-recommends install \
        sudo \
        binutils \
        ufw \
        xrdp \
        xfce4 \
        xz-utils \
        gdebi \
        python-gtk2 \
        wget \
        xfce4-terminal \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
#============================
# Utilities
#============================
FROM ubuntu-base as ubuntu-utilities
RUN apt-get update \
    && apt install unzip \
    && dpkg --configure -a \
    && wget --no-check-certificate https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt install -qqy --no-install-recommends ./google-chrome-stable_current_amd64.deb \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && wget -c https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.6/fahclient_7.6.21_amd64.deb \
    && wget -c https://download.foldingathome.org/releases/public/release/fahcontrol/debian-stable-64bit/v7.6/fahcontrol_7.6.21-1_all.deb \
    && ar vx fahclient_7.6.21_amd64.deb \
    && tar -xvf control.tar.xz \
    && tar -xvf data.tar.xz \
    && dpkg -i --force-depends fahclient_7.6.21_amd64.deb \
    && dpkg -i --force-depends fahcontrol_7.6.21-1_all.deb
# COPY conf.d/* /etc/supervisor/conf.d/
#============================
# GUI
#============================
FROM ubuntu-utilities as ubuntu-ui
RUN sed -i.bak '/fi/a #xrdp multiple users configuration \n xfce-session \n' /etc/xrdp/startwm.sh
RUN adduser xrdp ssl-cert
RUN ufw allow 3389/tcp
RUN /etc/init.d/xrdp restart
