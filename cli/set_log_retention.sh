#!/bin/bash

# VARIABLES
LOG_GROUP_NAME="/aws/cloudtrail/lab1"
RETENTION_DAYS=30

echo "Setting retention policy to $RETENTION_DAYS days on log group $LOG_GROUP_NAME..."

aws logs put-retention-policy \
  --log-group-name "$LOG_GROUP_NAME" \
  --retention-in-days "$RETENTION_DAYS"

echo "✅ Retention policy set: $RETENTION_DAYS days."