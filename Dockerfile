FROM debian:wheezy
MAINTAINER tuxeh <sirtuxeh@gmail.com>

# mono 3.10 currently doesn't install in debian jessie due to libpeg8 being removed.

#USER nzbdrone
RUN /sbin/setuser nzbdrone
RUN usermod -u 108 nzbdrone
RUN usermod -g 100 nzbdrone

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC \
  && echo "deb http://apt.sonarr.tv/ master main" | tee -a /etc/apt/sources.list \
  && apt-get update -q \
  && apt-get install -qy nzbdrone mediainfo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN chown -R nzbdrone:users /opt/NzbDrone \
  ; mkdir -p /volumes/config/sonarr /volumes/completed /volumes/media \
  && chown -R nzbdrone:users /volumes

EXPOSE 8989
EXPOSE 9898
VOLUME /volumes/config
VOLUME /volumes/completed
VOLUME /volumes/media

ADD develop/start.sh /
RUN chmod +x /start.sh

ADD develop/sonarr-update.sh /sonarr-update.sh
RUN chmod 755 /sonarr-update.sh \
  && chown nzbdrone:users /sonarr-update.sh

WORKDIR /opt/NzbDrone

ENTRYPOINT ["/start.sh"]
