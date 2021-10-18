FROM elixir:1.3
ENV HOME=/usr/src/phoenix_chat_demo
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y inotify-tools build-essential postgresql-client sudo
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - && apt-get install -y --force-yes nodejs
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

ADD . $HOME
WORKDIR $HOME
EXPOSE 4000
