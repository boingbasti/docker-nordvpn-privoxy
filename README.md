# Privoxy HTTP Proxy Docker Container

A security-hardened, IPv4-only Privoxy HTTP proxy for Docker, designed for ad-blocking and to run behind a VPN gateway.

---
## 📦 Links
- **Docker Hub**: [boingbasti/nordvpn-privoxy](https://hub.docker.com/r/boingbasti/nordvpn-privoxy)
- **GitHub Repository**: [boingbasti/docker-nordvpn-privoxy](https://github.com/boingbasti/docker-nordvpn-privoxy)

---
## ✨ Features
- **Ad-Blocking & Privacy**: Comes with a pre-configured setup to block ads, trackers, and other malicious content.
- **Minimal & Secure**: Built on a tiny Alpine Linux image for a minimal attack surface.
- **Hardened by Default**: The remote web interface (`p.p` / `config.privoxy.org`) is disabled to prevent unauthorized configuration changes from your network.
- **Strictly IPv4**: Listens only on IPv4 and is configured to block all outgoing requests to IPv6 destinations, preventing potential data leaks.
- **Docker-Optimized**: Logs are sent directly to the container's standard output for easy monitoring with `docker logs`.

---
## 🛠 Requirements
- Docker installed on your host system.

---
## 📦 Environment Variables
This image is configured using the bundled `privoxy.conf` file and does not use environment variables.

---
## 🚀 Usage

There are two primary ways to use this proxy:

### 1. Standalone Mode
Run the proxy directly and expose its port to your host machine.
```yaml
# docker-compose.yml
version: "3.9"

services:
  http-proxy:
    image: boingbasti/nordvpn-privoxy:latest
    build: .
    container_name: privoxy-proxy
    ports:
      # Exposes Privoxy's default port 8118 to the host
      - "8118:8118"
    restart: unless-stopped
```
➡️ Clients can now connect to the HTTP proxy at `HOST_IP:8118`.

### 2. VPN Gateway Mode (Recommended)
Attach the proxy to a VPN gateway container (e.g., docker-nordvpn-gateway) so all its traffic is routed through the VPN tunnel.

```yaml
# In your existing docker-compose.yml with the vpn-gateway service...
services:
  vpn-gateway:
    # ... your vpn-gateway configuration ...

  http-proxy:
    image: boingbasti/nordvpn-privoxy:latest
    container_name: nordvpn-privoxy
    # This line is crucial: it shares the gateway's network stack
    network_mode: "service:vpn-gateway"
    depends_on:
      - vpn-gateway
    restart: unless-stopped
```
➡️ Clients should connect to the VPN gateway’s LAN IP (e.g., `192.168.1.240:8118`).

---
## ⚙️ Configuration
If you need custom rules, you can mount your own config to `/etc/privoxy/config`. This allows you to extend the functionality without building a new image.

1. Create your own configuration file locally (e.g., `my-privoxy.conf`).  
   It’s often easiest to start with the default config and modify it.

2. Mount your file into the container using a volume in your `docker-compose.yml`:

```yaml
services:
  http-proxy:
    # ...
    volumes:
      - ./my-privoxy.conf:/etc/privoxy/config:ro
    # ...
```

⚠️ **Important**: Your custom configuration file must contain  
`listen-address 0.0.0.0:8118`, otherwise the proxy will not be accessible from your network.

---
## 🔍 Troubleshooting
- **Connection refused / not working**  
  In standalone mode, ensure the ports mapping (`8118:8118`) is correct and the port is not blocked by a firewall.

- **Forbidden or Blocked errors when browsing**  
  This is likely Privoxy working as intended, blocking an ad or tracker.  
  You can view the container logs (`docker logs privoxy-proxy`) to see details about what is being blocked.

- **Cannot access IPv6 websites**  
  This is intentional. The proxy is strictly IPv4-only and will block requests to IPv6 addresses.
