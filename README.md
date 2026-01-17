# wg-script

Automated setup script for [wg-easy](https://github.com/wg-easy/wg-easy), a simple WireGuard VPN server with an easy-to-use web interface.

**🇺🇦 [Українською мовою](README.uk.md)**

## 📋 Overview

This script automates the installation and configuration of wg-easy on a Linux server. It handles:
- System updates
- Docker installation (if not present)
- curl installation (if not present)
- Automatic public IP detection
- Secure password hash generation
- Docker container setup with proper networking and permissions

## 🚀 Quick Start

### Prerequisites

- Ubuntu/Debian-based Linux system
- sudo privileges
- Internet connection

### Installation

Download and run the script:

```bash
curl -O https://raw.githubusercontent.com/darkydaff/wg-script/refs/heads/main/setup-wg.sh
chmod +x setup-wg.sh
sudo ./setup-wg.sh
```

Or run directly:

```bash
bash <(curl -s https://raw.githubusercontent.com/darkydaff/wg-script/refs/heads/main/setup-wg.sh)
```

### What the Script Does

1. **Updates the system** - Runs `apt update && apt upgrade`
2. **Installs Docker** - Installs Docker if not already present
3. **Installs curl** - Installs curl if not already present
4. **Detects Public IP** - Automatically retrieves your server's public IP address
5. **Password Setup** - Prompts for an admin password and generates a secure hash
6. **Container Management** - Removes any existing wg-easy container and starts a new one
7. **Configuration** - Sets up the container with:
   - Web panel on port **35031** (TCP)
   - WireGuard on port **35030** (UDP)
   - Persistent storage at `~/.wg-easy`
   - Auto-restart on system reboot

## 🔧 Configuration

The script configures wg-easy with the following settings:

- **Web Panel Port**: `35031` (TCP)
- **WireGuard Port**: `35030` (UDP)
- **Data Directory**: `~/.wg-easy` (persistent volume)
- **Container Name**: `wg-easy`
- **Auto-restart**: Enabled (`unless-stopped`)

## 🌐 Accessing the Web Panel

After running the script, you'll see output like:

```
✅ wg-easy is now running!
🌐 Web panel: http://YOUR_SERVER_IP:35031
```

Access the web panel at `http://YOUR_SERVER_IP:35031` using the admin password you set during installation.

## 🔒 Security Notes

- The script uses `read -s` to securely input your password (hidden input)
- Password is hashed using wg-easy's built-in hashing function
- Make sure to open ports 35030 (UDP) and 35031 (TCP) in your firewall
- Consider restricting access to port 35031 to trusted IPs only

## 📦 Firewall Configuration

If you're using UFW, allow the required ports:

```bash
sudo ufw allow 35030/udp
sudo ufw allow 35031/tcp
```

## 🛠️ Managing the Container

### Stop the container:
```bash
docker stop wg-easy
```

### Start the container:
```bash
docker start wg-easy
```

### View logs:
```bash
docker logs wg-easy
```

### Remove the container (data persists in ~/.wg-easy):
```bash
docker rm -f wg-easy
```

## 📝 Notes

- The script uses `set -e` to exit on any error
- Existing wg-easy containers are automatically removed before creating a new one
- WireGuard configuration files are stored in `~/.wg-easy` and persist across container restarts
- The container requires `NET_ADMIN` and `SYS_MODULE` capabilities for WireGuard functionality

## 🔗 Links

- [wg-easy GitHub Repository](https://github.com/wg-easy/wg-easy)
- [WireGuard Documentation](https://www.wireguard.com/)

## 📄 License

See the LICENSE file in the repository root for license information.
