resource "aws_lb" "main" {
  name               = var.env_code
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer.id]
  subnets            = data.terraform_remote_state.level1.outputs.public_subnet_id

  tags = {
    Name = var.env_code
  }
}

resource "aws_lb_target_group" "main" {
  name     = var.env_code
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.level1.outputs.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
  }
}

resource "aws_lb_target_group_attachment" "main" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.yourdevops-private-server.id
  port             = 80
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
