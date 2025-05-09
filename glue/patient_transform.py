# ============================================================================
# Script: patient_transform.py
# Purpose: Clean raw patient data and enforce explicit typing for Glue Catalog recognition.
#
# Steps:
#   - Load raw CSV data directly from S3
#   - Drop rows with null values
#   - Standardize column names to lowercase
#   - Write cleaned data back to S3 in Parquet format (optimized for Glue Crawler, Athena, and QuickSight)
#
# Output:
#   - S3 Path: s3://lab1-processed-data-david/patient-data/
#
# Author: David Lajeunesse
# ============================================================================

from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
import sys
import pyspark.sql.functions as F
from pyspark.sql.types import *

args = getResolvedOptions(sys.argv, ['JOB_NAME'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Load raw data directly from S3
raw_data = glueContext.create_dynamic_frame.from_options(
    format_options={"withHeader": True},
    connection_type="s3",
    format="csv",
    connection_options={"paths": ["s3://lab1-raw-data-david/patient-data/"]},
    transformation_ctx="raw_data"
)

# Convert DynamicFrame to DataFrame
df = raw_data.toDF().dropna()

# Lowercase column names for consistency
df = df.toDF(*[c.lower() for c in df.columns])

# Explicit type casting
df_typed = df \
    .withColumn("patient_id", F.col("patient_id").cast(StringType())) \
    .withColumn("birth_date", F.to_date(F.col("birth_date"), "yyyy/MM/dd")) \
    .withColumn("gender", F.col("gender").cast(StringType())) \
    .withColumn("ssn", F.col("ssn").cast(StringType())) \
    .withColumn("diagnosis_code", F.col("diagnosis_code").cast(StringType())) \
    .withColumn("treatment_start", F.to_date(F.col("treatment_start"), "yyyy-MM-dd")) \
    .withColumn("email", F.col("email").cast(StringType())) \
    .withColumn("country", F.col("country").cast(StringType())) \
    .withColumn("insurance_number", F.col("insurance_number").cast(StringType())) \
    .withColumn("chronic_condition", F.col("chronic_condition").cast(StringType())) \
    .withColumn("notes", F.col("notes").cast(StringType())) \
    .withColumn("last_visit_lat", F.col("last_visit_lat").cast(DoubleType())) \
    .withColumn("last_visit_long", F.col("last_visit_long").cast(DoubleType())) \
    .withColumn("referred_by", F.col("referred_by").cast(StringType())) \
    .withColumn("blood_type", F.col("blood_type").cast(StringType())) \
    .withColumn("phone", F.col("phone").cast(StringType()))

# Write cleaned data to S3 as Parquet with snappy compression
df_typed.write \
    .mode("overwrite") \
    .option("compression", "snappy") \
    .parquet("s3://lab1-processed-data-david/patient-data/")

job.commit()