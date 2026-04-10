locals {
  acm_validation_records = merge([
    for cert_key, cert in aws_acm_certificate.create_cert : {
      for dvo in cert.domain_validation_options :
      "${cert_key}-${dvo.domain_name}" => {
        zone   = cert_key
        name   = dvo.resource_record_name
        type   = dvo.resource_record_type
        record = dvo.resource_record_value
      }
    }
  ]...)
}