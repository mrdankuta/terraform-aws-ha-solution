# Create Bastion Server Launch Template
resource "aws_launch_template" "bastion-launch-template" {
  image_id               = data.aws_ami.latest-rhel860-image.image_id
  instance_type          = var.bastion_instance_type
  vpc_security_group_ids = var.bastion_security_grp_ids

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
      Name = "bastion-launch-template"
    },
  )
  }

#   user_data = filebase64("${path.module}/bastion.sh")
}


# Create Autoscaling Group for bastion
resource "aws_autoscaling_group" "bastion-asg" {
  name                      = "bastion-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1

  vpc_zone_identifier = var.bastion_vpc_zone_id

  launch_template {
    id      = aws_launch_template.bastion-launch-template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "bastion-launch-template"
    propagate_at_launch = true
  }

}
