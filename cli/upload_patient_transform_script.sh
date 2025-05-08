#!/bin/bash

# VARIABLES
LOCAL_PATH="glue/patient_transform.py"
S3_PATH="s3://lab1-raw-data-david/scripts/patient_transform.py"

echo "Uploading $LOCAL_PATH to $S3_PATH..."
aws s3 cp "$LOCAL_PATH" "$S3_PATH"

echo "✅ Upload complete."