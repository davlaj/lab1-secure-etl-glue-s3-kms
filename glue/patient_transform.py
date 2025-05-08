# Minimal cleaning script for the sake of the lab

from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
import sys

args = getResolvedOptions(sys.argv, ['JOB_NAME'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Load raw data from S3
raw_data = glueContext.create_dynamic_frame.from_options(
    format_options={"withHeader": True},
    connection_type="s3",
    format="csv",
    connection_options={"paths": ["s3://lab1-raw-data-david/patient-data"]},
    transformation_ctx="raw_data"
)

# Convert to DataFrame and drop nulls
df = raw_data.toDF()
df_cleaned = df.dropna()

# (Optional) Lowercase column names
df_cleaned = df_cleaned.toDF(*[c.lower() for c in df_cleaned.columns])

# Write back to S3 as Parquet
df_cleaned.write.mode("overwrite").parquet("s3://lab1-processed-data-david/patient-data/")

job.commit()