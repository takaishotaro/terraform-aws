output "load_balancer_sg" {
  value = aws_security_group.load_balancer
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}
