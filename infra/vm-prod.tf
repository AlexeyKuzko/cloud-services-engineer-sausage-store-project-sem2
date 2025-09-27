# Prod Virtual Machine
resource "yandex_compute_instance" "vm_prod" {
  name        = "vm-prod"
  platform_id = "standard-v2"
  zone        = var.zone

  resources {
    cores  = var.vm_prod_cores
    memory = var.vm_prod_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_prod_image_id
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.infra_subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.infra_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  labels = {
    environment = "prod"
    project     = "sausage-store"
  }
}
