# Usa Debian como base
FROM debian:bookworm-slim

# Metadados
LABEL description="TeamSpeak 3 Server em Debian Slim"

# Variáveis de ambiente
ENV TS3_VERSION=3.13.7 \
    TS3_SHA256=775a5731a9809801e4c8f9066cd9bc562a1b368553139c1249f2a0740d50041e \
    TS3SERVER_LICENSE=accept \
    UID=1000 \
    GID=1000

# Instala dependências e TeamSpeak
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        tini \
        bzip2 \
        gosu \
    && mkdir -p /opt/teamspeak \
    && mkdir -p /var/ts3server \
    && wget -q "https://files.teamspeak-services.com/releases/server/${TS3_VERSION}/teamspeak3-server_linux_amd64-${TS3_VERSION}.tar.bz2" -O /tmp/teamspeak.tar.bz2 \
    && echo "${TS3_SHA256}  /tmp/teamspeak.tar.bz2" | sha256sum -c - \
    && tar -xjf /tmp/teamspeak.tar.bz2 -C /opt/teamspeak --strip-components=1 \
    && rm /tmp/teamspeak.tar.bz2 \
    && groupadd -g ${GID} teamspeak \
    && useradd -u ${UID} -g teamspeak --no-create-home --home-dir /nonexistent teamspeak \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configura volumes e portas
VOLUME ["/var/ts3server"]
EXPOSE 9987/udp 10011/tcp 30033/tcp

# Diretório de trabalho
WORKDIR /var/ts3server

# Script de entrada personalizado
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Ponto de entrada
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]