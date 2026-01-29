# Niko TV - Monitoring Integration

## Overview

Niko TV has been successfully integrated into the KNM Monitoring Dashboard at `/home/apps/monitoring`.

The monitoring dashboard now tracks:
- **Demosite** - KNM Place Community Apps (localhost)
- **KNM Monitoring** - The monitoring dashboard itself (localhost)
- **Niko TV** - IPTV Player (192.168.1.221 - Remote Server) ⭐ NEW

---

## Access Monitoring Dashboard

**URL:** http://localhost:5005

The dashboard provides:
- Real-time PM2 process monitoring
- Health check status
- System metrics
- Log viewing
- Deployment history

---

## What Was Configured

### 1. Monitoring Config Updated

File: [/home/apps/monitoring/config/projects.ts](../monitoring/config/projects.ts)

Added Niko TV configuration:
```typescript
{
  id: 'niko-tv',
  name: 'Niko TV',
  description: 'Modern IPTV player with live TV, EPG, movies, and series support (Remote Server)',
  pm2Processes: ['niko-tv-dev'],
  systemdServices: [],
  ports: [3010],
  logPaths: {
    pm2: '/home/apps/niko-tv/logs',
    deployment: '/home/apps/niko-tv/logs/deployment.log',
    webhook: '/home/apps/niko-tv/logs/webhook.log',
  },
  healthCheckUrl: 'http://192.168.1.221:3010',
  isRemote: true,
  remoteHost: '192.168.1.221',
}
```

### 2. Deployment Logging

The [deploy.sh](deploy.sh) script now logs all deployment activity to:
- `logs/deployment.log` - Complete deployment history with timestamps

Example log entry:
```
[2026-01-27 18:45:12] ==========================================
[2026-01-27 18:45:12] 🚀 Starting Niko TV Deployment
[2026-01-27 18:45:12] Remote: kyle@192.168.1.221
[2026-01-27 18:45:12] ==========================================
[2026-01-27 18:45:13] 📝 Checking for local changes...
[2026-01-27 18:45:13]    No local changes to commit
[2026-01-27 18:45:14] 🔄 Pulling latest changes on remote server...
[2026-01-27 18:45:15] ✅ Remote code updated
[2026-01-27 18:45:16] ✅ Deployment complete!
```

### 3. Log Directory Structure

```
/home/apps/niko-tv/logs/
├── deployment.log    # Deployment history
└── webhook.log       # Future webhook events
```

---

## Monitoring Features

### For Niko TV (Remote Server)

The monitoring dashboard can track:
- ✅ **Health Check** - HTTP ping to http://192.168.1.221:3010
- ✅ **Deployment History** - View logs/deployment.log
- ⚠️ **PM2 Status** - Requires remote PM2 monitoring setup (future enhancement)

### Current Limitations

Since Niko TV runs on a **remote server** (192.168.1.221), the following are limited:
- PM2 process metrics (requires SSH tunneling or PM2 remote monitoring)
- Real-time log streaming (local logs only)

### Future Enhancements

To get full monitoring capabilities for remote Niko TV:

1. **Option 1: PM2 Remote Monitoring**
   - Set up PM2 monitoring on remote server
   - Connect via SSH tunnel or PM2 Keymetrics

2. **Option 2: Health Check Endpoint**
   - Add `/health` endpoint to Niko TV
   - Returns PM2 status, uptime, memory usage

3. **Option 3: Log Aggregation**
   - Use rsync to sync remote logs locally
   - View remote logs in monitoring dashboard

---

## How to Use

### View Monitoring Dashboard

1. Open browser: http://localhost:5005
2. Navigate to "Projects" section
3. See Niko TV status along with other projects

### Check Niko TV Health

The dashboard automatically checks:
```
http://192.168.1.221:3010
```

If the server responds with HTTP 200, it shows as "Healthy ✅"

### View Deployment History

From monitoring dashboard:
1. Click on "Niko TV" project
2. View "Deployment Logs" section
3. See complete deployment history with timestamps

Or manually:
```bash
cd /home/apps/niko-tv
tail -f logs/deployment.log
```

---

## Monitoring Dashboard Structure

```
/home/apps/monitoring/
├── config/
│   └── projects.ts           # Project definitions (includes Niko TV)
├── app/
│   └── api/                  # API endpoints for monitoring
├── components/               # UI components
└── .env.local               # Configuration (auth, firebase, etc.)
```

---

## All Projects Being Monitored

| Project | Location | Port | Status |
|---------|----------|------|--------|
| **Demosite** | localhost | 3000, 9000 | ✅ Online |
| **KNM Monitoring** | localhost | 5005 | ✅ Online |
| **Niko TV** | 192.168.1.221 | 3010 | ✅ Online |

---

## Quick Commands

### View All Logs
```bash
# Niko TV deployment logs
tail -f /home/apps/niko-tv/logs/deployment.log

# Monitoring dashboard logs
pm2 logs knm-monitoring
```

### Restart Monitoring Dashboard
```bash
pm2 restart knm-monitoring
```

### Deploy Niko TV (triggers logging)
```bash
cd /home/apps/niko-tv
./deploy.sh
```

---

## Support

- Monitoring Dashboard: http://localhost:5005
- Niko TV: http://192.168.1.221:3010
- Deployment Logs: [/home/apps/niko-tv/logs/deployment.log](logs/deployment.log)
