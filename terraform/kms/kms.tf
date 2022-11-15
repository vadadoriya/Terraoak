data "aws_caller_identity" "current" {}

resource "aws_kms_key" "foo_kms" {
  description              = "KMS key template"
  deletion_window_in_days  = 10
  customer_master_key_spec = "SYMMETRIC_DEFAULT" # Must be configured
  key_usage                = "ENCRYPT_DECRYPT"
  # SaC Testing - Severity: Critical - Set enable_key_rotation to false
  enable_key_rotation      = false
  is_enabled               = true
  policy = <<POLICY
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kms:*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion",
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::111122223333:user/Alice"
        ]
      },
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY
}

resource "aws_kms_alias" "foo" {
  # All options # Must be configured
  name          = "alias/bar"
  target_key_id = aws_kms_key.foo_kms.id
}



