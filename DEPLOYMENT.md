# Niko TV - Deployment Guide

## Overview

This guide explains how to manage and deploy Niko TV to the remote server.

**Remote Server:** kyle@192.168.1.221
**Dev Environment:** Port 3010
**Prod Environment:** Port 3011 (future)

---

## Quick Start

### Deploy Changes
```bash
./deploy.sh
```
This will:
1. Commit and push your changes to GitHub
2. Pull changes on the remote server
3. Install dependencies if needed
4. Restart the application with PM2

### Manage Application
```bash
./manage.sh status    # Check app status
./manage.sh logs      # View live logs
./manage.sh restart   # Restart app
./manage.sh stop      # Stop app
./manage.sh start     # Start app
./manage.sh ssh       # SSH into server
```

---

## Project Structure

```
/home/apps/niko-tv/          # Local development (this environment)
  ├── deploy.sh              # Deployment script
  ├── manage.sh              # Remote management script
  ├── .env.deployment        # Deployment configuration
  └── [app files]

/home/kyle/niko-tv/          # Remote production server
  ├── .env                   # Environment variables (PORT=3010)
  └── [app files]
```

---

## Workflow

### 1. Make Changes Locally

Edit files in `/home/apps/niko-tv/` on this machine.

### 2. Test Locally (Optional)

```bash
npm install
PORT=3010 npm start
```

### 3. Deploy to Remote

```bash
./deploy.sh
```

The script will:
- Commit your changes
- Push to GitHub
- Pull on remote server
- Restart the app

### 4. Verify Deployment

```bash
./manage.sh status
```

Or visit: http://192.168.1.221:3010

---

## Configuration

### Dev Environment (.env on remote)
```
NODE_ENV=development
PORT=3010
```

### Production Environment (future)
```
NODE_ENV=production
PORT=3011
```

---

## Remote Server Access

### SSH with Password
```bash
ssh kyle@192.168.1.221
# Password: Peaches1090!
```

### SSH with Key (Used by Scripts)
```bash
ssh -i /root/.ssh/niko_tv_deploy kyle@192.168.1.221
```

### PM2 Commands on Remote
```bash
pm2 status              # Check status
pm2 logs niko-tv-dev    # View logs
pm2 restart niko-tv-dev # Restart app
pm2 stop niko-tv-dev    # Stop app
pm2 start niko-tv-dev   # Start app
```

---

## Troubleshooting

### App won't start
```bash
./manage.sh logs        # Check error logs
./manage.sh ssh         # SSH and debug
cd ~/niko-tv
npm install             # Reinstall dependencies
pm2 restart niko-tv-dev
```

### Port already in use
```bash
./manage.sh ssh
sudo lsof -i :3010      # Find process using port
pm2 delete niko-tv-dev  # Remove PM2 process
pm2 start server/index.js --name niko-tv-dev
```

### Git conflicts
```bash
./manage.sh ssh
cd ~/niko-tv
git status
git stash               # Save local changes
git pull                # Pull latest
```

---

## Future: Production Setup

When ready for production on port 3011:

1. Create production .env:
```bash
./manage.sh ssh
cd ~/niko-tv
echo "NODE_ENV=production
PORT=3011" > .env.production
```

2. Start production instance:
```bash
pm2 start server/index.js --name niko-tv-prod --env production
pm2 save
```

3. Use reverse proxy (nginx/caddy) for domain mapping.

---

## Access URLs

- **Dev:** http://192.168.1.221:3010
- **Prod (future):** http://192.168.1.221:3011

---

## Support

For issues or questions about deployment, check:
1. PM2 logs: `./manage.sh logs`
2. SSH access: `./manage.sh ssh`
3. GitHub repo: https://github.com/knmplace/niko-tv
