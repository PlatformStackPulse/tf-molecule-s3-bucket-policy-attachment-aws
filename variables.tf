# -----------------------------------------------------------------------------
# Module-Specific Variables
#
# Standard labeling variables (enabled, namespace, environment, stage, name,
# attributes, tags, context, ...) are provided by context.tf via tf-label.
# -----------------------------------------------------------------------------

variable "bucket_id" {
  description = "ID (name) of the S3 bucket to attach the policy to."
  type        = string
}

variable "policy" {
  description = "JSON-encoded bucket policy document."
  type        = string
}
