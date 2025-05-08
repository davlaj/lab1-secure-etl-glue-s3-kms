#!/bin/bash

# VARIABLES
JOB_NAME="lab1-patient-transform-job"
IAM_ROLE_NAME="Lab1GlueRole"
SCRIPT_LOCATION="s3://lab1-raw-data-david/scripts/patient_transform.py"
TEMP_DIR="s3://lab1-raw-data-david/temp/"
AWS_REGION="us-east-1"

# Check if the job already exists
if aws glue get-job --job-name "$JOB_NAME" --region "$AWS_REGION" >/dev/null 2>&1; then
  echo "Glue job '$JOB_NAME' already exists. Skipping creation."
  exit 0
fi

# Get role ARN
ROLE_ARN=$(aws iam get-role --role-name "$IAM_ROLE_NAME" --query 'Role.Arn' --output text)

# Create Glue job
echo "Creating Glue job: $JOB_NAME..."
aws glue create-job \
  --name "$JOB_NAME" \
  --role "$ROLE_ARN" \
  --region "$AWS_REGION" \
  --command '{
    "Name": "glueetl",
    "ScriptLocation": "'"$SCRIPT_LOCATION"'",
    "PythonVersion": "3"
  }' \
  --default-arguments '{
    "--TempDir": "'"$TEMP_DIR"'",
    "--job-language": "python",
    "--enable-metrics": ""
  }' \
  --glue-version "3.0" \
  --max-capacity 2

echo "✅ Glue job '$JOB_NAME' created."