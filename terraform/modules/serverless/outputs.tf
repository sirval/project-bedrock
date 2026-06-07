output "asset_bucket_name" {
  description = "S3 asset bucket name."
  value       = aws_s3_bucket.assets.bucket
}

output "asset_processor_function_name" {
  description = "Asset processor Lambda function name."
  value       = aws_lambda_function.asset_processor.function_name
}

output "asset_processor_function_arn" {
  description = "Asset processor Lambda function ARN."
  value       = aws_lambda_function.asset_processor.arn
}
