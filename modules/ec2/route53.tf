# If the component has "internal = true", then create a private Route53 record, if false create a public one
resource "aws_route53_record" "a_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.name}-${var.env_name}"
  type    = "A"
  ttl     = 10
  records = ["${local.get_instance_ip}"]
}