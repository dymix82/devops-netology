#keys
variable "token" {
  type      = string
  sensitive = true
}

#ID облака
variable "cloud_id" {
  type    = string
  default = "b1ggou36jr3l6tqbcfc2"
}

#ID каталога
variable "folder_id" {
  type    = string
  default = "b1gbn9qvu6odceorrvk4"
}

#Зона доступности
variable "zone" {
  type    = string
  default = "ru-central1-a"
}

#Имя подсети, в которой создаются ВМ
variable "subnet_name" {
  type    = string
  default = "default-ru-central1-a"
}