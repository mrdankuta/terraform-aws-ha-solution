# Create role for EC2 Instances
resource "aws_iam_role" "assume_role" {
  name = var.assume_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "${var.assume_role_service}"
        }
      },
    ]
  })

  tags = merge(
    var.tags, {
      Name = "${var.org_code}-${var.assume_role_name}-assume-role"
    }
  )
}


# Create IAM Policy
resource "aws_iam_policy" "role_policy" {
  name        = "${var.assume_role_name}-policy"
  path        = "/"
  description = "Policy for ${var.assume_role_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Action = [
        #   "ec2:Describe*",
        # ]
        Action   = var.iam_role_policy_action
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  tags = merge(
    var.tags, {
      Name = "${var.org_code}-${var.assume_role_name}-assume-role-policy"
    }
  )
}


# Attache Policy to Role
resource "aws_iam_policy_attachment" "role_policy_attachment" {
  name       = "${var.assume_role_name}_policy_attachment"
  roles      = [aws_iam_role.assume_role.name]
  policy_arn = aws_iam_policy.role_policy.arn
}



# Create an IAM instance profile
resource "aws_iam_instance_profile" "instance_profile" {
  name = "${aws_iam_role.assume_role.name}_instance_profile"
  role = aws_iam_role.assume_role.name
}