FROM debian:jessie-slim

MAINTAINER Simon Hookway <simon@obsidian.com.au>

ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG TIMEZONE
ARG CLIENT
ARG SERVERNAME
ARG IP
ARG FQDN

ENV http_proxy ${HTTP_PROXY:-}
ENV https_proxy ${HTTPS_PROXY:-}
ENV CLIENT ${CLIENT:-}
ENV SERVERNAME ${SERVERNAME:-}
ENV IP ${IP:-}
ENV FQDN ${FQDN:-}

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get install --yes apt-utils vim mysql-server-5.5 mysql-client-5.5 less vim net-tools

# Fix timezone
RUN rm /etc/localtime \
  && ln -sv /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata

COPY mysql-conf/my.cnf /etc/mysql/
COPY mysql-conf/debian.cnf /etc/mysql/
COPY mysql-conf/conf.d/ /etc/mysql/conf.d/
COPY mysql-conf/mysql-$SERVERNAME.cnf /etc/mysql/conf.d/
COPY mysql-conf/mysql-$CLIENT.cnf /etc/mysql/conf.d/

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

STOPSIGNAL SIGTERM

VOLUME ["/opt/Database", "/opt/Reports", "/opt/Archive"]
EXPOSE 3306

CMD []

