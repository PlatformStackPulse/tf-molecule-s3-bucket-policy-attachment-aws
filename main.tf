# -----------------------------------------------------------------------------
# Molecule: S3 Bucket Policy Attachment
#
# Attaches a JSON policy document to an existing S3 bucket by composing the
# tf-atom-s3-bucket-policy-aws atom. Kept separate from bucket creation so an
# OAC read policy can be attached after both the origin bucket and the
# CloudFront distribution exist, breaking the bucket -> CDN -> policy cycle.
# -----------------------------------------------------------------------------
module "policy" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-s3-bucket-policy-aws.git?ref=98159cefe17c2161ee6a25618cd63fbc794e4741"

  context   = module.this.context
  bucket_id = var.bucket_id
  policy    = var.policy
}
