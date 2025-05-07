#!/bin/bash

# VARIABLES
CRAWLER_NAME="lab1-patient-data-crawler"
GLUE_DATABASE_NAME="lab1_glue_db"
IAM_ROLE_NAME="lab1_glue_role"
S3_RAW_PATH="s3://lab1-raw-data-david/patient_data/"
AWS_REGION="us-east-1"

# Create Glue database if it doesn't exist
if aws glue get-database --name "$GLUE_DATABASE_NAME" --region "$AWS_REGION" >/dev/null 2>&1; then
  echo "Glue database '$GLUE_DATABASE_NAME' already exists. Skipping creation."
else
  echo "Creating Glue database: $GLUE_DATABASE_NAME..."
  aws glue create-database \
    --database-input "{\"Name\":\"$GLUE_DATABASE_NAME\"}" \
    --region "$AWS_REGION"
fi

# Get IAM role ARN (fails if missing, doesn't create)
IAM_ROLE_ARN=$(aws iam get-role --role-name "$IAM_ROLE_NAME" --query 'Role.Arn' --output text 2>/dev/null)

if [ -z "$IAM_ROLE_ARN" ]; then
  echo "❌ IAM role '$IAM_ROLE_NAME' does not exist. Please create it first."
  exit 1
fi

# Create Glue crawler if it doesn't exist
if aws glue get-crawler --name "$CRAWLER_NAME" --region "$AWS_REGION" >/dev/null 2>&1; then
  echo "Glue crawler '$CRAWLER_NAME' already exists. Skipping creation."
else
  echo "Creating Glue crawler: $CRAWLER_NAME..."
  aws glue create-crawler \
    --name "$CRAWLER_NAME" \
    --role "$IAM_ROLE_ARN" \
    --database-name "$GLUE_DATABASE_NAME" \
    --targets "{\"S3Targets\": [{\"Path\": \"$S3_RAW_PATH\"}]}" \
    --region "$AWS_REGION"
  echo "✅ Glue crawler '$CRAWLER_NAME' created."
fi