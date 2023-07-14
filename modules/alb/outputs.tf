output "public_alb" {
  value = aws_lb.public-alb
}

output "wpsite_lb_target_grp" {
  value = aws_lb_target_group.wpsite-tgt
}

output "tooling_lb_target_grp" {
  value = aws_lb_target_group.tooling-tgt
}