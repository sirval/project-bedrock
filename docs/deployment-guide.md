# Deployment Guide

## Prerequisites

- AWS account with permissions for VPC, EKS, IAM, S3, DynamoDB, Lambda, CloudWatch, and optional RDS/ElastiCache.
- Terraform 1.6 or newer.
- `kubectl` configured after EKS creation.
- GitHub repository secrets:
  - `AWS_ROLE_ARN`
  - `TF_STATE_BUCKET`
  - `TF_LOCK_TABLE`
- Optional GitHub variable:
  - `AWS_REGION`

## 1. Bootstrap Remote State

```sh
cd terraform/backend
terraform init
terraform apply
```

Copy the `state_bucket_name` and `lock_table_name` outputs into `terraform/envs/prod/backend.tf` or provide them through the GitHub workflow backend config.

## 2. Configure Production Inputs

```sh
cd terraform/envs/prod
cp terraform.tfvars.example terraform.tfvars
```

Review the defaults. `enable_rds`, `enable_redis`, and `enable_nat_gateway` are false to keep assessment deployments smaller.

## 3. Deploy Infrastructure

```sh
terraform init
terraform plan
terraform apply
```

The same plan/apply flow is available through:

- `.github/workflows/terraform-plan.yml`
- `.github/workflows/terraform-apply.yml`

## 4. Deploy Kubernetes Resources

```sh
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/rbac/bedrock-dev-view.yaml
kubectl apply -f k8s/ingress/ui-ingress.yaml
```

Use `k8s/retail-app/values.yaml` with the retail application Helm chart values.

## 5. Verify

```sh
kubectl get nodes
kubectl get pods -n retail
kubectl get ingress -n retail
aws lambda get-function --function-name project-bedrock-prod-asset-processor
```
