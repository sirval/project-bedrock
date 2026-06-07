# Project Bedrock Architecture

Project Bedrock deploys the retail sample application on AWS with a modular Terraform layout, Kubernetes application manifests, and a small serverless asset-processing path.

## Layers

- `terraform/backend`: bootstraps the remote Terraform state S3 bucket and DynamoDB lock table.
- `terraform/envs/prod`: composes the production environment from reusable modules.
- `terraform/modules/vpc`: creates the network foundation with public and private subnets.
- `terraform/modules/eks`: creates the EKS control plane, managed node group, and core add-ons.
- `terraform/modules/data-layer`: creates DynamoDB by default, with optional PostgreSQL RDS and Redis.
- `terraform/modules/iam-dev-user`: creates a developer IAM user and read-only EKS access mapping.
- `terraform/modules/observability`: creates CloudWatch log groups, optional CloudWatch EKS add-on, and optional SNS alerts.
- `terraform/modules/serverless`: creates an S3 assets bucket and Lambda processor.
- `k8s`: contains namespace, RBAC, ingress, and Helm values for the retail workload.

## Request Flow

1. Users reach the retail UI through the Kubernetes ingress.
2. The UI communicates with catalog, cart, orders, and checkout services inside the `retail` namespace.
3. Stateful workloads use the data layer: DynamoDB is always available, while RDS and Redis are optional.
4. Uploaded assets land in the S3 assets bucket under `incoming/`.
5. S3 invokes the `asset_processor` Lambda, which marks uploaded objects as processed.
6. EKS and application logs are centralized in CloudWatch.

## Security Model

- GitHub Actions uses OIDC to assume an AWS role instead of long-lived credentials.
- Terraform state is encrypted in S3 and protected by DynamoDB locking.
- EKS developer access is read-only through both IAM and Kubernetes RBAC.
- S3 buckets block public access by default.
- The Lambda execution role is scoped to the asset bucket and CloudWatch logs.
