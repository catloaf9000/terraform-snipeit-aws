variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "whitelist_ip" {
  type    = string
}

variable "key_name" {
  type    = string
  default = "terraform_key"
}

variable "public_key_path" {
  type        = string
  description = "Path of the public key file"
}

variable "private_key_path" {
  type        = string
  description = "Path of the private key file"
}

variable "db_instance_type" {
  type    = string
  default = "db.t2.micro"
}

variable "db_name" {
  type    = string
  default = "snipeit"
}

variable "db_root_user" {
  type    = string
  default = "snipeit"
}

variable "db_root_password" {
  type = string
}

variable "db_port" {
  type    = number
  default = 3306
}

variable "snipe_it_app_key" {
  type = string
}

variable "timezone" {
  type        = string
  description = "snipe-it config: php-like timezone"
  default     = "US/Pacific"
}

variable "locale" {
  type        = string
  description = "snipe-it config: php-like locale"
  default     = "en-US"
}
variable "web_server_userdata_file_path" {
  type = string
}