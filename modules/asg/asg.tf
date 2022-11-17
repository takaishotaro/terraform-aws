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

resource "aws_launch_configuration" "main" {
  name_prefix          = "${var.env_code}-"
  image_id             = data.aws_ami.amazonlinux.id
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.private.id]
  iam_instance_profile = aws_iam_instance_profile.main.name
  user_data            = file("${path.module}/user-data.sh")
}

resource "aws_autoscaling_group" "main" {
  name             = var.env_code
  min_size         = 2
  desired_capacity = 2
  max_size         = 4

  target_group_arns    = [var.target_group_arn]
  launch_configuration = aws_launch_configuration.main.name
  vpc_zone_identifier  = var.private_subnet_id

  tag {
    key                 = "Name"
    value               = var.env_code
    propagate_at_launch = true
  }
}
