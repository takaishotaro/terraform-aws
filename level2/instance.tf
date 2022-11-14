resource "aws_key_pair" "main" {
  key_name   = "${var.env_code}-main"
  public_key = file("./.ssh/yourdevops.pub")
}


resource "aws_instance" "yourdevops-public-server" {
  ami                         = data.aws_ami.amazonlinux.id
  instance_type               = "t2.micro"
  subnet_id                   = data.terraform_remote_state.level1.outputs.public_subnet_id[0]
  vpc_security_group_ids      = [aws_security_group.public.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.main.key_name

  tags = {
    Name = "${var.env_code}-public-server"
  }
}
