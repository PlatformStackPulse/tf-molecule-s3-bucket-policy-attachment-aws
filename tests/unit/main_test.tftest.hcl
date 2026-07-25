# Unit Tests — S3 Bucket Policy Attachment Molecule
#
# Uses a mock AWS provider — no real AWS calls are made.
#   terraform init -backend=false
#   terraform test -test-directory=tests/unit

mock_provider "aws" {}

variables {
  namespace = "eg"
  stage     = "test"
  name      = "policy"

  bucket_id = "eg-test-example-bucket"
  policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
}

# ---------------------------------------------------------------------------
# Test: module is enabled by default and attaches the policy
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "Module should be enabled by default."
  }

  assert {
    condition     = module.this.id == "eg-test-policy"
    error_message = "tf-label id should be composed as namespace-stage-name (eg-test-policy)."
  }

  assert {
    condition     = module.policy.enabled == true
    error_message = "The underlying policy atom should be enabled when the molecule is enabled."
  }
}

# ---------------------------------------------------------------------------
# Test: disabling the module creates nothing
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.enabled == false
    error_message = "When enabled = false, the module should report enabled = false."
  }
}
