output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = module.s3.s3_bucket_id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.s3.s3_bucket_arn
}

output "bucket_domain_name" {
  description = "The domain name of the S3 bucket"
  value       = module.s3.s3_bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The regional domain name of the S3 bucket"
  value       = module.s3.s3_bucket_regional_domain_name
}

output "distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = module.cloudfront.distribution_id
}

output "distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  value       = module.cloudfront.distribution_arn
}

output "distribution_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = module.cloudfront.distribution_domain_name
}

output "distribution_hosted_zone_id" {
  description = "The hosted zone ID of the CloudFront distribution"
  value       = module.cloudfront.distribution_hosted_zone_id
}

output "origin_access_identity_id" {
  description = "The ID of the CloudFront origin access identity"
  value       = aws_cloudfront_origin_access_identity.this.id
}

output "origin_access_identity_iam_arn" {
  description = "The IAM ARN of the CloudFront origin access identity"
  value       = aws_cloudfront_origin_access_identity.this.iam_arn
}

output "origin_access_identity_path" {
  description = "The path of the CloudFront origin access identity"
  value       = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
} 