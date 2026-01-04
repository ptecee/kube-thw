# Переменные для провайдера
variable "yandex_token" {
  description   = "Yandex OAuth token"
  type          = string
  sensitive     = true
}

variable "yandex_cloud_id" {
  description   = "Yandex Cloud ID"
  type          = string

}

variable "yandex_folder_id" {
  description   = "Yandex Folder ID"
  type          = string
}

# Дефолтные значения ресурсов
variable "def_yandex_zone" {
  description   = "Default Yandex cloud zone"
  type          = string
  default       = "ru-central1-a"
}

variable "def_compute_image_id" {
  description   = "Default image for compute instatces: Ubuntu 22.04 LTS"
  type          = string
  default       = "fd8ba9d5mfvlncknt2kd"
}

# Дефолтные ssh ключи
variable "def_ssh_public_key" {
  description   = "Default ssh public key for access to servers"
  type          = string
  default       = "~/.ssh/yc.pub"
}

variable "def_ssh_private_key" {
  description   = "Default ssh private key for access to servers"
  type          = string
  default       = "~/.ssh/yc"
}

# Одна дефолтная подсеть на 12 адресов
variable "def_subnet" {
  description = "A map of subnet names to their CIDR block ranges."
  type        = map(list(string))
  default = {
    "default-subnet" = [ "192.168.10.0/28" ]
  }
}

# Объявим префкикс для объектов которые будем создавать для кластера
variable "name_prefix" {
  description = "Prefix for cluster resourses"
  type        = string
  default     = "kube"
}


# Дефолтные ресурсы для JUMP сервера
variable "jump_instance_resources" {
  description = "Resources for jumphost server"
  type = object({
    cores       = number
    memory      = number
    platform_id  = optional(string, "standard-v3")
    disk = optional(object({
        disk_type = optional(string, "network-ssd")
        disk_size = optional(number, 10)
    }), {})
  })
}

# Дефолтные ресурсы для MASTER нод
variable "master_instance_resources" {
  description = "Resources for master node server"
  type = object({
    cores       = number
    memory      = number
    platform_id  = optional(string, "standard-v3")
    disk = optional(object({
        disk_type = optional(string, "network-ssd")
        disk_size = optional(number, 20)
    }), {})
  })
}

# Дефолтные ресурсы для WORKER нод
variable "worker_instance_resources" {
  description = "Resources for worker node server"
  type = object({
    cores       = number
    memory      = number
    platform_id  = optional(string, "standard-v3")
    disk = optional(object({
        disk_type = optional(string, "network-ssd")
        disk_size = optional(number, 20)
    }), {})
  })
}


# Количество MASTER нод
variable "master_count" {
  description = "Default count of Master nodes"
  type        = number
  default     = 1

#  validation {
#    condition = var.master_count < 1
#    error_message = "Master count must be at least 1"
#  }
}

# Количество WORKER нод
variable "worker_count" {
  description = "Default count of Worker nodes"
  type        = number
  default     = 2

#  validation {
#    condition = var.worker_count < 1
#    error_message = "Worker count must be at least 1"
#  }
}