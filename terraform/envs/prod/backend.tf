terraform {
  backend "s3" {
    bucket       = "project-bedrock-tfstate-ohuka-ikenna"
    key          = "prod/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}