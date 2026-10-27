FROM alpine:3.24

# Install privoxy and curl (curl required for healthcheck)
RUN apk add --no-cache privoxy curl

# Copy configuration
COPY privoxy.conf /etc/privoxy/config

# Switch to unprivileged privoxy user
USER privoxy

EXPOSE 8118

CMD ["privoxy", "--no-daemon", "/etc/privoxy/config"]
