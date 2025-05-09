#!/bin/bash
# Create raw and processed S3 buckets

RAW_BUCKET="lab1-raw-data-david"
PROCESSED_BUCKET="lab1-processed-data-david"

aws s3 mb s3://$RAW_BUCKET
aws s3 mb s3://$PROCESSED_BUCKET

echo "Buckets created: $RAW_BUCKET, $PROCESSED_BUCKET"
