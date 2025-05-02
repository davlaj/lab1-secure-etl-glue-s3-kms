# Session Notes – Lab 1: Secure ETL Pipeline

## ⏱️ Session 1 – Environment Setup

**Date**: 2025-05-02  
**Sandbox Duration**: 3 hours  
**Goal**: Create S3 buckets, upload data, set up KMS key and IAM role.

### ✅ Actions Completed
- Created S3 buckets: `lab1-raw-data-davlaj`, `lab1-processed-data-davlaj`
- Uploaded `realistic_patient_data_10k.csv` to raw bucket
- Created a custom KMS key for encryption
- Created and attached IAM role with least privilege access to S3 and KMS

### 🧩 Issues Encountered
- [e.g., Permission error accessing KMS from Glue]
- [e.g., IAM policy needed wildcard for resource]

### 📎 References / Resources
- AWS Docs on [KMS Key Policy](https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html)
- IAM JSON editor: [IAM Policy Simulator](https://policysim.aws.amazon.com)

---
