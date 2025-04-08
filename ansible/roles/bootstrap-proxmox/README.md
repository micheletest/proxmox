# 🚀 Proxmox Post-Install Bootstrap for Ansible

This guide covers the minimal manual steps required after a fresh Proxmox install from ISO to prepare the host for Ansible automation.

---

## 1. Fresh Install from ISO

- Install Proxmox VE from the official ISO.
- Configure networking, timezone, and storage as usual.

---

## 2. Create an ansible_node_admin user that can perform node package maintenance

- Create the user

```bash
adduser --gecos 'Ansible Node Admin' ansible_node_admin
passwd ansible_node_admin  # Set a strong password
```

- Set up ssh
  `ssh-copy-id -i ~/.ssh/id_rsa.pub ansible_node_admin@your_proxmox_node_ip`

- Add the sudo package

```bash
apt update  # Update the package lists
apt install sudo -y # Install sudo without prompting for confirmation
```

- add the user to the sudo group
  `usermod -aG sudo ansible_node_admin`

- log into ssh as ansible_node_admin and set specific permissions
  `sudo visudo`

  - Add a file

  `sudo vim /etc/sudoers.d/ansible_file`

  - contents:

  ```bash
  ansible_node_admin ALL = (root) NOPASSWD: ALL
  ```

  - chmod it
    `sudo chmod 0440 /etc/sudoers.d/ansible_file`

## 3. Create an api user that can manage LXC and VMs

- Create the API User (if it doesn't exist): Log in to your Proxmox web interface. Navigate to Datacenter -> Users and click Add. Create a user named ansible_api (or your preferred name). You can disable "Expire" if you want the user to be active indefinitely.
  -Create API Tokens: Navigate to Datacenter -> Permissions -> API Tokens and click Add.

- User: Select the ansible_api user you created.
- Privilege separation: Choose whether to inherit privileges or define specific ones. For security, it's generally better to define specific privileges.
- Permissions: Grant the necessary permissions for managing VMs and LXCs. This might include: VM.Allocate, VM.Clone, VM.Config.CPU, VM.Config.Disk, VM.Config.HWType, VM.Config.Memory, VM.PowerMgmt, VM.Monitor (for VMs) LXC.Create, LXC.Config, LXC.PowerMgmt, LXC.Monitor (for LXCs)

- Go to Permissions: Expand the "Permissions" section under "Datacenter" and click on "Permissions". This will show you the Access Control List (ACL) for the entire Proxmox environment.

  - Click "Add": In the top right of the Permissions view, click the "Add" button.

  -Configure the Permission: A new window will appear where you can define the permission:

  - root /
  - choose `PVEVMAdmin`

## 4.Modify the default repository and apply updates

`ansible-playbook -i inventories/home-lab/hosts.yml playbooks/bootstrap_proxmox.yml`

And if you want to update the kernel or zfs:

`ansible-playbook -i inventories/home-lab/hosts.yml playbooks/dangerous_upgrades.yml`
