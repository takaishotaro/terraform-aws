resource "aws_key_pair" "main" {
  key_name   = "${var.env_code}-main"
  public_key = file("./.ssh/yourdevops.pub")
}


