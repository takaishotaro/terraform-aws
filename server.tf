resource "aws_key_pair" "keypair" {
  key_name   = "${local.project_name}-keypair"
  public_key = file("./.ssh/yourdevops.pub")
}

resource "aws_instance" "yourdevops-private-server" {
  ami                    = "ami-0de5311b2a443fb89"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet_1a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  key_name = aws_key_pair.keypair.key_name

  depends_on = [
    aws_subnet.private_subnet_1a
  ]

  tags = {
    Name = "${local.project_name}-private-server"
  }
}

resource "aws_instance" "yourdevops-public-server" {
  ami                         = "ami-0de5311b2a443fb89"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_1a.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.keypair.key_name

  depends_on = [
    aws_subnet.public_subnet_1a
  ]

  tags = {
    Name = "${local.project_name}-public-server"
  }
}
