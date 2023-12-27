FROM archlinux:base AS BUILDER

RUN useradd -m test

RUN pacman -Sy --noconfirm
RUN pacman -S git fakeroot binutils xorg-server libxtst make gcc --noconfirm
USER test
WORKDIR /gitclone
RUN git clone https://aur.archlinux.org/xmacro.git
RUN cd xmacro && makepkg -s

FROM toetje585/arch-wine-vnc:latest
LABEL org.opencontainers.image.authors = "Toetje585"
LABEL org.opencontainers.image.source = "https://github.com/wine-gameservers/arch-wine-vnc"

# additional files
##################

COPY --from=BUILDER /gitclone/xmacro/*.pkg.tar.zst xmacro.pkg.tar.zst
COPY build/rootfs /

RUN chown -R nobody:nobody /home/*
RUN pacman -S xorg-server libxtst --noconfirm && pacman -U xmacro.pkg.tar.zst --noconfirm
RUN mkdir -p /home/container/{config,game,installer,dlc}

# add install bash script
ADD build/install.sh /root/install.sh

# install script
##################
RUN chmod +x /root/install.sh && /bin/bash /root/install.sh

# Expose port for FS22 Webserver

EXPOSE 8080/tcp

# Expose port for the FS22 Gameserver
EXPOSE 10823/tcp
EXPOSE 10823/udp

RUN chmod -R +w /var/log