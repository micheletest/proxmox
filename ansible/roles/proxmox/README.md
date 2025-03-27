# 🚀 Proxmox Post-Install Bootstrap for Ansible

This guide covers the minimal manual steps required after a fresh Proxmox install from ISO to prepare the host for Ansible automation.

---

## ✅ 1. Fresh Install from ISO

- Install Proxmox VE from the official ISO.
- Configure networking, timezone, and storage as usual.

---

## ✅ 2. Create a Sudo User with SSH Access

`ansible-playbook -i inventories/home-lab/hosts.yml playbooks/bootstrap_ansible_user.yml`

## ✅ 3.Modify the default repository and apply updates

`ansible-playbook -i inventories/home-lab/hosts.yml playbooks/bootstrap_proxmox.yml`

And if you want to update the kernel or zfs:

`ansible-playbook -i inventories/home-lab/hosts.yml playbooks/dangerous-upgrades.yml`
