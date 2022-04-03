FROM ubuntu:18.04 as ubuntu-base
ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true
RUN apt-get -qqy update \
    && apt-get -qqy --no-install-recommends install \
        binutils \
        xz-utils \
        gnome-system-monitor \
        gdebi \
        python-gtk2 \
        wget \
        xfce4-terminal \
        xvfb x11vnc novnc websockify \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
#============================
# Utilities
#============================
FROM ubuntu-base as ubuntu-utilities
RUN apt-get update \
    && dpkg --configure -a \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && wget --no-check-certificate https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.6/fahclient_7.6.21_amd64.deb \
    && wget --no-check-certificate https://download.foldingathome.org/releases/public/release/fahcontrol/debian-stable-64bit/v7.6/fahcontrol_7.6.21-1_all.deb \
    && ar vx fahclient_7.6.21_amd64.deb \
    && tar -xvf control.tar.xz \
    && tar -xvf data.tar.xz \
    && apt-get install ./fahclient_7.6.21_amd64.deb \
    && apt-get install ./fahcontrol_7.6.21-1_all.deb
# COPY conf.d/* /etc/supervisor/conf.d/
#============================
# GUI
#============================
FROM ubuntu-utilities as ubuntu-ui
ENV SCREEN_WIDTH=1300 \
    SCREEN_HEIGHT=620 \
    SCREEN_DEPTH=24 \
    SCREEN_DPI=96 \
    DISPLAY=:99 \
    DISPLAY_NUM=99 \
    UI_COMMAND=/usr/bin/startxfce4
RUN apt-get update -qqy \
    && apt-get -qqy install --no-install-recommends \
        dbus-x11 xfce4 \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
