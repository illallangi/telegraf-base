FROM docker.io/library/python:3.10.5
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    XDG_CONFIG_HOME=/config \
    TELEGRAF_INTERVAL=300

RUN curl -s https://repos.influxdata.com/influxdb.key | apt-key add -
RUN echo "deb https://repos.influxdata.com/debian buster stable" > /etc/apt/sources.list.d/influxdb.list
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      iputils-ping=3:20210202-1 \
      lm-sensors=1:3.6.0-7 \
      snmp=5.9+dfsg-3+b1 \
      telegraf=1.22.4-1 \
    && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
RUN chmod +x /entrypoint.sh
CMD ["/usr/bin/telegraf"]
