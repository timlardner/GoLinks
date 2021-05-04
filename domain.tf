# Not using R53 so this is pretty sparse

data "aws_acm_certificate" "issued" {
  domain   = "golinks.intae.it"
  statuses = ["ISSUED"]
}
