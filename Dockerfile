FROM ubuntu:14.04
RUN apt-get install strace
RUN mkdir rootdir
ADD ./copyexe.sh /usr/bin/copyexe
RUN copyexe rootdir dpkg apt-get bash
RUN apt-get download libc6 libbz2-1.0 libreadline6 zlib1g dpkg libstdc++6 libgcc1 liblzma5 libselinux1 tar coreutils findutils libc-bin libacl1 libattr1 sed
RUN for f in *.deb; do dpkg -X $f rootdir; done
RUN rm *.deb
WORKDIR rootdir
RUN mkdir -p var/log tmp
RUN cd bin && ln -s bash sh
RUN mkdir -p var/lib/dpkg/updates
RUN touch var/lib/dpkg/status var/lib/dpkg/available
RUN for pkg in libgcc1 libc6 multiarch-support libapt-pkg4.12 gpgv apt ubuntu-keyring gnupg; do apt-get download $pkg && chroot . dpkg -i $pkg*.deb; done 
RUN mkdir -p lib/x86_64-linux-gnu
RUN cp /lib/x86_64-linux-gnu/libnss_dns.so.2 lib/x86_64-linux-gnu
RUN cp /lib/x86_64-linux-gnu/libresolv.so.2 lib/x86_64-linux-gnu
RUN cp /usr/bin/strace usr/bin
RUN mkdir -p etc/apt/apt.conf.d
RUN mkdir -p var/cache/apt
RUN mkdir -p etc/apt/sources.list.d
RUN mkdir -p usr/lib/apt
RUN cp -R /usr/lib/apt/methods usr/lib/apt/
RUN cp /etc/apt/sources.list etc/apt
RUN mkdir -p etc/apt/preferences.d
CMD ["tar", "-cO", "."]
