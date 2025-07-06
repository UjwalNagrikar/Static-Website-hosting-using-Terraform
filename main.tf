resource "aws_s3_bucket" "static_site" {
  bucket = "ujwal-resume1" # Replace with your unique bucket name
  
  tags = {
    Name        = "StaticSiteBucket"
    Environment = "Dev"
  }
}

# Configure website configuration separately (newer Terraform AWS provider)
resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.static_site.id
  
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.static_site.id
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = [
          "s3:GetObject"
        ],
        Resource  = "${aws_s3_bucket.static_site.arn}/*"
      }
    ]
  })
  
  depends_on = [aws_s3_bucket_public_access_block.block]
}

# Upload index.html
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.static_site.id
  key          = "index.html"
  source       = "index.html" # Path to your local file
  content_type = "text/html"
}

# Upload style.css
resource "aws_s3_object" "style" {
  bucket       = aws_s3_bucket.static_site.id
  key          = "style.css"
  source       = "style.css"
  content_type = "text/css"
}

# Output the website URL
output "website_url" {
  value = "http://${aws_s3_bucket.static_site.bucket}.s3-website.${data.aws_region.current.name}.amazonaws.com"
}

# Get current AWS region
data "aws_region" "current" {}

# Output the S3 bucket name
output "bucket_name" {
  value = aws_s3_bucket.static_site.bucket
}