# Get latest RHEL 8.6.0 image
data "aws_ami" "latest-rhel860-image" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["RHEL-8.6.0_HVM-*-x86_64-2-Hourly2-GP2"]
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


# Get latest Ubuntu 20.04 image
data "aws_ami" "latest-ubuntu2004-image" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
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