# VPC Network
resource "yandex_vpc_network" "infra_network" {
  name = "infra-network"
}

# VPC Subnet
resource "yandex_vpc_subnet" "infra_subnet" {
  name           = "infra-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.infra_network.id
  v4_cidr_blocks = ["10.2.0.0/16"]
}

# Security Group
resource "yandex_vpc_security_group" "infra_sg" {
  name       = "infra-security-group"
  network_id = yandex_vpc_network.infra_network.id

  # Allow all outbound traffic
  egress {
    protocol       = "ANY"
    description    = "Allow all outbound traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH (port 22)
  ingress {
    protocol       = "TCP"
    description    = "Allow SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  # Allow HTTP (port 8200)
  ingress {
    protocol       = "TCP"
    description    = "Allow HTTP on port 8200"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 8200
  }
}
