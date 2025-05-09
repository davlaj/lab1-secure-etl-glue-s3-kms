# Lab 1 – Secure ETL Pipeline with AWS Glue, S3, IAM, KMS and QuickSight

## 🧠 Context

This lab simulates a real-world scenario where a healthcare company ("HealthPlus") needs to securely process and analyze sensitive medical data using AWS-native tools. The pipeline must respect data privacy, security, and regulatory best practices, while preparing the data for analytical dashboards.

---

## 🎯 Objectives

- Ingest raw sensitive data stored in S3
- Clean and transform it with AWS Glue
- Secure storage using encryption at rest (KMS)
- Apply IAM policies following the principle of least privilege
- Log all operations for auditability
- Build a visual dashboard in Amazon QuickSight

---

## 🧱 Architecture

![Architecture Diagram](https://github.com/davlaj/lab1-secure-etl-glue-s3-kms/blob/main/architecture/lab1-secure-etl-glue-s3-kms.drawio.png?raw=true)

---

## 🧰 AWS Services Used

- **Amazon S3**: Raw and processed data storage
- **AWS KMS**: Encryption key for sensitive output
- **AWS IAM**: Fine-grained permissions and service roles
- **AWS Glue**: ETL pipeline (crawler + job)
- **AWS CloudTrail & CloudWatch**: Logging and auditing
- **Amazon QuickSight**: Final dashboard and reporting

---

## 🧪 Lab Steps

### ✅ Environment Setup
- [x] Create S3 buckets (`raw`, `processed`)
- [x] Create a custom symmetric KMS key
- [x] Upload encrypted patient data (CSV) with SSE-KMS
- [x] Define IAM role for AWS Glue with least privilege
- [x] Enable CloudTrail and configure audit log S3 bucket

### ✅ ETL Pipeline
- [x] Create Glue Crawler for raw dataset
- [x] Create PySpark Glue Job for cleaning & transformation
- [x] Write output to encrypted S3 bucket (`processed`)

### ✅ Validation and Audit
- [x] **Check encryption (SSE-KMS or SSE-S3) is applied on data at rest**  
  Executed audit script `cli/audit_s3_encryption.sh`:  
    - `lab1-raw-data-david` uses **SSE-KMS** with custom KMS Key.  
    - `lab1-processed-data-david` uses **SSE-S3** with AES-256 encryption by default.  

- [x] **Validate Glue Catalog and schema**  
  Executed audit script `cli/audit_glue_catalog.sh` to:
    - List all tables in the `lab1_glue_db` database.  
    - Confirm the processed dataset table exists and the schema matches expectations.

- [X] **Enable and inspect CloudTrail (S3 access, KMS usage, IAM activity)**  
    - Ensure CloudTrail is enabled.  
    - Verify S3, KMS, and IAM events are being logged by running test activities and checking logs.

- [x] **Set retention policy for CloudTrail + cost-efficient log storage**  
    - Navigate to CloudWatch → Log groups → Select CloudTrail log group.  
    - Set a retention policy (e.g., 30 days) to minimize cost while retaining necessary audit data.

- [x] **Inspect logs in CloudWatch Logs (Glue Job runtime)**  
    - Navigate to CloudWatch → Log groups.  
    - Inspect recent log streams related to Glue jobs and CloudTrail.  

### ✅ Visualization with QuickSight
- [x] Connect QuickSight to processed dataset
- [x] Create visuals (age, country, condition, map)
- [x] Apply row-level access controls

---

## 🚀 Usage

Follow these steps to provision resources, execute the ETL pipeline, and validate security controls.  
Ensure the AWS CLI is configured with the correct profile and region before starting.  
_All commands must be run from the root directory of the repository._

To allow script execution (one-time setup), run:
```bash
chmod +x cli/*.sh
```

### 📦 **Environment Setup & ETL Execution**

```bash
# 1. Create S3 buckets for raw and processed data
bash cli/create_buckets.sh

# 2. Create a symmetric KMS key and store its Key ID for later use
bash cli/create_kms_key.sh

# 3. Upload raw CSV data to S3 with SSE-KMS encryption
bash cli/upload_raw_data.sh

# 4. Generate the IAM policy for Glue dynamically from a template
bash cli/generate_glue_policy.sh

# 5. Create IAM role for Glue with trust policy and inline policy
bash cli/create_glue_role.sh

# 6. Create an S3 bucket for CloudTrail logs with proper security controls
bash cli/create_cloudtrail_bucket.sh

# 7. Enable a multi-region CloudTrail trail and start logging
bash cli/enable_cloudtrail.sh

# 8. Enable CloudWatch log streaming for CloudTrail
bash cli/enable_cloudwatch_logs_for_cloudtrail.sh

# 9. Set CloudWatch Logs retention policy (30 days)
bash cli/set_log_retention.sh

# 10. Upload the Glue transformation script to S3
bash cli/upload_patient_transform_script.sh

# 11. Create the Glue job to run the ETL process
bash cli/create_glue_job.sh

# 12. Execute the Glue job to process data
bash cli/run_glue_job.sh

# 13. Create the Glue crawler for processed data
bash cli/create_glue_crawler.sh

# 14. Run the Glue crawler to populate the Glue Catalog
bash cli/run_glue_crawler.sh
```

### 🔐 **Audit & Security Validation**

``` bash
# 1. Audit S3 buckets to verify encryption and security policy enforcement
bash cli/audit_s3_encryption.sh

# 2. Validate Glue Data Catalog contains expected tables and schemas
bash cli/audit_glue_catalog.sh
```

## 🧹 Cleanup

To remove all AWS resources created by this lab and avoid unnecessary costs, run:

```bash
bash cli/cleanup_lab.sh
```

---

## 💸 Cost Protection & Monitoring

This project was conducted in a personal AWS account with all billing safety mechanisms enabled:

- ✅ **Budget Alerts**:
  - `Zero-Spend Budget`: alerts when costs exceed $0.01
  - `Monthly Budget`: $5/month soft limit with email alerts at 85% and 100%
  
- ✅ **Anomaly Detection Monitor**:
  - Name: `aws-lab-anomaly-monitor`
  - Monitors total monthly spend at the account level
  - Uses Amazon SNS for immediate alerting in case of spending spikes

- ✅ **Manual Cleanup Script**:
  - All lab resources are cleaned up with `cli/cleanup_lab.sh`

These safeguards ensure full cost transparency and control throughout the lab process.

---

## 💸 Security Considerations

This lab enforces production-grade security and cost governance:

- ✅ Budget alerts and cost anomaly detection are enabled
- ✅ Raw data is encrypted at rest using KMS (SSE-KMS) when uploaded from on-premise to S3
- ✅ Default bucket encryption (SSE-S3) is applied to the processed data bucket
- ✅ IAM roles and policies are auto-generated with strict least-privilege rules
- ✅ KMS keys are reused safely unless explicitly deleted
- ✅ Glue jobs run in isolated, AWS-managed infrastructure with in-transit encryption (TLS) and encrypted temporary storage
- ✅ While in-memory data during Glue job execution is not encrypted (by design), it is processed securely within AWS Glue’s isolated environment, which is compliant with SOC 2, ISO 27001, HIPAA, and GDPR

---

## 📖 Key Learnings

- ✅ Designed and implemented a secure ETL pipeline using AWS Glue, S3, and KMS.
- ✅ Enforced encryption at rest (SSE-KMS and SSE-S3) and in transit (TLS).
- ✅ Automated resource provisioning and cleanup using AWS CLI scripts.
- ✅ Properly configured IAM roles and policies following the principle of least privilege.
- ✅ Managed and scheduled deletion of sensitive AWS resources, including KMS keys and CloudTrail logs.
- ✅ Integrated data visualization using Amazon QuickSight for business insights.
- ✅ Applied best practices for monitoring and auditing with CloudTrail and CloudWatch Logs.

---

## 🧠 Author & Motivation

This project is part of a hands-on AWS portfolio to demonstrate secure cloud data engineering capabilities.  
Feel free to fork, improve, or suggest enhancements via issues or pull requests.
