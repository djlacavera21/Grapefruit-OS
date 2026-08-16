# Grapefruit OS

**Grapefruit OS** — A modern, modular operating system focused on sovereignty, performance, and clean design.

## Overview

Grapefruit OS is designed as a lightweight yet powerful system for developers, researchers, and empire builders who want full control over their computing environment. It emphasizes privacy, modularity, and straightforward deployment.

## Installation

### Prerequisites

- A modern x86_64 or aarch64 machine (or virtual machine)
- At least 4 GB RAM (8 GB+ recommended)
- 20 GB free disk space
- Internet connection for downloading packages (optional for offline ISO installs)

### Method 1: Live ISO (Recommended for most users)

1. Download the latest Grapefruit OS ISO from the [Releases](https://github.com/djlacavera21/Grapefruit-OS/releases) page.
2. Verify the checksum (SHA256) provided with the release.
3. Write the ISO to a USB drive using tools such as:
   - **Linux**: `dd if=Grapefruit-OS.iso of=/dev/sdX bs=4M status=progress && sync`
   - **Windows**: Rufus or balenaEtcher
   - **macOS**: balenaEtcher or `dd`
4. Boot from the USB drive.
5. Select **Install Grapefruit OS** from the live environment menu.
6. Follow the graphical (or text) installer:
   - Choose language, keyboard, and timezone
   - Partition the disk (guided or manual)
   - Create a user account
   - Confirm and begin installation
7. Reboot into your new Grapefruit OS system when finished.

### Method 2: One-Command Install Script (from an existing Linux system)

```bash
curl -fsSL https://raw.githubusercontent.com/djlacavera21/Grapefruit-OS/main/scripts/install.sh | bash
```

This script will:
- Detect your hardware
- Download the necessary base system packages
- Set up the Grapefruit package repositories
- Install the core system and optional desktop environment
- Configure bootloader and basic services

**Note**: Run this only on a system you are prepared to modify or in a dedicated partition/VM.

### Method 3: Docker / Container Image (for testing & development)

```bash
docker pull ghcr.io/djlacavera21/grapefruit-os:latest
docker run -it --name grapefruit ghcr.io/djlacavera21/grapefruit-os:latest
```

Or using Docker Compose (recommended):

```bash
git clone https://github.com/djlacavera21/Grapefruit-OS.git
cd Grapefruit-OS
docker compose up -d
```

### Method 4: Build from Source

```bash
git clone https://github.com/djlacavera21/Grapefruit-OS.git
cd Grapefruit-OS
./scripts/build.sh
```

This will produce a custom ISO or root filesystem that can be installed using the methods above.

## Post-Installation

After first boot:

1. Update the system:
   ```bash
   sudo grapefruit-update
   ```
2. Install additional packages as needed:
   ```bash
   sudo grapefruit-install <package>
   ```
3. (Optional) Enable the recommended desktop environment or window manager.

## Documentation

Further documentation, architecture notes, and contribution guidelines will be added as the project develops.

## License

To be determined (likely a permissive or strong copyleft license).

---

*Grapefruit OS is under active development. Contributions, feedback, and issue reports are welcome.*
