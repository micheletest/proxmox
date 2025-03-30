source "null" "noop" {
  communicator = "none"
}

variable "proxmox_host" {
  type    = string
  default = "192.168.88.33"
}

variable "ssh_user" {
  type    = string
  default = "root"
}

build {
  name    = "lxc-template-builder"
  sources = ["source.null.noop"]

  provisioner "shell-local" {
    inline = [
      "echo '🚀 Copying script to Proxmox…'",
      "scp scripts/build-lxc-template.sh ${var.ssh_user}@${var.proxmox_host}:/tmp/build-lxc-template.sh",
      "echo '🔧 Executing build script on Proxmox…'",
      "ssh ${var.ssh_user}@${var.proxmox_host} 'bash /tmp/build-lxc-template.sh'"
    ]
  }
}
