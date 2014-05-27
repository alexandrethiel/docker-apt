FROM ubuntu:14.04
RUN mkdir rootdir
ADD ./copyexe.sh /usr/bin/copyexe
RUN copyexe rootdir dpkg apt-get
WORKDIR rootdir
RUN mkdir -p etc/apt/apt.conf.d
RUN mkdir -p var/lib/dpkg
RUN mkdir -p var/cache/apt
RUN mkdir -p etc/apt/sources.list.d
RUN mkdir -p etc/apt/preferences.d
RUN touch var/lib/dpkg/status
CMD ["tar", "-cO", "."]
