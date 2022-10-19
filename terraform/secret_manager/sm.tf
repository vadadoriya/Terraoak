# Rotate secrets
resource "aws_secretsmanager_secret" "rsm" {
  name                    = var.rsm_key
  description             = "Default config2"
  kms_key_id              = aws_kms_key.kms_key.id
  policy                  = aws_secretsmanager_secret_policy.rsm_policy.policy
  recovery_window_in_days = 10 
  tags                    ={
    Name = "rsm"
    Env = "dev"
  }
}

resource "aws_secretsmanager_secret_version" "rsm-sv" {
  secret_id     = aws_secretsmanager_secret.rsm.id
  # SaC Testing - Severity: Critical - Set secret_string to ''
  secret_string = ""
  depends_on    = [aws_secretsmanager_secret.rsm]
}

resource "aws_secretsmanager_secret_version" "rsm-svu" {
  secret_id     = aws_secretsmanager_secret.rsm.id
  secret_string = var.rsm_value
  depends_on    = [aws_secretsmanager_secret.rsm]

  lifecycle {
    ignore_changes = [
      secret_string,
      secret_binary,
    ]
  }
}

# We can use lambda function configuration for that
resource "aws_secretsmanager_secret_rotation" "rsm-sr" {
   secret_id           = aws_secretsmanager_secret.rsm.id
   rotation_lambda_arn = "arn:aws:lambda:us-east-2:709695003849:function:lambda_test"

   rotation_rules {
    # SaC Testing - Severity: Critical - set automatically_after_days to value other than 30
     automatically_after_days = 10
   }
}
