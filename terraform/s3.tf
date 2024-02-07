data "template_file" "s3-public-policy" {

  template = file("policy.json")

  vars = {
    bucket_name = "${local.domain}"
    cdn_oai     = aws_cloudfront_origin_access_identity.origin_access_identity.id
  }

}

module "logs" {

  source = "./s3_module"

  name = "${local.domain}-logs"

  acl = "log-delivery-write"

  tags = local.common_tags

  force_destroy = !local.has_domain
}

module "website" {

  source = "./s3_module"

  name = local.domain

  acl = "public-read"

  policy = jsondecode(data.template_file.s3-public-policy.rendered)

  force_destroy = !local.has_domain

  filepath = "${path.module}/../my-website/build"

  exist_policy = true

  # block_public_acls       = false
  # block_public_policy     = false
  # ignore_public_acls      = false
  # restrict_public_buckets = false

  versioning = {

    enabled = true

  }

  website = {

    index_document = "index.html"

    error_document = "index.html"
  }

  logging = {

    target_bucket = module.logs.name

    target_prefix = "access/"
  }

  tags = local.common_tags
}

module "redirect" {

  source = "./s3_module"

  name = "www.${local.domain}"

  acl = "public-read"

  force_destroy = !local.has_domain

  website = {
    redirect_all_requests_to = local.has_domain ? var.domain : module.website.website
  }

  tags = local.common_tags

  # block_public_acls       = false
  # block_public_policy     = false
  # ignore_public_acls      = false
  # restrict_public_buckets = false
}