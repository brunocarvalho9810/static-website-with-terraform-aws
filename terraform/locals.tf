locals {

  has_domain = var.domain != ""

  domain = local.has_domain ? var.domain : random_pet.website.id

  regional_domain = module.website.regional_domain_name

  common_tags = {

    Project = "My website"

    Service = "Static website"

    Create = "2024-01-11"

  }

}