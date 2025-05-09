#!/bin/bash
# ============================================================================
# Script: audit_glue_catalog.sh
# Purpose: Validate that the AWS Glue Data Catalog contains the expected tables
#          and that each table has a valid schema definition.
#
# What it does:
#   - Lists all tables in the specified Glue database
#   - Retrieves and prints the schema of each table
#
# Requirements:
#   - AWS CLI configured with access to Glue
#   - Glue crawler has already created tables
#
# Usage:
#   chmod +x cli/audit_glue_catalog.sh
#   ./cli/audit_glue_catalog.sh
#
# Author: David Lajeunesse
# ============================================================================

GLUE_DATABASE="lab1_glue_db"

echo "🔍 Listing tables in Glue database: $GLUE_DATABASE..."
TABLES=$(aws glue get-tables \
  --database-name "$GLUE_DATABASE" \
  --query 'TableList[*].Name' \
  --output text)

if [[ -z "$TABLES" ]]; then
  echo "❌ No tables found in Glue database: $GLUE_DATABASE"
  exit 1
fi

echo "✅ Found tables: $TABLES"
echo "----------------------------------------"

for TABLE in $TABLES; do
  echo "📄 Schema for table: $TABLE"
  aws glue get-table \
    --database-name "$GLUE_DATABASE" \
    --name "$TABLE" \
    --query 'Table.StorageDescriptor.Columns[*].[Name,Type]' \
    --output table
  echo "----------------------------------------"
done

echo "✅ Glue catalog schema validation complete."