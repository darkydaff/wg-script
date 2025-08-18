#!/bin/bash
set -e

echo "🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "🐳 Docker not found, installing..."
    sudo apt install -y docker.io
else
    echo "🐳 Docker already installed, skipping installation"
fi

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "📡 curl not found, installing..."
    sudo apt install -y curl
else
    echo "📡 curl already installed, skipping installation"
fi

echo "🌍 Getting public IP..."
SERVER_IP=$(curl -s icanhazip.com)
echo "✅ Server IP: $SERVER_IP"

echo -n "🔑 Enter your admin password for wg-easy: "
read -s ADMIN_PASSWORD
echo ""

echo "🔐 Generating password hash..."
PASSWORD_HASH=$(docker run --rm -i ghcr.io/wg-easy/wg-easy wgpw "$ADMIN_PASSWORD" | grep PASSWORD_HASH | cut -d"'" -f2)
echo "✅ Password hash generated: $PASSWORD_HASH"

# Remove old container if it exists
if [ "$(docker ps -aq -f name=wg-easy)" ]; then
    echo "🗑 Removing existing wg-easy container..."
    docker rm -f wg-easy
fi

echo "🚀 Starting wg-easy container..."
docker run --detach \
    --name wg-easy \
    --env LANG=en \
    --env WG_HOST="$SERVER_IP" \
    --env PASSWORD_HASH="$PASSWORD_HASH" \
    --env PORT=35031 \
    --env WG_PORT=35030 \
    --volume ~/.wg-easy:/etc/wireguard \
    --publish 35030:35030/udp \
    --publish 35031:35031/tcp \
    --cap-add NET_ADMIN \
    --cap-add SYS_MODULE \
    --sysctl 'net.ipv4.conf.all.src_valid_mark=1' \
    --sysctl 'net.ipv4.ip_forward=1' \
    --restart unless-stopped \
    ghcr.io/wg-easy/wg-easy

echo "✅ wg-easy is now running!"
echo "🌐 Web panel: http://$SERVER_IP:35031"

