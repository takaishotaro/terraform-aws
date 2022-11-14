data "terraform_remote_state" "level1" {
  backend = "s3"

  config = {
    bucket = "tf-state-20221102"
    key    = "level1.tfstate"
    region = "ap-northeast-1"
  }
}

data "aws_ami" "amazonlinux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
