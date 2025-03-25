# 🚀 Proxmox Post-Install Bootstrap for Ansible

This guide covers the minimal manual steps required after a fresh Proxmox install from ISO to prepare the host for Ansible automation.

---

## ✅ 1. Fresh Install from ISO

- Install Proxmox VE from the official ISO.
- Configure networking, timezone, and storage as usual.

---

## ✅ 2. Create a Sudo User with SSH Access

SSH into the Proxmox host (or use console) and run the following:

```bash
adduser ansibleadmin
usermod -aG sudo ansibleadmin

mkdir -p /home/ansibleadmin/.ssh
chmod 700 /home/ansibleadmin/.ssh

# Paste your public key into this file
nano /home/ansibleadmin/.ssh/authorized_keys

chmod 600 /home/ansibleadmin/.ssh/authorized_keys
chown -R ansibleadmin:ansibleadmin /home/ansibleadmin/.ssh

# install sudo
apt update
apt install sudo -y

# allow passwordless login
echo 'ansibleadmin ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ansibleadmin
chmod 0440 /etc/sudoers.d/ansibleadmin
```

## Example command

`ansible-playbook -i inventories/home-lab/hosts.yml playbooks/bootstrap_proxmox.yml`

And if you want to update the kernel or zfs:
`ansible-playbook -i inventories/home-lab/hosts.yml playbooks/dangerous-upgrades.yml`
