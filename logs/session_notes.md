# Session Notes – Lab 1: Secure ETL Pipeline

## ⏱️ Session 1 – Secure AWS Setup

**Date**: 2025-05-02  
**Environment**: Personal AWS account with budget alerts and full encryption enabled  
**Goal**: Set up secure S3 buckets, encrypted upload pipeline, KMS key, and IAM role.

### ✅ Actions Completed
- Created S3 buckets: `lab1-raw-data-david`, `lab1-processed-data-david`
- Uploaded `realistic_patient_data_10k.csv` to raw bucket
- Created a custom KMS key for encryption
- Created and attached IAM role with least privilege access to S3 and KMS

### 🧩 Issues Encountered

- **KMS key re-creation on every run**  
  The initial `create_kms_key.sh` script created a new KMS key every time it ran, leading to unnecessary key proliferation. This was resolved by making the script idempotent: it now checks if the key ID file exists before creating a new key.

- **Missing `last-created-key-id.txt` file**  
  The script failed to save or locate the key ID because it used a relative path (`../kms/...`) without considering the current working directory. We fixed this by dynamically computing the absolute path using `$SCRIPT_DIR`.

- **Unencrypted raw data upload**  
  The first upload to S3 did not use encryption. We corrected this by modifying the upload command to use `--sse aws:kms` along with a dynamically injected KMS key ARN.

- **IAM policy generation failed silently**  
  The policy generation script failed when JSON template paths were not found, due to incorrect relative paths. This was addressed by standardizing path resolution using `$SCRIPT_DIR` and verifying the existence of the output directory before writing.

### 📎 References / Resources
- AWS Docs on [KMS Key Policy](https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html)
- IAM JSON editor: [IAM Policy Simulator](https://policysim.aws.amazon.com)

---

## ⏱️ Session 2 –
