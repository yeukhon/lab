resource "digitalocean_tag" "droplet_name_tag" {
  name = "yeukhon_me"
}

resource "digitalocean_tag" "droplet_creation_date" {
  name = "2018-03-08"
}

resource "digitalocean_ssh_key" "yeukhon_me_ssh_key" {
  name       = "yeukhon_me_ssh_key"
  public_key = "${file("${path.cwd}/data_store/server.pub")}"
}

resource "digitalocean_droplet" "yeukhon_me" {
  image     = "ubuntu-16-04-x64"
  name      = "yeukhonme"
  region    = "nyc3"
  size      = "1gb"
  ssh_keys  = ["${digitalocean_ssh_key.yeukhon_me_ssh_key.id}"]
  backups   = true
  ipv6      = true
  tags   = [
    "${digitalocean_tag.droplet_name_tag.name}",
    "${digitalocean_tag.droplet_creation_date.name}"
  ]
}
