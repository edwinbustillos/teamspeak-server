#!/bin/sh

# Verifica se é a primeira execução
if [ ! -f /var/ts3server/licensekey.dat ]; then
    cp -a /opt/teamspeak/* /var/ts3server/
fi

# Ajusta permissões
chown -R teamspeak:teamspeak /var/ts3server

# Executa o servidor como usuário não-root
exec su-exec teamspeak /opt/teamspeak/ts3server \
    license_accepted=1 \
    query_protocols=http \
    query_http_ip=0.0.0.0 \
    query_http_port=10011 \
    filetransfer_port=30033 \
    voice_ip=0.0.0.0 \
    default_voice_port=9987 \
    dbplugin=ts3db_sqlite3 \
    dbsqlpath=/opt/teamspeak/sql/ \
    dbpath=/var/ts3server/ \
    logpath=/var/ts3server/logs/ \
    query_ip_whitelist=/var/ts3server/query_ip_whitelist.txt \
    query_ip_blacklist=/var/ts3server/query_ip_blacklist.txt \
    "$@"