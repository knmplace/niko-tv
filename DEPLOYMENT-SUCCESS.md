# Niko TV - Docker Deployment Success

## 🎉 Deployment Complete!

Niko TV has been successfully deployed on remote server **192.168.1.221** using Docker Compose with integrated VPN routing.

---

## 📊 Deployment Summary

### Infrastructure
- **Remote Server:** kyle@192.168.1.221 (Proxmox LXC Container)
- **Deployment Type:** Docker Compose
- **Environment:** Production
- **Auto-Start:** Enabled (via Docker systemd service)

### Containers Running

| Container | Image | Status | Purpose |
|-----------|-------|--------|---------|
| **media_vpn** | qmcgaw/gluetun:v3.40.0 | ✅ Healthy | VPN tunnel (Private Internet Access) |
| **niko-tv** | niko-tv-nodecast-tv | ✅ Running | IPTV player (NodeCast-TV) |

### VPN Configuration
- **Provider:** Private Internet Access (PIA)
- **Protocol:** OpenVPN
- **Server:** US East / New York
- **External IP:** 37.19.197.139 (New York City)
- **Healthcheck:** Passing

### Network Configuration
- **Architecture:** Two-container setup with shared network namespace
- **Network Mode:** NodeCast-TV uses Gluetun's network (all traffic routed through VPN)
- **TUN Device:** Configured via Proxmox LXC permissions

---

## 🌐 Access Information

### Web Interface
- **URL:** http://192.168.1.221:3000
- **Description:** NodeCast-TV IPTV Player

### Additional Services
| Port | Service | Description |
|------|---------|-------------|
| 3000 | NodeCast-TV | IPTV Player Web UI |
| 8888 | HTTP Proxy | Gluetun HTTP proxy |
| 7000 | Gluetun Status | VPN status panel |
| 7388 | Shadowsocks | Shadowsocks proxy (TCP/UDP) |

---

## 🛠️ Management Commands

### From Local Server (/home/apps/niko-tv)

```bash
# Check container status
./manage.sh status

# View logs (niko-tv or gluetun)
./manage.sh logs niko-tv
./manage.sh logs gluetun

# Check VPN status and external IP
./manage.sh vpn-status

# Restart containers
./manage.sh restart

# Stop containers
./manage.sh stop

# Start containers
./manage.sh start

# Rebuild containers
./manage.sh rebuild

# SSH to remote server
./manage.sh ssh
```

### Deploy Code Changes

```bash
cd /home/apps/niko-tv
./deploy.sh
```

This will:
1. Commit and push local changes to GitHub
2. Pull latest changes on remote server
3. Rebuild Docker containers
4. Verify deployment and show VPN status

---

## 📁 File Structure

### Local Server (/home/apps/niko-tv)
```
/home/apps/niko-tv/
├── .env.deployment              # Deployment configuration
├── manage.sh                    # Management script (Docker)
├── deploy.sh                    # Deployment script (Docker)
├── logs/
│   └── deployment.log          # Deployment history
├── DEPLOYMENT-SUCCESS.md        # This file
├── MONITORING-INTEGRATION.md    # Monitoring setup
├── PROXMOX-TUN-FIX.md          # Proxmox LXC configuration
└── scripts/
    └── install-docker-remote.sh # Docker installation script
```

### Remote Server (192.168.1.221)
```
/home/kyle/niko-tv/niko-tv/
├── docker-compose.yml           # Docker Compose configuration
├── .env                         # Environment variables (VPN credentials)
├── Dockerfile                   # NodeCast-TV container build
├── glueton/
│   ├── config/                 # Gluetun VPN configuration
│   └── temp/                   # Temporary files
├── iptvplayer/
│   └── data/                   # IPTV data (SQLite database)
├── server/                      # NodeCast-TV server code
└── public/                      # Web UI assets
```

---

## 🔒 Security Configuration

### Proxmox LXC Permissions
The following was added to the LXC container configuration on the Proxmox host:

```bash
# TUN Device Support
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file

# Sysctl permissions for Gluetun
lxc.apparmor.profile: unconfined
lxc.cap.drop:
lxc.mount.auto: proc:rw sys:rw
```

### Credentials Management
- **VPN credentials:** Stored in `/home/kyle/niko-tv/niko-tv/.env` (chmod 600)
- **File NOT in git:** `.env` is excluded via `.gitignore`
- **docker-compose.yml:** Uses environment variables (no hardcoded secrets)

---

## 📊 Monitoring Integration

### KNM Monitoring Dashboard
- **URL:** http://localhost:5005
- **Status:** ✅ Configured and running

The Niko TV project is registered in the monitoring dashboard:
- Remote health checks (HTTP 200 on port 3000)
- Deployment log tracking
- Multiple port monitoring (3000, 8888, 7000, 7388)

### Monitoring Config Location
`/home/apps/monitoring/config/projects.ts`

---

## 🔄 Auto-Start Configuration

### Docker Service
- **systemd service:** `docker.service`
- **Status:** Enabled (auto-start on boot)
- **Verify:** `systemctl is-enabled docker` → enabled

### Container Restart Policies
- **Gluetun (media_vpn):** `restart: always`
- **NodeCast-TV (niko-tv):** `restart: unless-stopped`

**Result:** Both containers will automatically start when the server reboots.

---

## 🧪 Verification Tests

### ✅ All Tests Passing

1. **Docker Installation**
   ```bash
   docker --version
   # Docker version 29.2.0, build 0b9d198

   docker compose version
   # Docker Compose version v5.0.2
   ```

2. **TUN Device**
   ```bash
   cat /dev/net/tun
   # File descriptor in bad state (normal when not in use)
   ```

3. **VPN Connection**
   ```bash
   docker logs media_vpn | grep "Public IP"
   # Public IP address is 37.19.197.139 (United States, New York, New York City)
   ```

4. **Web Access**
   ```bash
   curl -I http://192.168.1.221:3000
   # HTTP/1.1 200 OK
   ```

5. **Container Health**
   ```bash
   docker compose ps
   # media_vpn: Up (healthy)
   # niko-tv: Up
   ```

---

## 🐛 Troubleshooting

### Check Container Logs
```bash
# Gluetun VPN logs
./manage.sh logs gluetun

# NodeCast-TV logs
./manage.sh logs niko-tv
```

### VPN Not Connected
```bash
# Check VPN status
./manage.sh vpn-status

# Restart Gluetun
ssh kyle@192.168.1.221
cd /home/kyle/niko-tv/niko-tv
docker compose restart gluetun
```

### Port Already in Use
```bash
# Check what's using port 3000
ss -tulpn | grep :3000

# Kill old PM2 process if needed
pm2 delete niko-tv-dev && pm2 save
```

### Container Won't Start After Reboot
```bash
# Check Docker service
systemctl status docker

# Manually start containers
docker compose up -d
```

---

## 🚀 Next Steps

### Optional Enhancements

1. **Docker Management UI (Dockge)**
   - Lightweight web UI for Docker Compose management
   - Install on port 5001 for easy container control

2. **Remote Log Aggregation**
   - Sync remote logs to local server for centralized monitoring
   - Use rsync or log shipping to `/home/apps/niko-tv/logs/remote/`

3. **Health Check Endpoint**
   - Add `/health` endpoint to NodeCast-TV
   - Return Docker container status and VPN connection info

4. **Automated Backups**
   - Backup IPTV database (`iptvplayer/data/`)
   - Backup Gluetun config (`glueton/config/`)

---

## 📞 Support & Documentation

### Quick Links
- **Gluetun Wiki:** https://github.com/qdm12/gluetun/wiki
- **NodeCast-TV Repo:** https://github.com/technomancer702/nodecast-tv
- **Docker Compose Docs:** https://docs.docker.com/compose/

### Local Documentation
- [Proxmox TUN Fix](./PROXMOX-TUN-FIX.md) - LXC container configuration
- [Monitoring Integration](./MONITORING-INTEGRATION.md) - Dashboard setup

---

## ✅ Deployment Checklist

- [x] Docker and Docker Compose installed
- [x] Kyle user added to docker group
- [x] PM2 process cleaned up
- [x] Directory structure created
- [x] `.env` file configured with VPN credentials
- [x] `docker-compose.yml` updated (no hardcoded secrets)
- [x] Proxmox LXC TUN permissions configured
- [x] Proxmox LXC sysctl permissions configured
- [x] Gluetun container running and healthy
- [x] VPN connected (external IP verified)
- [x] NodeCast-TV container running
- [x] Web interface accessible (port 3000)
- [x] Docker auto-start enabled
- [x] Container restart policies configured
- [x] Local management scripts updated
- [x] Deployment script updated
- [x] Monitoring dashboard integrated
- [x] Deployment logs configured

---

## 🎯 Success Criteria - All Met!

✅ Docker containers running on remote server
✅ VPN tunnel active (Gluetun healthcheck passing)
✅ NodeCast-TV accessible at http://192.168.1.221:3000
✅ Containers auto-restart on reboot
✅ Local deployment script works (`./deploy.sh`)
✅ Local management script works (`./manage.sh status/logs/restart`)
✅ PM2 processes cleaned up
✅ Credentials secured in .env file (not in docker-compose.yml)
✅ Monitoring dashboard shows Docker deployment
✅ External IP visible in logs (37.19.197.139)

---

**Deployment Date:** 2026-01-28
**Deployed By:** Claude Code Automation
**Status:** ✅ PRODUCTION READY
