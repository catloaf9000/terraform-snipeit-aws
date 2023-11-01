data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    // change to ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-* in non free tier
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230516"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.web_server.id]
  associate_public_ip_address = true
  user_data = templatefile(
    var.web_server_userdata_file_path,
    {
      MYSQL_PORT_3306_TCP_ADDR = local.db_endpoint
      MYSQL_PORT_3306_TCP_PORT = var.db_port
      MYSQL_DATABASE           = var.db_name
      MYSQL_USER               = var.db_root_user
      MYSQL_PASSWORD           = var.db_root_password
      APP_KEY                  = var.snipe_it_app_key
      APP_TIMEZONE             = var.timezone
      APP_LOCALE               = var.locale
    }
  )

  tags = {
    Name = "Snipe-it-Web-server"
  }

  # Ensure the instance dependencies
  depends_on = [aws_security_group.web_server, aws_db_instance.db]
}
