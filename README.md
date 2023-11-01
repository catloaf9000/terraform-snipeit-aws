# Snipe-IT with Terraform on AWS

Deploys whole Snipe-IT infrastructure and web-server docker container on AWS

## Requirements

Terraform version ~> 1.6.2

## Usage
For authentication and authorization in AWS, terraform uses credentials from AWS CLI user, but you can provide it different ways:

[Terraform AWS Provider Documentation]https://registry.terraform.io/providers/hashicorp/aws/latest/docs

Generate ssh keys:

```bash
ssh-keygen -t rsa -b 2048 -f /path/to/terraform_key
chmod 600 /path/to/terraform_key
```

Get snipe-it app key by running docker container:

```bash
docker pull snipe/snipe-it
docker run --rm snipe/snipe-it
```

Output should be like that

```text
Please re-run this container with an environment variable $APP_KEY
An example APP_KEY you could use is: 
base64:D5oGA+zhFSVA3VwuoZoQ21RAcwBtJv/RGiqOcZ7BUvI=
```

Create a terraform.tfvars file, this is minimum requiered variables:

```
public_key_path               = "/path/to/terraform_key.pub"
private_key_path              = "/path/to/terraform_key"
db_root_password              = "<your secret password>"
snipe_it_app_key              = "<your key goes here>"
web_server_userdata_file_path = "${path.module}/web_server_userdata.sh" 
whitelist_ip                  = "<your public ip>"
```

Now everything is ready, deploy infrastructure with:
```bash
terraform init
terraform apply
```

### TODO

- Add email support