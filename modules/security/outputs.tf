output "public_alb_sg" {
    value = aws_security_group.public-alb-sg
}

output "bastion_sg" {
    value = aws_security_group.bastion_sg
}

output "nginx_sg" {
    value = aws_security_group.nginx-sg
}

output "internal_alb_sg" {
    value = aws_security_group.int-alb-sg
}

output "webserver_sg" {
    value = aws_security_group.webserver-sg
}

output "data_layer_sg" {
    value = aws_security_group.datalayer-sg
}

output "instance_profile" {
    value = aws_iam_instance_profile.instance_profile
}