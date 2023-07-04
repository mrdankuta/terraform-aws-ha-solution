
# ----------------PUBLIC LB----------------

# Create Application Load Balancer
resource "aws_lb" "public-alb" {
  name     = "public-alb"
  internal = false
  security_groups = [
    aws_security_group.public-alb-sg.id,
  ]

  subnets = [
    aws_subnet.public-subnet-punltd[0].id,
    aws_subnet.public-subnet-punltd[1].id
  ]

   tags = merge(
    var.tags,
    {
      Name = "${var.org_code}-public-alb"
    },
  )

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}


# Create a target group for the Nginx proxies
resource "aws_lb_target_group" "nginx-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  name        = "nginx-tgt"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = aws_vpc.part-unltd-vpc.id
}


# Add listener for `HTTP` and `HTTPS`.
resource "aws_lb_listener" "nginx-listner" {
  load_balancer_arn = aws_lb.public-alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.partsunltd_hz_recs.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-tgt.arn
  }
}

# ----------------INTERNAL LB----------------

# Create Application Load Balancer
resource "aws_lb" "internal-alb" {
  name     = "int-alb"
  internal = false
  security_groups = [
    aws_security_group.int-alb-sg.id,
  ]

  subnets = [
    aws_subnet.prv-compute-subnet-punltd[0].id,
    aws_subnet.prv-compute-subnet-punltd[1].id
  ]

   tags = merge(
    var.tags,
    {
      Name = "${var.org_code}-internal-alb"
    },
  )

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}


# Create a target group for the Tooling Site
resource "aws_lb_target_group" "tooling-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  name        = "tooling-tgt"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = aws_vpc.part-unltd-vpc.id
}


# Create a target group for the Wordpress
resource "aws_lb_target_group" "wpsite-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  name        = "wpsite-tgt"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = aws_vpc.part-unltd-vpc.id
}



# For this aspect a single listener was created for the wordpress which is default,
# A rule was created to route traffic to tooling when the host header changes

resource "aws_lb_listener" "web-listener" {
  load_balancer_arn = aws_lb.internal-alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.partsunltd_hz_recs.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wpsite-tgt.arn
  }
}

# listener rule for tooling target

resource "aws_lb_listener_rule" "tooling-listener" {
  listener_arn = aws_lb_listener.web-listener.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tooling-tgt.arn
  }

  condition {
    host_header {
      values = ["tooling.${var.org_base_domain}"]
    }
  }
}