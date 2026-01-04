# KUBE THE HARD WAY

Данная terraform конфигурация разворвачивает в Yandex Cloud 4 виртуальные машины, для создания базового кластера kubernetes в рамках гайда [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way/tree/master).  
Параметры и количество master и worker нод - можно конфигурировать через файл `terraform.tfvars`.  
> [!warning] Выполнение данной конфигурации подразумевает наличие уже созданного аккаунта Yandex Cloud и наличие утилиты  Yandex Cloud CLI.

Перед применением конфигурации нужно создать файл `terraform.tfvars`. Содержимое файла `terraform.tfvars`:
```tf
yandex_token        = <yc iam create-token>     # значения получить с помощью утилиты yc
yandex_cloud_id     = <yc config get cloud-id>  # значения получить с помощью утилиты yc
yandex_folder_id    = <yc config get folder-id> # значения получить с помощью утилиты yc

# yandex clpud не поддерживает мин. конфигурацию менее чем 2 ядра и 2 гига
jump_instance_resources = {
  cores  = 2
  memory = 2
  # disk = {
  #   disk_size = 10            # default
  #   disk_type = "network-ssd" # default
  # }
}

master_instance_resources = {
  cores  = 2
  memory = 4
  # disk = {
  #   disk_size = 20            # default
  #   disk_type = "network-ssd" # default
  # }
}

worker_instance_resources = {
  cores  = 2
  memory = 4
  # disk = {
  #   disk_size = 20            # default
  #   disk_type = "network-ssd" # default
  # }
}
```


Комманды Terraform:
```shell
# Для создания облака
terraform inint
terraform plan
terraform apply

# Для уничтожения облака
terraform destroy

# Получить значения outputs [так же в формате json]
terraform outputs
terraform outputs -json
```