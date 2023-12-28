FROM toetje585/arch-wine-vnc:latest
LABEL org.opencontainers.image.authors = "Toetje585"
LABEL org.opencontainers.image.source = "https://github.com/wine-gameservers/arch-wine-vnc"

# additional files
##################

COPY build/rootfs /

RUN mkdir -p /home/container/log/
RUN touch /home/container/log/supervisord.log
RUN chown -R nobody:nobody /home/*

# add install bash script
ADD build/install.sh /root/install.sh

# install script
##################
RUN chmod +x /root/install.sh && /bin/bash /root/install.sh
RUN chmod +x /usr/local/bin/init.sh && /bin/bash /usr/local/bin/init.sh

# Expose port for FS22 Webserver

EXPOSE 8080/tcp

# Expose port for the FS22 Gameserver
EXPOSE 10823/tcp
EXPOSE 10823/udp

WORKDIR /home/container

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor.conf", "-n"]
