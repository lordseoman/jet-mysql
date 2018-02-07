FROM debian:jessie-slim

ARG HTTP_PROXY
ARG HTTPS_PROXY
ENV http_proxy ${HTTP_PROXY:-}
ENV https_proxy ${HTTPS_PROXY:-}

ENV DEBIAN_FRONTEND noninteractive

ARG DB_PASSWORD
ENV MYSQL_ROOT_PASSWORD ${DB_PASSWORD:-g0aWa5}

ARG REALM
ARG MACHINE

RUN apt-get update \
  && apt-get install --yes apt-utils vim mysql-server-5.5 mysql-client-5.5 less vim

# Fix timezone
RUN rm /etc/localtime \
  && ln -sv /usr/share/zoneinfo/America/Edmonton /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata

COPY my.cnf /etc/mysql/
COPY debian.cnf /etc/mysql/
COPY conf.d/ /etc/mysql/conf.d/
COPY clients/$REALM/mysql-$MACHINE.cnf /etc/mysql/conf.d/
COPY clients/$REALM/mysql-$REALM.cnf /etc/mysql/conf.d/

VOLUME ["/opt/Database", "/opt/Archive"]

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

STOPSIGNAL SIGTERM

EXPOSE 3306

CMD ["start"]

