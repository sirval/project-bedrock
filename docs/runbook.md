# Runbook

## Terraform Plan Fails

Check that GitHub secrets `AWS_ROLE_ARN`, `TF_STATE_BUCKET`, and `TF_LOCK_TABLE` exist. Confirm that the OIDC role trusts the repository and allows Terraform to manage the required AWS services.

## EKS Nodes Do Not Join

If `enable_nat_gateway = false`, the node group is placed in public subnets for easier bootstrap. If you switch nodes to private subnets, enable NAT or provide another path to ECR, S3, and EKS endpoints.

Useful commands:

```sh
aws eks describe-cluster --name project-bedrock-prod-eks
kubectl get nodes -o wide
kubectl describe node <node-name>
```

## Application Is Not Reachable

Check the namespace, services, and ingress:

```sh
kubectl get pods -n retail
kubectl get svc -n retail
kubectl describe ingress retail-ui -n retail
```

Confirm that the AWS Load Balancer Controller is installed if you use the ALB ingress annotations.

## Lambda Is Not Processing Uploads

Upload test objects under the `incoming/` prefix in the assets bucket. Then check CloudWatch logs for the asset processor function.

```sh
aws s3 cp sample.jpg s3://<asset-bucket>/incoming/sample.jpg
aws logs tail /aws/lambda/project-bedrock-prod-asset-processor --follow
```

## Developer Read-Only Access

The Terraform IAM module creates the `bedrock-dev` user and maps it to the EKS view policy. Kubernetes RBAC also binds the same user name to read-only access in the `retail` namespace.
