terraform {

  required_version = "1.6.6"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }

  }

  backend "s3" {}

}

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

resource "random_pet" "website" {

  length = 5

}
