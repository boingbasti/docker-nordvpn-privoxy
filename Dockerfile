# Pinne die Alpine-Version (aktuell 3.20)
FROM alpine:3.20

# --- GEÄNDERT ---
# Füge curl hinzu, benötigt für den Healthcheck
RUN apk add --no-cache privoxy curl
# --- ENDE ---

# Kopiere die korrigierte Konfiguration
COPY privoxy.conf /etc/privoxy/config

# Wechsle zum sicheren, unprivilegierten 'privoxy' user
USER privoxy

EXPOSE 8118

# Diese CMD ist korrekt
CMD ["privoxy", "--no-daemon", "/etc/privoxy/config"]
