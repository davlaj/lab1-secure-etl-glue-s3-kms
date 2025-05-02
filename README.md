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

                +--------------+
                | Raw CSV (S3) |
                +------+-------+
                       |
                       v
               +-------+--------+
               |  Glue Crawler  |
               +-------+--------+
                       |
                       v
              +--------+-----------+
              | Glue Job (PySpark) |
              +--------+-----------+
                       |
                       v
          +------------+--------------+
          | Encrypted Clean Data (S3) |
          +------------+--------------+
                       |
                       v
               +-------+--------+
               |  QuickSight    |
               |  Dashboard     |
               +----------------+

---

## 🧰 AWS Services Used

- **Amazon S3**: Raw and processed data storage
- **AWS KMS**: Encryption key for sensitive output
- **AWS IAM**: Fine-grained permissions and service roles
- **AWS Glue**: ETL pipeline (crawler + job)
- **AWS CloudTrail & CloudWatch**: Logging and auditing
- **Amazon QuickSight**: Final dashboard and reporting

---

## 🧪 Lab Blocks

This lab is divided into short 3-hour blocks to fit within the Tutorials Dojo AWS sandbox time limits.

### ✅ Block 1 — Environment Setup
- [x] Create S3 buckets (`raw`, `processed`)
- [x] Upload anonymized patient data (CSV)
- [x] Create a custom symmetric KMS key
- [x] Define IAM role for AWS Glue with least privilege

### ⏳ Block 2 — ETL Pipeline
- [ ] Create Glue Crawler for raw dataset
- [ ] Create PySpark Glue Job for cleaning & transformation
- [ ] Write output to encrypted S3 bucket

### ⏳ Block 3 — Validation and Audit
- [ ] Check KMS encryption
- [ ] Validate Glue Catalog
- [ ] Inspect logs (CloudWatch, CloudTrail)

### ⏳ Block 4 — Visualization with QuickSight
- [ ] Connect QuickSight to processed dataset
- [ ] Create visuals (age, country, condition, map)
- [ ] Apply row-level access controls (if needed)

---

## 📝 Notes & Logs

See [`logs/session_notes.md`](logs/session_notes.md) for detailed session steps and issues encountered.

---

## 📸 Screenshots

See [`screenshots/`](screenshots/) for architecture, dashboard, and audit evidence.

---

## 🧠 Author & Motivation

This project is part of a hands-on AWS portfolio to demonstrate secure cloud data engineering capabilities.  
Feel free to fork, improve, or suggest enhancements via issues or pull requests.
