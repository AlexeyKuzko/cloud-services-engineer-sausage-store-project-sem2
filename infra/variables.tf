variable "yc_token" {
  description = "Yandex Cloud OAuth token"
  type        = string
  sensitive   = true
}

variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "zone" {
  description = "Yandex Cloud zone"
  type        = string
  default     = "ru-central1-a"
}

variable "project_id" {
  description = "GitLab Project ID"
  type        = string
}

variable "vm_dev_image_id" {
  description = "Image ID for dev VM"
  type        = string
  default     = "fd8kdq6d0p8sij7h5qe3" # Ubuntu 20.04 LTS
}

variable "vm_prod_image_id" {
  description = "Image ID for prod VM"
  type        = string
  default     = "fd8kdq6d0p8sij7h5qe3" # Ubuntu 20.04 LTS
}

variable "vm_dev_cores" {
  description = "Number of cores for dev VM"
  type        = number
  default     = 2
}

variable "vm_prod_cores" {
  description = "Number of cores for prod VM"
  type        = number
  default     = 2
}

variable "vm_dev_memory" {
  description = "Memory for dev VM in GB"
  type        = number
  default     = 4
}

variable "vm_prod_memory" {
  description = "Memory for prod VM in GB"
  type        = number
  default     = 4
}
