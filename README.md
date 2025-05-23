# 📂 Scalable File Upload System (AWS + Terraform)

This project is a fully serverless, secure, and scalable file upload system designed to handle KYC document submissions (National ID, Passport, Driver’s License) with automated validation, malware checks, and document processing. It's built using AWS services and managed entirely with Terraform.

The goal was to demonstrate end-to-end cloud architecture and infrastructure-as-code, focusing on a real-world use case — customer document uploads for compliance.

---

## 🧩 Key Features

- **Pre-Signed S3 Uploads**: Secure and temporary upload links generated via API Gateway + Lambda.
- **Malware Scan Hook**: Documents are validated for malware before processing.
- **Document Text Extraction**: Uses Amazon Textract to extract and compare data (e.g., name, ID number).
- **Data Validation**: Extracted fields are matched against existing customer records in a PostgreSQL database.
- **Admin Notifications**: Any mismatches or validation failures trigger an EventBridge rule that routes the event to an alerting Lambda (can be extended to send Slack/email alerts).
- **Fully Infrastructure as Code**: All AWS resources are provisioned using Terraform for repeatability and control.

---

## 🛠️ Stack

- **Cloud**: AWS (API Gateway, Lambda, S3, EventBridge, Textract, RDS PostgreSQL)
- **IaC**: Terraform
- **Language**: Python (Lambda functions)
- **Security**: IAM roles with least privilege, S3 encryption, input validation
- **Storage**: Amazon S3 (documents), Amazon RDS (PostgreSQL for metadata)

---

## 🚀 Why This Project

This system was designed to show:
- How to architect for **scalability and compliance**
- How to automate validation and **fail securely**
- Practical use of AWS services **in combination**
- My ability to communicate and build real-world cloud systems, end-to-end

---

🧠 Lessons Learned
This project helped me deepen my understanding of:

Secure S3 usage with presigned URLs

Event-driven design using EventBridge

Practical trade-offs between SES, SNS, EventBridge

Building infrastructure that's clean and reproducible using Terraform

📬 Contact
If you're a recruiter, architect, or engineer curious about the details — feel free to reach out or open an issue. I'd be happy to walk you through the thought process or architecture.

