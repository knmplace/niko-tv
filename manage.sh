#!/bin/bash

# Niko TV Docker Remote Management Script
# Usage: ./manage.sh [command]
# Commands: status, logs, restart, stop, start, rebuild, vpn-status

set -e

# Load environment variables
source .env.deployment

COMMAND=${1:-status}

case $COMMAND in
    status)
        echo "📊 Checking Niko TV Docker status..."
        ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST "cd $REMOTE_PATH && docker compose ps"
        ;;

    logs)
        echo "📋 Streaming logs (Ctrl+C to exit)..."
        CONTAINER=${2:-niko-tv}
        echo "Container: $CONTAINER"
        ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST "cd $REMOTE_PATH && docker compose logs -f --tail=100 $CONTAINER"
        ;;

    restart)
        echo "🔄 Restarting Niko TV containers..."
        ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST "cd $REMOTE_PATH && docker compose restart"
        echo "✅ Containers restarted"
        ;;

    stop)
        echo "🛑 Stopping Niko TV containers..."
        ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST "cd $REMOTE_PATH && docker compose down"
        echo "✅ Containers stopped"
        ;;

    start)
        echo "▶️  Starting Niko TV containers..."
        ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST "cd $REMOTE_PATH && docker compose up -d"
        echo "✅ Containers started"
        ;;

    rebuild)
        echo "🔨 Rebuilding and restarting containers..."
        ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST "cd $REMOTE_PATH && docker compose down && docker compose build --no-cache && docker compose up -d"
        echo "✅ Rebuild complete"
        ;;

    vpn-status)
        echo "🌐 Checking VPN status..."
        ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST "cd $REMOTE_PATH && docker compose logs gluetun | grep -E 'Public IP|connected|healthy' | tail -10"
        ;;

    ssh)
        echo "🔐 Connecting to remote server..."
        ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST
        ;;

    *)
        echo "Usage: ./manage.sh [command] [options]"
        echo ""
        echo "Commands:"
        echo "  status        - Show Docker container status"
        echo "  logs [name]   - Stream container logs (default: niko-tv, options: gluetun, niko-tv)"
        echo "  restart       - Restart all containers"
        echo "  stop          - Stop all containers"
        echo "  start         - Start all containers"
        echo "  rebuild       - Rebuild and restart containers"
        echo "  vpn-status    - Check VPN connection status"
        echo "  ssh           - SSH into remote server"
        exit 1
        ;;
esac
