# Create role for EC2 Instances
resource "aws_iam_role" "ec2_instance_role" {
  name = "ec2_instance_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(
    var.tags, {
        Name = "${var.org_code}-ec2-assume-role"
    }
  )
}


# Create IAM Policy
resource "aws_iam_policy" "ec2_instance_policy" {
  name        = "ec2_instance_policy"
  path        = "/"
  description = "Policy for ec2_instance_role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  tags = merge(
    var.tags, {
        Name = "${var.org_code}-ec2-assume-role-policy"
    }
  )
}


# Attache Policy to Role
resource "aws_iam_policy_attachment" "role_policy_attachment" {
  name       = "ec2_role_policy_attachment"
  roles      = [aws_iam_role.ec2_instance_role.name]
  policy_arn = aws_iam_policy.ec2_instance_policy.arn
}



# Create an IAM instance profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_instance_role.name
}