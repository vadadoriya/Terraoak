resource "aws_secretsmanager_secret_policy" "rsm_policy" {
  secret_arn = aws_secretsmanager_secret.rsm.arn
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableAllPermissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::XXXXXXXXXXXX:user/XXXXXX"
      },
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "arn:aws:secretsmanager::XXXXXXXXXXXX:secret:XXXX"
    }
  ]
}
POLICY
}
