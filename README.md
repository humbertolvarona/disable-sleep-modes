# Sleep Mode Disabler for Debian 12

This script is designed to **disable sleep, suspend, hibernate, and similar power-saving modes** on **Debian 12 systems**, especially useful for servers that need to remain active 24/7.

## ⚠️ Warning

This script is intended for **server environments** where power-saving features are not needed. It's safe to use on dedicated servers or VPS, but it's not recommended for laptops or mobile devices.

## ✅ Script Features

- Edits `/etc/systemd/sleep.conf` to disable sleep modes.
- Masks the systemd targets: `sleep.target`, `suspend.target`, `hibernate.target`, and `hybrid-sleep.target`.
- Configures `/etc/systemd/logind.conf` to ignore events like closing the lid or pressing power buttons.
- Restarts the `systemd-logind` service to apply changes.
- Optionally removes power management packages if no GUI is in use.

## 📦 Requirements

- Operating System: **Debian 12**
- Permissions: Run with **sudo** or as root user
- Shell: Bash

## 🛠️ How to Use the Script

### 1. Make the script executable:

```bash
chmod +x disable-sleep-modes.sh
```

### 2. Run the script:

```bash
sudo ./disable-sleep-modes.sh
```

The script will display detailed messages during execution and confirm when it has finished.

## 🧪 Post-Execution Verification

You can verify that sleep modes are disabled by running:

```bash
systemctl is-enabled sleep.target suspend.target hibernate.target hybrid-sleep.target
```

If everything is configured correctly, you'll see an output like this:

```
masked
```

You can also try forcing a suspend:

```bash
sudo systemctl suspend
```

And you should receive a message similar to:

```
Failed to suspend system via logind: Operation inhibited
```

## 💬 Support and Help

Do you have questions? Need it adapted to another Linux distribution? Feel free to ask!

## 📜 License

This project is under the MIT License. You can use, modify, and distribute it freely.

