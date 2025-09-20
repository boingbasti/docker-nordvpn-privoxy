FROM alpine:latest

RUN apk add --no-cache privoxy

# Copy config
COPY privoxy.conf /etc/privoxy/config

EXPOSE 8118

CMD ["privoxy", "--no-daemon", "/etc/privoxy/config"]
