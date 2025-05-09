#!/bin/bash
# ==============================================================================
# Script Name: cleanup_lab.sh
# Description: Cleanup script for Lab1 - Secure ETL Pipeline using Glue, S3, and KMS.
#              Deletes all AWS resources created during the lab including:
#              - Glue jobs, crawlers, and databases
#              - IAM roles and policies
#              - S3 buckets and contents
#              - CloudTrail trails
#              - KMS keys (scheduled for deletion)
#
# Usage: Run from the root directory of the project after completing the lab.
# Author: David Lajeunesse
# ==============================================================================

set -e  # Exit on first error

# Variables
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION="us-east-1"
RAW_BUCKET="lab1-raw-data-david"
PROCESSED_BUCKET="lab1-processed-data-david"
CLOUDTRAIL_BUCKET="cloudtrail-logs-$ACCOUNT_ID"
GLUE_DATABASE="lab1_glue_db"
GLUE_CRAWLER="lab1-patient-data-crawler"
GLUE_JOB="lab1-patient-transform-job"
GLUE_ROLE="Lab1GlueRole"
KMS_KEY_FILE="./kms/last-created-key-id.txt"

echo "⚠️  Starting cleanup of AWS resources for Lab1..."

# 1. Delete Glue Job
echo "🗑️  Deleting Glue job..."
aws glue delete-job --job-name "$GLUE_JOB" --region "$AWS_REGION" || echo "Glue job not found."

# 2. Delete Glue Crawler and Database
echo "🗑️  Deleting Glue crawler..."
aws glue delete-crawler --name "$GLUE_CRAWLER" --region "$AWS_REGION" || echo "Glue crawler not found."

echo "🗑️  Deleting Glue database..."
aws glue delete-database --name "$GLUE_DATABASE" --region "$AWS_REGION" || echo "Glue database not found."

# 3. Delete IAM Role
echo "🗑️  Deleting IAM role..."
aws iam delete-role-policy --role-name "$GLUE_ROLE" --policy-name "${GLUE_ROLE}Policy" || echo "IAM policy not found."
aws iam delete-role --role-name "$GLUE_ROLE" || echo "IAM role not found."

# 4. Delete S3 Buckets and Contents
for BUCKET in "$RAW_BUCKET" "$PROCESSED_BUCKET" "$CLOUDTRAIL_BUCKET"; do
    echo "🗑️  Emptying and deleting S3 bucket: $BUCKET"
    aws s3 rm "s3://$BUCKET" --recursive || echo "Bucket already empty or not found."
    aws s3api delete-bucket --bucket "$BUCKET" --region "$AWS_REGION" || echo "Bucket not found."
done

# 5. Disable and Delete CloudTrail
echo "🗑️  Cleaning up CloudTrail..."
aws cloudtrail delete-trail --name "lab1-cloudtrail" --region "$AWS_REGION" || echo "CloudTrail not found."

# 5. Delete LogGroups in CloudWatch
echo "🗑️  Cleaning up LogGroups in CloudWatch..."
aws logs delete-log-group --log-group-name /aws-glue/crawlers
aws logs delete-log-group --log-group-name /aws/cloudtrail/lab1

# 6. Delete KMS Key (if created)
if [[ -f "$KMS_KEY_FILE" ]]; then
    KMS_KEY_ID=$(cat "$KMS_KEY_FILE")
    echo "🗑️  Scheduling deletion for KMS Key: $KMS_KEY_ID"
    aws kms schedule-key-deletion --key-id "$KMS_KEY_ID" --pending-window-in-days 7 --region "$AWS_REGION" || echo "KMS Key not found."
else
    echo "ℹ️  No KMS Key ID file found. Skipping KMS cleanup."
fi

echo "✅ Cleanup complete!"