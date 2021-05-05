# Not using R53 so this is pretty sparse

data "aws_acm_certificate" "issued" {
  domain   = local.json_data.DOMAIN
  statuses = ["ISSUED"]
}
