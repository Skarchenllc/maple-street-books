# ============================================================
#  Maple Docker — Terraform IaC
#  Cloud: AWS  |  Deploys static site to S3 + CloudFront
# ============================================================

terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state — use your own S3 backend or comment out
  backend "s3" {
    bucket = "skarchenllc-tfstate"
    key    = "maple-docker/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# ── Variables ───────────────────────────────────────────────
variable "aws_region"   { default = "us-east-1" }
variable "project_name" { default = "maple-street-books" }
variable "color_brand"  { default = "#4f46e5" }

# ── S3 Bucket (static website) ──────────────────────────────
resource "aws_s3_bucket" "site" {
  bucket        = "${var.project_name}-site"
  force_destroy = true

  tags = {
    Project = var.project_name
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document { suffix = "index.html" }
  error_document { key    = "index.html" }
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicRead"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.site.arn}/*"
    }]
  })
  depends_on = [aws_s3_bucket_public_access_block.site]
}

# ── CloudFront Distribution ──────────────────────────────────
resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"   # US/EU edge nodes
  comment             = "${var.project_name} CDN"

  origin {
    domain_name = aws_s3_bucket_website_configuration.site.website_endpoint
    origin_id   = "s3-${var.project_name}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-${var.project_name}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
    compress    = true
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

# ── Outputs ──────────────────────────────────────────────────
output "s3_website_url" {
  value = "http://${aws_s3_bucket_website_configuration.site.website_endpoint}"
}

output "cloudfront_url" {
  description = "Live HTTPS URL (primary)"
  value       = "https://${aws_cloudfront_distribution.cdn.domain_name}"
}

output "cloudfront_id" {
  value = aws_cloudfront_distribution.cdn.id
}
