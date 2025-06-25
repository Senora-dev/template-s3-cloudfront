# CloudFront with S3 Origin Template

This template deploys a secure, scalable, and high-performance static website using an S3 bucket for hosting and a CloudFront distribution for content delivery. The S3 bucket is **private** and accessible **only via CloudFront** using an Origin Access Identity (OAI).

## Overview

This template provides the core infrastructure for hosting a static website on AWS. It includes:

-   An **S3 Bucket** (private, not public) for static content, accessible only via CloudFront OAI.
-   A **CloudFront Distribution** to cache and serve your content globally, providing low-latency access to your users.
-   A **CloudFront Origin Access Identity (OAI)** to ensure that your S3 content is only accessible through CloudFront.
-   **CloudWatch Alarms** for monitoring the health of the CloudFront distribution (e.g., 4xx and 5xx error rates).

The infrastructure code is located in the `infra/` directory and is managed by Terraform. Example static content is in the `app/` directory.

## How to Use

First, navigate to the `infra` directory:
```sh
cd infra
```

Then, you can initialize and deploy the infrastructure:

1.  **Initialize Terraform:**
    ```sh
    terraform init
    ```

2.  **Plan the deployment:**
    Review the `variables.tf` file for available parameters. You must provide at least `bucket_name` and `distribution_name`. To ensure the S3 bucket name is globally unique, a random suffix will be automatically appended to the name you provide.
    ```sh
    terraform plan -var="bucket_name=my-static-site" -var="distribution_name=my-static-site"
    ```

3.  **Apply the configuration:**
    Confirm the plan to deploy your infrastructure. The final bucket name will be shown in the output.
    ```sh
    terraform apply -var="bucket_name=my-static-site" -var="distribution_name=my-static-site"
    ```

## Deploying Your Website

After the infrastructure is deployed, you can upload your website's files to the S3 bucket. The full, unique name of the bucket is available in the Terraform output `bucket_id`.

You can use the AWS CLI to sync your `app` folder to the S3 bucket:
```sh
aws s3 sync ../app s3://$(terraform output -raw bucket_id)
```

Once the files are uploaded, your website will be available at the `distribution_domain_name` provided in the Terraform outputs.

## Main Outputs
- `bucket_id`: The unique S3 bucket name
- `bucket_arn`: The ARN of the S3 bucket
- `distribution_domain_name`: The CloudFront URL for your site
- `origin_access_identity_id`: The CloudFront OAI ID
- `origin_access_identity_iam_arn`: The OAI IAM ARN (used in the S3 bucket policy)

## Security
- The S3 bucket is **not public**. Only CloudFront (via the OAI) can access objects in the bucket.
- The S3 bucket policy is automatically managed by Terraform and grants `s3:GetObject` only to the OAI.

## Troubleshooting
- **Access Denied via CloudFront?**
  - Make sure you uploaded your files to the correct S3 bucket (`bucket_id` output).
  - Ensure the CloudFront distribution is fully deployed (status: Deployed).
  - Wait a few minutes for propagation after changes.
  - The S3 bucket policy must reference the OAI IAM ARN (managed automatically by this template).
  - If you change the OAI or bucket, re-apply Terraform.

---

*This template is maintained by Senora.dev.* 