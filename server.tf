resource "aws_key_pair" "keypair" {
  key_name   = "${local.project_name}-keypair"
  public_key = file("./.ssh/yourdevops.pub")
}

resource "aws_instance" "yourdevops-server" {
  ami                         = "ami-0de5311b2a443fb89"
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.private_subnets[0]
  
  key_name = aws_key_pair.keypair.key_name

  depends_on = [
    module.vpc
  ]
}

