locals {
  jump_host_name    = "${var.name_prefix}-jump-host"
  master_node_name  = "${var.name_prefix}-master-node"
  worker_node_name  = "${var.name_prefix}-worker-node"
}

# Создание сетки 
resource "yandex_vpc_network" "network" {
  name = "${var.name_prefix}-network"
}

# Получение публичного адреса
resource "yandex_vpc_address" "address" {
  name = "${local.jump_host_name}-address"
  external_ipv4_address {
    zone_id = var.def_yandex_zone
  }
}

resource "yandex_vpc_subnet" "subnet" {
  name              = "${var.name_prefix}-subnet"
  zone              = var.def_yandex_zone
  network_id        = yandex_vpc_network.network.id
  v4_cidr_blocks    = var.def_subnet[keys(var.def_subnet)[0]]
}



# Создание загрузочного диска для JUMP сервера
resource "yandex_compute_disk" "jump_host_boot_disk" {
  name      = "${local.jump_host_name}-boot-disk"
  zone      = var.def_yandex_zone
  image_id  = var.def_compute_image_id

  size      = var.jump_instance_resources.disk.disk_size
  type      = var.jump_instance_resources.disk.disk_type
}

# Создание загрузочного диска для MASTER ноды, таких может быть несколько
resource "yandex_compute_disk" "master_node_boot_disk" {
  count     = var.master_count

  name      = "${local.master_node_name}-boot-disk-${count.index}"
  zone      = var.def_yandex_zone
  image_id  = var.def_compute_image_id

  size      = var.master_instance_resources.disk.disk_size
  type      = var.master_instance_resources.disk.disk_type
}

# Создание загрузочного диска для WORKER ноды, таких может быть несколько
resource "yandex_compute_disk" "worker_node_boot_disk" {
  count     = var.worker_count

  name      = "${local.worker_node_name}-boot-disk-${count.index}"
  zone      = var.def_yandex_zone
  image_id  = var.def_compute_image_id

  size      = var.worker_instance_resources.disk.disk_size
  type      = var.worker_instance_resources.disk.disk_type
}


# Создание истанса JUMP сервера
resource "yandex_compute_instance" "jump_host" {
  name                      = local.jump_host_name
  allow_stopping_for_update = true
  platform_id               = var.jump_instance_resources.platform_id
  zone                      = var.def_yandex_zone

  boot_disk {
    disk_id = yandex_compute_disk.jump_host_boot_disk.id
  }

  resources {
    cores   = var.jump_instance_resources.cores
    memory  = var.jump_instance_resources.memory
  }

  network_interface {
    subnet_id       = yandex_vpc_subnet.subnet.id
    nat             = true
    nat_ip_address  = yandex_vpc_address.address.external_ipv4_address[0].address
  }

  metadata = {
    ssh-keys  = "ubuntu:${file(var.def_ssh_public_key)}"
    user-data = templatefile("${path.module}/templates/cloud-init.yaml.tftpl", {
      ssh_public_key  = file(var.def_ssh_public_key)
      hostname        = local.jump_host_name
    })
  }
}

# Создание истанса MASTER ноды, таких может быть несколько
resource "yandex_compute_instance" "master_node" {
  count                     = var.master_count # default 1

  name                      = "${local.master_node_name}-${count.index}"
  allow_stopping_for_update = true
  platform_id               = var.master_instance_resources.platform_id
  zone                      = var.def_yandex_zone

  boot_disk {
    disk_id = yandex_compute_disk.master_node_boot_disk[count.index].id
  }

  resources {
    cores   = var.master_instance_resources.cores
    memory  = var.master_instance_resources.memory
  }

  network_interface {
    subnet_id   = yandex_vpc_subnet.subnet.id
  }

  metadata = {
    ssh-keys  = "ubuntu:${file(var.def_ssh_public_key)}"
    user-data = templatefile("${path.module}/templates/cloud-init.yaml.tftpl", {
      ssh_public_key  = file(var.def_ssh_public_key)
      hostname        = "${local.master_node_name}-${count.index}"
    })
  }
}

# Создание истанса WORKER ноды, таких может быть несколько
resource "yandex_compute_instance" "worker_node" {
  count                     = var.worker_count # default 2

  name                      = "${local.worker_node_name}-${count.index}"
  allow_stopping_for_update = true
  platform_id               = var.worker_instance_resources.platform_id
  zone                      = var.def_yandex_zone

  boot_disk {
    disk_id = yandex_compute_disk.worker_node_boot_disk[count.index].id
  }

  resources {
    cores   = var.worker_instance_resources.cores
    memory  = var.worker_instance_resources.memory
  }

  network_interface {
    subnet_id   = yandex_vpc_subnet.subnet.id
  }

  metadata = {
    ssh-keys  = "ubuntu:${file(var.def_ssh_public_key)}"
    user-data = templatefile("${path.module}/templates/cloud-init.yaml.tftpl", {
      ssh_public_key  = file(var.def_ssh_public_key)
      hostname        = "${local.worker_node_name}-${count.index}"
    })
  }
}