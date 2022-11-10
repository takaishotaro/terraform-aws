resource "aws_key_pair" "keypair" {
  key_name   = "${var.env_code}-keypair"
  public_key = file("./.ssh/yourdevops.pub")
}

resource "aws_instance" "yourdevops-private-server" {
  ami                    = "ami-0de5311b2a443fb89"
  instance_type          = "t2.micro"
  subnet_id              = data.terraform_remote_state.level1.outputs.private_subnet_id[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  key_name = aws_key_pair.keypair.key_name

  tags = {
    Name = "${var.env_code}-private-server"
  }
}

resource "aws_instance" "yourdevops-public-server" {
  ami                         = "ami-0de5311b2a443fb89"
  instance_type               = "t2.micro"
  subnet_id                   = data.terraform_remote_state.level1.outputs.public_subnet_id[0]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  user_data                   = file("user-data.sh")

  key_name = aws_key_pair.keypair.key_name

  tags = {
    Name = "${var.env_code}-public-server"
  }
}
