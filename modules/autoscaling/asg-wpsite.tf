# Create launch template for wordpress

resource "aws_launch_template" "wpsite-launch-template" {
  image_id               = data.aws_ami.latest-rhel860-image.image_id
  instance_type          = var.wpsite_instance_type
  vpc_security_group_ids = var.wpsite_security_grp_ids

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
        Name = "wordpress-launch-template"
      },
    )

  }

  #   user_data = filebase64("${path.module}/wordpress.sh")
}



# Create Autoscaling for wordpress application

resource "aws_autoscaling_group" "wpsite-asg" {
  name                      = "wpsite-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  vpc_zone_identifier       = var.wpsite_vpc_zone_id

  launch_template {
    id      = aws_launch_template.wpsite-launch-template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "wpsite-asg"
    propagate_at_launch = true
  }
}


# Attach autoscaling group of wordpress application to internal loadbalancer
resource "aws_autoscaling_attachment" "wpsite_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.wpsite-asg.id
  lb_target_group_arn    = var.wpsite_target_grp_arn
}