# PACKER FILES

Packer is good at building LXC and VMS. This will help use build them and store on proxmox so they can be cloned. This currently creates a debian lxc for use in automation.

## USAGE

```bash
cd packer lxc
packer init .
packer build lxc-builder.pkr.hcl
```

You should see a CT template on the host machine now.
