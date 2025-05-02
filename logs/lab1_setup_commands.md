# Lab 1 – AWS Secure ETL Setup Commands

These are the CLI commands used to prepare the environment for Lab 1.

```bash
# 1. Create S3 buckets
bash cli/create_buckets.sh

# 2. Upload input dataset to S3
aws s3 cp data/realistic_patient_data_10k.csv s3://lab1-raw-data-david/

# 3. Create a symmetric KMS key (and auto-capture Key ID)
bash cli/create_kms_key.sh

# 4. Generate the Glue IAM policy from template with dynamic substitution
bash cli/generate_glue_policy.sh

# 5. Create IAM role for Glue with trust and inline policy
bash cli/create_glue_role.sh
