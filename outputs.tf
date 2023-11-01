output "web_server_ip_addr" {
  value = aws_instance.web.public_ip
}

output "ssh_keypair_name" {
  value = var.key_name
}

output "db_endpoint" {
  value = local.db_endpoint
}

output "db_port" {
  value = var.db_port
}

output "current_timestamp" {
  value = timestamp()
}
