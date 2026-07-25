output "enabled" {
  description = "Whether the module is enabled."
  value       = local.enabled
}

output "bucket_id" {
  description = "ID of the bucket the policy is attached to."
  value       = module.policy.bucket_id
}
