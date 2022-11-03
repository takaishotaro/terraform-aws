resource "aws_key_pair" "keypair" {
  key_name   = "${local.project_name}-keypair"
  public_key = file("./.ssh/yourdevops.pub")
}

resource "aws_instance" "yourdevops-server" {
  ami           = "ami-0de5311b2a443fb89"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_1a.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  key_name = aws_key_pair.keypair.key_name

  depends_on = [
    aws_subnet.private_subnet_1a
  ]
}
