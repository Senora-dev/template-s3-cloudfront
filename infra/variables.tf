variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "versioning_enabled" {
  description = "Whether to enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules for the S3 bucket"
  type = list(object({
    id      = string
    enabled = bool
    prefix  = string

    expiration = optional(object({
      days = number
    }))

    transition = optional(list(object({
      days          = number
      storage_class = string
    })))

    noncurrent_version_expiration = optional(object({
      days = number
    }))

    noncurrent_version_transition = optional(list(object({
      days          = number
      storage_class = string
    })))
  }))
  default = []
}

variable "server_side_encryption" {
  description = "Server-side encryption configuration for the S3 bucket"
  type = object({
    enabled     = bool
    kms_key_arn = string
  })
  default = {
    enabled     = true
    kms_key_arn = null
  }
}

variable "cors_rules" {
  description = "List of CORS rules for the S3 bucket"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default = []
}

variable "distribution_name" {
  description = "Name of the CloudFront distribution"
  type        = string
}

variable "distribution_enabled" {
  description = "Whether the distribution is enabled"
  type        = bool
  default     = true
}

variable "is_ipv6_enabled" {
  description = "Whether IPv6 is enabled for the distribution"
  type        = bool
  default     = true
}

variable "price_class" {
  description = "Price class for the distribution (PriceClass_100, PriceClass_200, or PriceClass_All)"
  type        = string
  default     = "PriceClass_100"
}

variable "retain_on_delete" {
  description = "Whether to retain the distribution on delete"
  type        = bool
  default     = false
}

variable "wait_for_deployment" {
  description = "Whether to wait for the distribution to be deployed"
  type        = bool
  default     = true
}

variable "default_root_object" {
  description = "Default root object for the distribution"
  type        = string
  default     = "index.html"
}

variable "viewer_protocol_policy" {
  description = "Viewer protocol policy (allow-all, redirect-to-https, or https-only)"
  type        = string
  default     = "redirect-to-https"
}

variable "allowed_methods" {
  description = "List of allowed methods for the default cache behavior"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "cached_methods" {
  description = "List of cached methods for the default cache behavior"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "forward_query_string" {
  description = "Whether to forward query strings to the origin"
  type        = bool
  default     = false
}

variable "forward_cookies" {
  description = "How to forward cookies to the origin (none, all, or whitelist)"
  type        = string
  default     = "none"
}

variable "min_ttl" {
  description = "Minimum TTL for the default cache behavior"
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "Default TTL for the default cache behavior"
  type        = number
  default     = 3600
}

variable "max_ttl" {
  description = "Maximum TTL for the default cache behavior"
  type        = number
  default     = 86400
}

variable "compress" {
  description = "Whether to compress content for the default cache behavior"
  type        = bool
  default     = true
}

variable "ordered_cache_behaviors" {
  description = "List of ordered cache behaviors"
  type = list(object({
    path_pattern             = string
    target_origin_id        = string
    viewer_protocol_policy  = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    compress               = optional(bool)
    cache_policy_id        = optional(string)
    origin_request_policy_id = optional(string)
    response_headers_policy_id = optional(string)
    forwarded_values = optional(object({
      query_string = bool
      headers      = optional(list(string))
      cookies = object({
        forward           = string
        whitelisted_names = optional(list(string))
      })
    }))
  }))
  default = []
}

variable "use_default_certificate" {
  description = "Whether to use the default CloudFront certificate"
  type        = bool
  default     = true
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate to use"
  type        = string
  default     = null
}

variable "ssl_support_method" {
  description = "SSL support method (sni-only or vip)"
  type        = string
  default     = "sni-only"
}

variable "minimum_protocol_version" {
  description = "Minimum protocol version (TLSv1, TLSv1.1_2016, TLSv1.2_2018, or TLSv1.2_2021)"
  type        = string
  default     = "TLSv1.2_2021"
}

variable "geo_restrictions" {
  description = "Geographic restriction configuration for the distribution"
  type = object({
    restriction_type = string
    locations        = list(string)
  })
  default = null
}

variable "custom_error_responses" {
  description = "List of custom error responses"
  type = list(object({
    error_code            = number
    response_code        = optional(number)
    response_page_path   = optional(string)
    error_caching_min_ttl = optional(number)
  }))
  default = []
}

variable "alarm_actions" {
  description = "List of ARNs to notify when alarms are triggered"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
} 