# Dev Virtual Machine
resource "yandex_compute_instance" "vm_dev" {
  name        = "vm-dev"
  platform_id = "standard-v2"
  zone        = var.zone

  resources {
    cores  = var.vm_dev_cores
    memory = var.vm_dev_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_dev_image_id
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.infra_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  labels = {
    environment = "dev"
    project     = "sausage-store"
  }
}
