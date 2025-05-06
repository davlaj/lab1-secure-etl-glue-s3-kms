# Lab 1 – AWS Secure ETL Setup Commands

These are the CLI commands used to prepare the environment for Lab 1.

```bash
# 1. Create S3 buckets
bash cli/create_buckets.sh

# 2. Create a symmetric KMS key (and auto-capture Key ID)
bash cli/create_kms_key.sh

# 3. Upload raw CSV with SSE-KMS
bash cli/upload_raw_data.sh

# 4. Generate the Glue IAM policy from template with dynamic substitution
bash cli/generate_glue_policy.sh

# 5. Create IAM role for Glue with trust and inline policy
bash cli/create_glue_role.sh

# 6. Create a secure S3 bucket for CloudTrail logs with proper bucket policy and public access block
bash cli/create_cloudtrail_bucket.sh

# 7. Enable a multi-region CloudTrail trail and start logging to the dedicated S3 bucket
bash cli/enable_cloudtrail.sh

# 8. Create a CloudWatch Logs group, IAM role, and attach it to the CloudTrail trail for log streaming
bash cli/enable_cloudwatch_logs_for_cloudtrail.sh

# 9. Set a log retention policy (30 days) for the CloudWatch Logs group to control storage costs
bash cli/set_log_retention.sh

# 10. 

```

Make sure AWS CLI is configured with the correct profile and region.
All steps should be run in the root folder of the repository.
