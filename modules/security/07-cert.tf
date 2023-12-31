# Create a certificate, public zone, and validate the certificate

resource "aws_acm_certificate" "org_domain_cert" {
  domain_name       = "*.${var.org_base_domain}"
  validation_method = "DNS"

  tags = merge(
    var.tags, {
      Name = "${var.org_code}-cert"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}


# Get the hosted zone data
data "aws_route53_zone" "org_hosted_zone" {
  name         = var.org_base_domain
  private_zone = false
}


# select validation method
resource "aws_route53_record" "org_hosted_zone_records" {
  for_each = {
    for dvo in aws_acm_certificate.org_domain_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.org_hosted_zone.zone_id
}

# CODE EXPLANATION FROM CHATGPT FOR CODE ABOVE
# ---------------------------------------------

# This Terraform code block is creating AWS Route 53 records based on the domain validation options of an ACM certificate. Here's an explanation of the code:

# - The resource being created is an `aws_route53_record` resource, which represents a record in a Route 53 hosted zone.
# - The `for_each` block is used to iterate over the `domain_validation_options` of the `aws_acm_certificate` resource named "oyindamola". It generates a unique key-value pair for each domain validation option, where the key is the `domain_name` and the value is an object containing the `name`, `record`, and `type` attributes.
# - Inside the `for_each` block, the `name`, `record`, and `type` attributes are assigned from the corresponding attributes of each domain validation option.
# - The `allow_overwrite` attribute is set to `true`, allowing the record to overwrite any existing record with the same name and type.
# - The `name` attribute of the Route 53 record is set to `each.value.name`, which represents the name of the resource record.
# - The `records` attribute is set to `[each.value.record]`, which specifies the value(s) of the resource record. In this case, it's a single value taken from `each.value.record`.
# - The `ttl` attribute is set to `60`, indicating the time to live (TTL) for the record in seconds.
# - The `type` attribute is set to `each.value.type`, which specifies the type of the resource record.
# - The `zone_id` attribute is set to `data.aws_route53_zone.oyindamola.zone_id`, referencing a Route 53 zone identified by the `zone_id` value obtained from the `data` source.

# Overall, this code dynamically creates Route 53 records based on the domain validation options of the specified ACM certificate, associating them with the corresponding hosted zone in Route 53.

# -----------------------------------------------------------------------------

########################################################
########################################################
## NOTE: 
## I commented out this block because terraform apply wouldn't complete due to certificate pending verification status. 
## Hence, access to subsequent instances will be on HTTP. Uncomment this block and change instances access to HTTPS after 
## figuring out how to fix the verification pending challenge.
##########################################################
##########################################################

# validate the certificate through DNS method
# resource "aws_acm_certificate_validation" "org_hosted_zone_records" {
#   certificate_arn         = aws_acm_certificate.org_domain_cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.org_hosted_zone_records : record.fqdn]
# }


# create records for wpsite site
resource "aws_route53_record" "tooling" {
  zone_id = data.aws_route53_zone.org_hosted_zone.zone_id
  name    = "${var.toolingsite_a_record}.${var.org_base_domain}"
  type    = "A"

  alias {
    name                   = var.alias_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = true
  }
}


# create records for wp site
resource "aws_route53_record" "wordpress" {
  zone_id = data.aws_route53_zone.org_hosted_zone.zone_id
  name    = "${var.wpsite_a_record}.${var.org_base_domain}"
  type    = "A"

  alias {
    name                   = var.alias_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = true
  }
}