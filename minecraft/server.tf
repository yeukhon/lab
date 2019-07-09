resource "digitalocean_tag" "droplet_name_tag" {
  name = "minecraft"
}

resource "digitalocean_ssh_key" "minecraft_ssh_key" {
  name       = "minecraft_ssh_key"
  public_key = "${file("${path.cwd}/data_store/server.pub")}"
}

resource "digitalocean_droplet" "minecraft" {
  image     = "ubuntu-18-04-x64"
  name      = "minecraft"
  region    = "nyc3"
  size      = "s-2vcpu-2gb"
  ssh_keys  = ["${digitalocean_ssh_key.minecraft_ssh_key.id}"]
  backups   = true
  tags   = [
    "${digitalocean_tag.droplet_name_tag.name}",
  ]
}
