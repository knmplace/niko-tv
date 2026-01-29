# Enable TUN Support for Niko TV Container (Proxmox LXC)

## Problem
The niko-tv server (192.168.1.221) is a Proxmox LXC container that needs TUN device access for the Gluetun VPN container to work.

## Solution

### Step 1: Find Container ID
SSH into your Proxmox host and find the container ID:
```bash
pct list | grep 192.168.1.221
```

Or check the container name/hostname:
```bash
pct list
```

### Step 2: Enable TUN Device Access + Sysctl Permissions
Once you have the container ID (let's say it's 100), run these commands on the Proxmox host:

```bash
# Stop the container
pct stop 100

# Edit the container configuration file
nano /etc/pve/lxc/100.conf

# Add these lines at the end of the file:
# TUN Device Support for VPN (Gluetun)
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file

# Allow sysctl modifications (needed for Gluetun VPN)
lxc.apparmor.profile: unconfined
lxc.cap.drop:
lxc.mount.auto: proc:rw sys:rw

# Alternative: Make container privileged (less secure but simpler)
# unprivileged: 0

# Save and exit (Ctrl+X, Y, Enter)

# Start the container
pct start 100
```

**Quick one-liner (use carefully):**
```bash
pct stop 100 && \
echo -e "\nlxc.cgroup2.devices.allow: c 10:200 rwm\nlxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file\nlxc.apparmor.profile: unconfined\nlxc.cap.drop:\nlxc.mount.auto: proc:rw sys:rw" >> /etc/pve/lxc/100.conf && \
pct start 100
```

### Step 3: Verify TUN Device Works
SSH back into the container and test:
```bash
ssh kyle@192.168.1.221
cat /dev/net/tun
# Should NOT show "File descriptor in bad state" anymore
```

### Step 4: Start Docker Containers
Once TUN is working:
```bash
cd /home/kyle/niko-tv/niko-tv
docker compose up -d
```

---

## Alternative: Use Privileged Container

If the above doesn't work, you can make the entire container privileged (less secure but simpler):

```bash
# On Proxmox host
pct set 100 -features nesting=1
pct stop 100
pct start 100
```

---

## Alternative: Convert to VM

If LXC TUN support is problematic, consider converting this container to a full VM, which has native TUN support.

---

## Quick Command Reference

**On Proxmox Host:**
```bash
# Find container ID
pct list

# Edit container config
nano /etc/pve/lxc/CTID.conf

# Restart container
pct stop CTID && pct start CTID
```

**Inside Container (after fix):**
```bash
# Test TUN device
cat /dev/net/tun

# Start Docker containers
cd /home/kyle/niko-tv/niko-tv
docker compose up -d

# Watch Gluetun logs for VPN connection
docker compose logs -f gluetun
```

---

## Contact Info
- Container IP: 192.168.1.221
- Container Hostname: tv (likely)
- Kernel: 6.5.13-6-pve (Proxmox VE)
