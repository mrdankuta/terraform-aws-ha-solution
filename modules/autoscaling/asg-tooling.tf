# Create launch template for toooling
resource "aws_launch_template" "tooling-launch-template" {
  image_id               = data.aws_ami.latest-rhel860-image.image_id
  instance_type          = var.tooling_instance_type
  vpc_security_group_ids = var.tooling_security_grp_ids

  iam_instance_profile {
    name = var.iam_instance_profile_id
  }

  key_name = var.keypair

  placement {
    availability_zone = "random_shuffle.az.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

  tags = merge(
    var.tags,
    {
      Name = "tooling-launch-template"
    },
  )

  }

#   user_data = filebase64("${path.module}/tooling.sh")
}


# Create Autoscaling for tooling

resource "aws_autoscaling_group" "tooling-asg" {
  name                      = "tooling-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1

  vpc_zone_identifier = var.tooling_vpc_zone_id

  launch_template {
    id      = aws_launch_template.tooling-launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "tooling-launch-template"
    propagate_at_launch = true
  }
}


# Attach autoscaling group of  tooling application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_tooling" {
  autoscaling_group_name = aws_autoscaling_group.tooling-asg.id
  lb_target_group_arn   = var.tooling_target_grp_arn
}