# Pinne die Alpine-Version (aktuell 3.20)
FROM alpine:3.20

# apk add wird die neueste Patch-Version von privoxy installieren
# Es erstellt auch automatisch einen 'privoxy' user, den wir nutzen werden
RUN apk add --no-cache privoxy

# Kopiere die korrigierte Konfiguration
COPY privoxy.conf /etc/privoxy/config

# Wechsle zum sicheren, unprivilegierten 'privoxy' user
USER privoxy

EXPOSE 8118

# Diese CMD ist korrekt
CMD ["privoxy", "--no-daemon", "/etc/privoxy/config"]
