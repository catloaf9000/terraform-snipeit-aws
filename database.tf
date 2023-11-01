resource "aws_db_instance" "db" {
  allocated_storage = 10
  db_name           = var.db_name
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = var.db_instance_type
  username          = var.db_root_user

  password               = var.db_root_password
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  port                   = var.db_port
  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.database.id]
  availability_zone      = "${var.aws_region}a"
}

locals {
  db_endpoint = split(":", aws_db_instance.db.endpoint)[0]
}