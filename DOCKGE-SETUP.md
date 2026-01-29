# Dockge - Docker Compose Manager

## ✅ Setup Complete!

Dockge is now running on the remote server and integrated with the monitoring dashboard. Dockge provides a visual interface for managing Docker Compose stacks.

---

## 🌐 Access Dockge

**Direct Access:** http://192.168.1.221:5001

**From Monitoring Dashboard:** http://localhost:5005 → Click "Dockge" in the Management Tools section

---

## 📋 What is Dockge?

Dockge is a modern, user-friendly Docker Compose stack-oriented manager that provides:

- ✅ **Visual Interface** - Manage Docker Compose stacks through a web UI
- ✅ **Live Editor** - Edit docker-compose.yaml files with syntax highlighting
- ✅ **Container Management** - Start, stop, restart containers with one click
- ✅ **Real-time Logs** - View container logs in real-time
- ✅ **Terminal Access** - Execute commands inside containers
- ✅ **Resource Monitoring** - View CPU, memory, and network usage
- ✅ **Multi-Stack Support** - Manage multiple compose projects

---

## 🏗️ Installation Details

### Location

**Remote Server:** 192.168.1.221
**Installation Path:** `/home/kyle/dockge/`
**Configuration:** `/home/kyle/dockge/docker-compose.yml`
**Data Directory:** `/home/kyle/dockge/data/`
**Stacks Directory:** `/home/kyle/` (monitors all docker-compose projects)

### Docker Compose Configuration

```yaml
services:
  dockge:
    image: louislam/dockge:1
    restart: unless-stopped
    ports:
      - 5001:5001
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data:/app/data
      - /home/kyle:/home/kyle
    environment:
      - DOCKGE_STACKS_DIR=/home/kyle
    security_opt:
      - apparmor=unconfined
```

### Ports

- **5001** - Dockge Web Interface

**Port Conflict Check:**
- ✅ Port 5001 does not conflict with existing services
- Monitoring Dashboard: 5005 ✅
- Webhook Server: 9000 ✅
- Niko TV: 3000 ✅

---

## 🎯 Features & Usage

### 1. Viewing Stacks

Dockge automatically detects all docker-compose projects in `/home/kyle/`:

**Current Stacks:**
- **niko-tv** - IPTV player with VPN (Gluetun + NodeCast-TV)
- **dockge** - Dockge itself

### 2. Managing Containers

**Start/Stop:**
- Click the play/stop icons next to each stack
- Or use the action buttons for individual containers

**Restart:**
- Click restart icon to restart containers without rebuilding

**Rebuild:**
- Click rebuild icon to rebuild images and restart containers

### 3. Viewing Logs

- Click on a stack to view its containers
- Click "Logs" button to view real-time container logs
- Supports log filtering and search

### 4. Editing Compose Files

- Click "Edit" button on any stack
- Syntax-highlighted YAML editor
- Save changes and restart stack with one click

### 5. Terminal Access

- Click "Terminal" button to open shell inside containers
- Execute commands directly in running containers
- Useful for debugging and maintenance

### 6. Creating New Stacks

1. Click "Add Stack" button
2. Enter stack name
3. Paste or edit docker-compose.yaml content
4. Click "Deploy"

---

## 🚀 Quick Start Guide

### First Time Setup

**1. Access Dockge:**
```
Open browser: http://192.168.1.221:5001
```

**2. Create Admin Account:**
- On first visit, you'll be prompted to create an admin account
- Choose a strong username and password
- This account controls all Docker management

**3. View Existing Stacks:**
- Dockge will automatically detect Niko TV stack
- Click on "niko-tv" to view containers

### Managing Niko TV via Dockge

**View Containers:**
1. Click on "niko-tv" stack
2. See both containers: Gluetun VPN and NodeCast-TV
3. View status, uptime, and resource usage

**View Logs:**
1. Click "Logs" button
2. Select container (gluetun or nodecast-tv)
3. View real-time logs with auto-scroll

**Restart Containers:**
1. Click restart icon
2. Containers restart without rebuilding
3. Faster than full deploy

**Edit Configuration:**
1. Click "Edit" button
2. Modify docker-compose.yml
3. Click "Save & Restart"

---

## 🔧 Common Tasks

### Task 1: Restart Niko TV Containers

**Via Dockge UI:**
1. Go to http://192.168.1.221:5001
2. Find "niko-tv" stack
3. Click restart icon (circular arrow)
4. Wait for containers to restart

**Via SSH (Alternative):**
```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/niko-tv/niko-tv
docker compose restart
```

### Task 2: View Container Logs

**Via Dockge UI:**
1. Click on "niko-tv" stack
2. Click "Logs" button
3. Select container (gluetun or nodecast-tv)
4. Logs display in real-time

**Via SSH (Alternative):**
```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/niko-tv/niko-tv
docker compose logs -f gluetun
# Or
docker compose logs -f nodecast-tv
```

### Task 3: Update Docker Compose Configuration

**Via Dockge UI:**
1. Click on "niko-tv" stack
2. Click "Edit" button
3. Modify YAML configuration
4. Click "Save & Deploy"

**Via SSH (Alternative):**
```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/niko-tv/niko-tv
nano docker-compose.yml
# Make changes
docker compose up -d --build
```

### Task 4: Stop All Containers

**Via Dockge UI:**
1. Click on "niko-tv" stack
2. Click "Stop" button
3. All containers in stack stop

**Via SSH (Alternative):**
```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/niko-tv/niko-tv
docker compose down
```

### Task 5: Check Container Resource Usage

**Via Dockge UI:**
1. View CPU, memory, network stats on dashboard
2. Real-time updates every few seconds

**Via SSH (Alternative):**
```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
docker stats
```

---

## 🛡️ Security Notes

### Access Control

- **Admin Account Required** - Must create account on first visit
- **No Public Access** - Only accessible on local network (192.168.1.x)
- **Firewall Protected** - Port 5001 not exposed to internet

### Docker Socket Access

- Dockge has full Docker socket access (`/var/run/docker.sock`)
- Can manage ALL containers on the server
- Protect admin credentials carefully

### Recommendations

- ✅ Use strong admin password
- ✅ Keep Dockge updated (restart container pulls latest image)
- ✅ Only access from trusted networks
- ✅ Consider VPN access if exposing to internet

---

## 🔄 Management

### Restart Dockge Container

```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/dockge
docker compose restart
```

### Stop Dockge

```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/dockge
docker compose down
```

### Start Dockge

```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/dockge
docker compose up -d
```

### Update Dockge

```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/dockge
docker compose pull
docker compose up -d
```

### View Dockge Logs

```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/dockge
docker compose logs -f
```

---

## 🐛 Troubleshooting

### Can't Access Dockge UI

**Check if container is running:**
```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/dockge
docker compose ps
```

**Check logs:**
```bash
docker compose logs dockge
```

**Restart container:**
```bash
docker compose restart
```

### Stacks Not Showing Up

**Verify stacks directory:**
```bash
ls -la /home/kyle/*/docker-compose.yml
```

**Check Dockge environment:**
```bash
docker compose exec dockge env | grep DOCKGE_STACKS_DIR
# Should show: DOCKGE_STACKS_DIR=/home/kyle
```

### Container Won't Start

**Check AppArmor config:**
```yaml
security_opt:
  - apparmor=unconfined
```

**Check Docker socket permission:**
```bash
ls -la /var/run/docker.sock
# Should be accessible
```

### Login Issues

**Reset admin password:**
```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
cd /home/kyle/dockge
# Stop container
docker compose down
# Remove data (WARNING: deletes admin account)
rm -rf data/*
# Start fresh
docker compose up -d
```

---

## 📊 Integration with Monitoring Dashboard

### How It's Integrated

The monitoring dashboard now includes a **Management Tools** section with a direct link to Dockge:

**Access:**
1. Open monitoring dashboard: http://localhost:5005
2. Look for "Management Tools" section at the top
3. Click "Dockge" card
4. Opens Dockge in new tab

**Benefits:**
- Single dashboard for all management tasks
- No need to remember Dockge URL
- Consistent interface for all tools

---

## 🎯 Benefits Over CLI

### Why Use Dockge Instead of SSH?

| Feature | Dockge UI | SSH CLI |
|---------|-----------|---------|
| **Ease of Use** | ✅ Visual interface | ❌ Command line |
| **Learning Curve** | ✅ Intuitive | ❌ Requires Docker knowledge |
| **Real-time Logs** | ✅ Auto-updating | ❌ Manual refresh |
| **Editing YAML** | ✅ Syntax highlighting | ❌ Plain text editor |
| **Multiple Stacks** | ✅ Switch between tabs | ❌ CD between directories |
| **Resource Monitoring** | ✅ Built-in graphs | ❌ Separate commands |
| **Error Prevention** | ✅ Validation | ❌ Manual checking |

**Best Use Cases:**
- **Dockge**: Daily management, quick restarts, log viewing
- **SSH**: Advanced troubleshooting, custom scripts, automation

---

## 📚 Additional Resources

**Official Documentation:**
- GitHub: https://github.com/louislam/dockge
- Website: https://dockge.kuma.pet/

**Docker Compose Reference:**
- https://docs.docker.com/compose/

**Getting Help:**
- Dockge Issues: https://github.com/louislam/dockge/issues
- Docker Documentation: https://docs.docker.com/

---

## ✅ Summary

**What You Have Now:**
- ✅ Dockge running on http://192.168.1.221:5001
- ✅ Link from monitoring dashboard
- ✅ Managing Niko TV Docker containers
- ✅ Visual interface for all Docker operations
- ✅ Real-time logs and monitoring

**Next Steps:**
1. **Access Dockge** and create admin account
2. **Explore Niko TV stack** and view containers
3. **Try restarting containers** via UI
4. **View logs** to monitor VPN status

---

**Status:** ✅ Production Ready

**Access:** http://192.168.1.221:5001

**Monitoring Dashboard:** http://localhost:5005

**Date Installed:** 2026-01-28

---

## 🔗 Related Documentation

- [VPN-STATUS-MONITORING.md](file:///home/apps/niko-tv/VPN-STATUS-MONITORING.md) - VPN monitoring features
- [MANUAL-DEPLOY-BUTTON.md](file:///home/apps/niko-tv/MANUAL-DEPLOY-BUTTON.md) - Manual deployment guide
- [HOME-PAGE-CUSTOMIZATION.md](file:///home/apps/niko-tv/HOME-PAGE-CUSTOMIZATION.md) - Customize Niko TV interface
- [PROJECT-SUMMARY.md](file:///home/apps/niko-tv/PROJECT-SUMMARY.md) - Complete project overview
