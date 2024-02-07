resource "aws_s3_directory_bucket" "this" {
  bucket        = var.bucket
  force_destroy = true
  location {
    name = var.location
  }
}