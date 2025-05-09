#!/bin/bash
# ============================================================================
# Script: run_glue_crawler.sh
# Purpose: Start the Glue crawler and wait until it finishes
# ============================================================================

CRAWLER_NAME="lab1-patient-data-crawler"
AWS_REGION="us-east-1"

echo "🚀 Starting Glue crawler: $CRAWLER_NAME..."
aws glue start-crawler --name "$CRAWLER_NAME" --region "$AWS_REGION"

echo -n "⏳ Waiting for crawler to finish"
while true; do
  STATE=$(aws glue get-crawler --name "$CRAWLER_NAME" \
           --region "$AWS_REGION" \
           --query 'Crawler.State' --output text)

  if [ "$STATE" = "READY" ]; then
    echo -e "\n✅ Crawler finished."
    break
  fi

  echo -n "."
  sleep 5
done