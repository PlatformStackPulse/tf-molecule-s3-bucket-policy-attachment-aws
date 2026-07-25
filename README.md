# tf-molecule-s3-bucket-policy-attachment-aws

[![License](https://img.shields.io/badge/license-MIT-blue?logo=opensourceinitiative)](LICENSE)

Terraform molecule that attaches a **JSON policy document to an existing S3 bucket** by
composing the [`tf-atom-s3-bucket-policy-aws`](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-policy-aws)
atom.

Bucket-policy attachment is kept as its own molecule — separate from bucket creation — so
an OAC read policy can be attached **after** both the origin bucket and the CloudFront
distribution exist. This breaks the `bucket -> CloudFront -> policy` dependency cycle that
occurs when a bucket policy must reference a distribution ARN that itself depends on the
bucket.

## Features

- **Decoupled attachment** — attach a policy to a bucket created by any other module.
- **Cycle-breaking** — reference apply-time values (e.g. a CloudFront distribution ARN) in
  the policy without forming a dependency cycle at bucket-creation time.
- **tf-label context chaining** — full [tf-label](https://github.com/PlatformStackPulse/tf-label)
  interface for consistent naming and tagging.
- **Enable/disable switch** — set `enabled = false` (directly or via `context`) to create
  no resources while keeping the module in the configuration.
- **SHA-pinned atom source** — the underlying policy atom is pinned to an immutable commit
  for reproducible builds.

## Usage

```hcl
module "bucket_policy" {
  source = "git::https://github.com/PlatformStackPulse/tf-molecule-s3-bucket-policy-attachment-aws.git?ref=<commit-sha>"

  namespace   = "psp"
  environment = "prod"
  name        = "static-policy"

  bucket_id = module.static_bucket.bucket_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowCloudFrontOAC"
      Effect    = "Allow"
      Principal = { Service = "cloudfront.amazonaws.com" }
      Action    = "s3:GetObject"
      Resource  = "${module.static_bucket.bucket_arn}/*"
      Condition = {
        StringEquals = { "AWS:SourceArn" = module.cdn.distribution_arn }
      }
    }]
  })
}
```

<!-- BEGIN_TF_DOCS -->

### Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.11.3 |
| aws       | >= 5.0.0  |

### Providers

No providers.

### Modules

| Name   | Source                                                                      | Version                                  |
| ------ | --------------------------------------------------------------------------- | ---------------------------------------- |
| policy | git::https://github.com/PlatformStackPulse/tf-atom-s3-bucket-policy-aws.git | 98159cefe17c2161ee6a25618cd63fbc794e4741 |
| this   | git::https://github.com/PlatformStackPulse/tf-label.git                     | v1.0.0                                   |

### Resources

No resources.

### Inputs

| Name      | Description                                         | Type     | Default | Required |
| --------- | --------------------------------------------------- | -------- | ------- | :------: |
| bucket_id | ID (name) of the S3 bucket to attach the policy to. | `string` | n/a     |   yes    |
| policy    | JSON-encoded bucket policy document.                | `string` | n/a     |   yes    |
| context   | tf-label context object for naming/tagging.         | `object` | `{}`    |    no    |

### Outputs

| Name      | Description                                 |
| --------- | ------------------------------------------- |
| enabled   | Whether the module is enabled.              |
| bucket_id | ID of the bucket the policy is attached to. |

<!-- END_TF_DOCS -->

## Tests

Unit tests live in `tests/unit/` and use a **mock AWS provider** (`mock_provider "aws" {}`),
so no real AWS calls or credentials are required.

```bash
terraform init -backend=false
terraform test -test-directory=tests/unit
```
