data "aws_caller_identity" "current" {}

locals {
  asset_bucket_name = var.asset_bucket_name != "" ? var.asset_bucket_name : "${var.name_prefix}-assets-${data.aws_caller_identity.current.account_id}"
}

data "archive_file" "asset_processor" {
  type        = "zip"
  source_dir  = var.lambda_source_dir
  output_path = "${path.root}/.terraform/${var.name_prefix}-asset-processor.zip"
}

resource "aws_s3_bucket" "assets" {
  bucket        = local.asset_bucket_name
  force_destroy = var.force_destroy_bucket

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "lambda" {
  name = "${var.name_prefix}-asset-processor-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_assets" {
  name = "${var.name_prefix}-asset-processor-s3"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectTagging"
        ]
        Resource = "${aws_s3_bucket.assets.arn}/*"
      }
    ]
  })
}

resource "aws_lambda_function" "asset_processor" {
  function_name    = "${var.name_prefix}-asset-processor"
  description      = "Processes uploaded retail assets and tags them as processed."
  role             = aws_iam_role.lambda.arn
  handler          = "index.handler"
  runtime          = "python3.12"
  filename         = data.archive_file.asset_processor.output_path
  source_code_hash = data.archive_file.asset_processor.output_base64sha256
  timeout          = 30
  memory_size      = 256

  environment {
    variables = {
      ASSET_BUCKET = aws_s3_bucket.assets.bucket
      ENVIRONMENT  = var.name_prefix
    }
  }

  tags = var.tags

  depends_on = [aws_iam_role_policy_attachment.lambda_basic]
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromAssetsBucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asset_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.assets.arn
}

resource "aws_s3_bucket_notification" "assets" {
  bucket = aws_s3_bucket.assets.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.asset_processor.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "incoming/"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
