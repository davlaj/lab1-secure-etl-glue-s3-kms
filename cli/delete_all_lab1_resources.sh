#!/bin/bash

# Change these names to match your setup
RAW_BUCKET="lab1-raw-data-david"
PROCESSED_BUCKET="lab1-processed-data-david"
GLUE_CRAWLER_NAME="Lab1Crawler"
GLUE_JOB_NAME="Lab1GlueJob"
KMS_KEY_ID=$(cat ../kms/last-created-key-id.txt)  # Optional if you saved it earlier
IAM_ROLE_NAME="Lab1GlueRole"

echo "🚨 Starting resource cleanup..."

# 1. Delete Glue Job
echo "🧹 Deleting Glue Job: $GLUE_JOB_NAME"
aws glue delete-job --job-name "$GLUE_JOB_NAME"

# 2. Delete Glue Crawler
echo "🧹 Deleting Glue Crawler: $GLUE_CRAWLER_NAME"
aws glue delete-crawler --name "$GLUE_CRAWLER_NAME"

# 3. Delete S3 contents and buckets
echo "🧹 Emptying and deleting S3 buckets..."
aws s3 rm "s3://$RAW_BUCKET" --recursive
aws s3 rm "s3://$PROCESSED_BUCKET" --recursive
aws s3 rb "s3://$RAW_BUCKET" --force
aws s3 rb "s3://$PROCESSED_BUCKET" --force

# 4. Schedule KMS Key deletion (can't be instant)
echo "🧹 Scheduling KMS key for deletion in 7 days..."
aws kms schedule-key-deletion --key-id "$KMS_KEY_ID" --pending-window-in-days 7

# 5. (Optional) Delete IAM role and policy
echo "🧹 Deleting IAM role and attached inline policy..."
aws iam delete-role-policy --role-name "$IAM_ROLE_NAME" --policy-name GluePolicy
aws iam delete-role --role-name "$IAM_ROLE_NAME"

echo "✅ Cleanup completed."
