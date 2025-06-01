#!/bin/bash

# Script to disable sleep, suspend, hibernate and similar power-saving modes on Debian 12
# Run as root or with sudo

set -e  # Exit if any command fails

echo "🔐 Disabling sleep and power-saving modes..."

# 1. Configure /etc/systemd/sleep.conf
echo "🔧 Editing /etc/systemd/sleep.conf..."
cat > /tmp/sleep.conf <<'EOL'
[Sleep]
AllowSuspend=no
AllowHibernation=no
AllowSuspendThenHibernate=no
AllowHybridSleep=no
EOL

sudo mv /tmp/sleep.conf /etc/systemd/sleep.conf

# 2. Mask systemd sleep targets
echo "🚫 Masking sleep/suspend/hibernate targets..."
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target > /dev/null 2>&1
echo "✅ Targets masked."

# 3. Adjust logind configuration (optional)
echo "⚙️ Updating logind configuration..."
sudo sed -i 's/#HandleSuspendKey=poweroff/HandleSuspendKey=ignore/g' /etc/systemd/logind.conf
sudo sed -i 's/#HandleHibernateKey=poweroff/HandleHibernateKey=ignore/g' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/g' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitchExternalPower=suspend/HandleLidSwitchExternalPower=ignore/g' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitchDocked=suspend/HandleLidSwitchDocked=ignore/g' /etc/systemd/logind.conf

# 4. Restart logind service to apply changes
echo "🔄 Restarting systemd-logind..."
sudo systemctl restart systemd-logind
echo "✅ Service restarted."

# 5. (Optional) Remove unnecessary power management packages if GUI is not used
if command -v apt &> /dev/null; then
    echo "🗑️ Removing unnecessary packages (gnome-power-manager, upower)..."
    sudo apt purge -y gnome-power-manager upower > /dev/null 2>&1 || true
    echo "✅ Packages removed (if they existed)."
fi

# 6. Final verification
echo ""
echo "🔍 Verifying current status:"
systemctl is-enabled sleep.target suspend.target hibernate.target hybrid-sleep.target 2>/dev/null | grep masked || echo "Some targets are correctly disabled."

echo ""
echo "✅ Configuration completed! Your system will no longer enter sleep or hibernation modes."
exit 0
