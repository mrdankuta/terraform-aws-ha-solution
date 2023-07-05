# create key from key management system
resource "aws_kms_key" "partsunltd-kms" {
  description = "KMS key "
  policy      = <<EOF
  {
    "Version": "2012-10-17",
    "Id": "kms-key-policy",
    "Statement": [
      {
        "Sid": "Enable IAM User Permissions",
        "Effect": "Allow",
        "Principal": { "AWS": "arn:aws:iam::${var.aws_account_no}:user/${var.aws_account_user}" },
        "Action": "kms:*",
        "Resource": "*"
      }
    ]
  }
  EOF
}

# Create key alias
resource "aws_kms_alias" "alias" {
  name          = "alias/kms"
  target_key_id = aws_kms_key.partsunltd-kms.key_id
}


# Create Elastic file system
resource "aws_efs_file_system" "partsunltd-efs" {
  encrypted  = true
  kms_key_id = aws_kms_key.partsunltd-kms.arn

  tags = merge(
    var.tags,
    {
      Name = "${var.org_code}-efs"
    },
  )
}


# set first mount target for the EFS 
resource "aws_efs_mount_target" "efs_subnet_tgt" {
  file_system_id  = aws_efs_file_system.partsunltd-efs.id
  count           = var.layer-subnets-num == null || var.layer-subnets-num <= 0 || var.layer-subnets-num > length(data.aws_availability_zones.az-list.names) - 1 ? length(data.aws_availability_zones.az-list.names) : var.layer-subnets-num
  subnet_id       = aws_subnet.prv-compute-subnet-punltd[count.index].id
  security_groups = [aws_security_group.datalayer-sg.id]
}


# create access point for wordpress
resource "aws_efs_access_point" "wordpress" {
  file_system_id = aws_efs_file_system.partsunltd-efs.id

  posix_user {
    gid = 0
    uid = 0
  }

  root_directory {
    path = "/wpsite"

    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = 0755
    }

  }

}


# create access point for tooling
resource "aws_efs_access_point" "tooling" {
  file_system_id = aws_efs_file_system.partsunltd-efs.id
  posix_user {
    gid = 0
    uid = 0
  }

  root_directory {

    path = "/tooling"

    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = 0755
    }

  }
}