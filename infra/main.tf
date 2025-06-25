terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "random_pet" "this" {
  length = 2
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "OAI for ${var.bucket_name}-${random_pet.this.id}"
}

module "s3" {
  source = "../../../../building-blocks/tested/in-platform/terraform-aws-s3-bucket"

  bucket = "${var.bucket_name}-${random_pet.this.id}"

  versioning_enabled = var.versioning_enabled

  tags = var.tags
}

resource "aws_s3_object" "index" {
  bucket = module.s3.s3_bucket_id
  key    = "index.html"
  source = "${path.module}/../app/index.html"
  etag   = filemd5("${path.module}/../app/index.html")
  content_type = "text/html"
}

module "cloudfront" {
  source = "../../../../building-blocks/tested/in-platform/terraform-aws-cloudfront"

  enabled             = var.distribution_enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  price_class         = var.price_class
  retain_on_delete    = var.retain_on_delete
  wait_for_deployment = var.wait_for_deployment
  default_root_object = "index.html"
  
  origins = [
    {
      domain_name = module.s3.s3_bucket_regional_domain_name
      origin_id   = "S3-${var.bucket_name}-${random_pet.this.id}"

      s3_origin_config = {
        origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
      }
    }
  ]

  default_cache_behavior = {
    target_origin_id       = "S3-${var.bucket_name}-${random_pet.this.id}"
    viewer_protocol_policy = var.viewer_protocol_policy
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    compress               = var.compress

    forwarded_values = {
      query_string = var.forward_query_string
      cookies = {
        forward = var.forward_cookies
      }
    }
  }

  ordered_cache_behaviors = var.ordered_cache_behaviors

  viewer_certificate = {
    cloudfront_default_certificate = var.use_default_certificate
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.ssl_support_method
    minimum_protocol_version       = var.minimum_protocol_version
  }

  geo_restrictions = var.geo_restrictions

  custom_error_responses = var.custom_error_responses

  tags = var.tags
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = module.s3.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontOAI"
        Effect    = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.this.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "${module.s3.s3_bucket_arn}/*"
      }
    ]
  })
}
