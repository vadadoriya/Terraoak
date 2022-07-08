variable "certificate_arn" {
  type        = string
  description = "domain name certificate"
  sensitive   = true
  default     = "arn:aws:acm:us-east-2:709695003849:certificate/43b842f7-7ab8-466f-b735-950b023206aa"
}

variable "client_id" {
  type        = string
  description = "oidc client name"
  sensitive   = true
  default     = "0oajirplq0DdSQFs5695"
}

variable "client_secret" {
  type        = string
  description = "oidc client secret"
  sensitive   = true
  default     = "5gaTr1CLnT_O5j7gUVLdJJ0fkkYddHpxe88dqueV"
}
