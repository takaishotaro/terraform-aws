# ---------------------------------------------
# Security Group
# ---------------------------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "${local.project_name}-ec2-sg"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "ec2_in_ssh" {
  security_group_id = aws_security_group.ec2_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}
