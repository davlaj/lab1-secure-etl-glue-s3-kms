#!/bin/bash

# VARIABLES
JOB_NAME="lab1-patient-transform-job"
AWS_REGION="us-east-1"

echo "Starting Glue job: $JOB_NAME..."
JOB_RUN_ID=$(aws glue start-job-run \
  --job-name "$JOB_NAME" \
  --region "$AWS_REGION" \
  --query 'JobRunId' \
  --output text)

echo "🚀 Glue job started with JobRunId: $JOB_RUN_ID"
echo "⏳ Waiting for job to complete..."

# Poll job status until it finishes
while true; do
  STATUS=$(aws glue get-job-run \
    --job-name "$JOB_NAME" \
    --run-id "$JOB_RUN_ID" \
    --region "$AWS_REGION" \
    --query 'JobRun.JobRunState' \
    --output text)

  echo "Current status: $STATUS"

  if [[ "$STATUS" == "SUCCEEDED" || "$STATUS" == "FAILED" || "$STATUS" == "STOPPED" ]]; then
    break
  fi

  sleep 10
done

echo "✅ Job finished with status: $STATUS"