# ---------------------------------------------
# Security Group
# ---------------------------------------------
resource "aws_security_group" "private" {
  name   = "${var.env_code}-private-sg"
  vpc_id = var.vpc_id

  ingress {
    description     = "http from lb"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.load_balancer_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_code}-private-sg"
  }
}
