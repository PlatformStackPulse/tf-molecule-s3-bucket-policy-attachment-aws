terraform {
  required_version = ">= 1.11.3"
}

# Attach a CloudFront OAC read policy to an existing static-origin bucket.
module "bucket_policy" {
  source = "../.."

  namespace   = "psp"
  environment = "prod"
  name        = "static-policy"

  bucket_id = "psp-prod-static-origin"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowCloudFrontOAC"
      Effect    = "Allow"
      Principal = { Service = "cloudfront.amazonaws.com" }
      Action    = "s3:GetObject"
      Resource  = "arn:aws:s3:::psp-prod-static-origin/*"
    }]
  })
}
