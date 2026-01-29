#!/bin/bash

# Niko TV Docker Deployment Script
# This script deploys local changes to the remote server

set -e  # Exit on error

# Load environment variables
source .env.deployment

# Log file
LOGFILE="logs/deployment.log"
mkdir -p logs

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

log "=========================================="
log "🚀 Starting Niko TV Docker Deployment"
log "Remote: $REMOTE_USER@$REMOTE_HOST"
log "=========================================="

# 1. Commit and push to GitHub (if there are changes)
log "📝 Checking for local changes..."
if [[ -n $(git status -s) ]]; then
    log "   Changes detected. Committing..."
    git add .
    read -p "   Enter commit message: " commit_msg
    git commit -m "$commit_msg" 2>&1 | tee -a "$LOGFILE"
    git push origin main 2>&1 | tee -a "$LOGFILE"
    log "   ✅ Pushed to GitHub"
else
    log "   No local changes to commit"
fi

# 2. Pull changes on remote server
log "🔄 Pulling latest changes on remote server..."
ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST << ENDSSH 2>&1 | tee -a "$LOGFILE"
cd $REMOTE_PATH
git pull origin main
echo "✅ Code updated"
ENDSSH
log "✅ Remote code updated"

# 3. Rebuild and restart Docker containers
log "🐳 Rebuilding Docker containers..."
ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST << ENDSSH 2>&1 | tee -a "$LOGFILE"
cd $REMOTE_PATH
docker compose pull
docker compose up -d --build
echo "✅ Containers rebuilt and restarted"
ENDSSH

# 4. Verify deployment
log "✅ Verifying deployment..."
sleep 10
ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST << ENDSSH 2>&1 | tee -a "$LOGFILE"
cd $REMOTE_PATH
docker compose ps
echo ""
echo "=== VPN Status ==="
docker compose logs gluetun | grep -E "Public IP|healthy" | tail -3
ENDSSH

log ""
log "✅ Deployment complete!"
log "🌐 Access at: http://$REMOTE_HOST:3000"
log "=========================================="
