resource "aws_iam_user" "dev" {
  name = var.dev_user_name
  path = "/project-bedrock/"

  tags = var.tags
}

resource "aws_iam_group" "dev_viewers" {
  name = "${var.name_prefix}-dev-viewers"
  path = "/project-bedrock/"
}

resource "aws_iam_group_membership" "dev_viewers" {
  name  = "${var.name_prefix}-dev-viewers"
  group = aws_iam_group.dev_viewers.name
  users = [aws_iam_user.dev.name]
}

resource "aws_iam_policy" "dev_view" {
  name        = "${var.name_prefix}-dev-view"
  description = "Read-only developer permissions for project-bedrock infrastructure."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:AccessKubernetesApi",
          "eks:Describe*",
          "eks:List*",
          "ec2:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*",
          "logs:Describe*",
          "logs:Get*",
          "logs:FilterLogEvents",
          "dynamodb:DescribeTable",
          "dynamodb:ListTables",
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_group_policy_attachment" "dev_view" {
  group      = aws_iam_group.dev_viewers.name
  policy_arn = aws_iam_policy.dev_view.arn
}

resource "aws_eks_access_entry" "dev" {
  cluster_name  = var.eks_cluster_name
  principal_arn = aws_iam_user.dev.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "dev_view" {
  cluster_name  = var.eks_cluster_name
  principal_arn = aws_iam_user.dev.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.dev]
}
