terraform {
  backend "s3" {
    bucket = "sudha-terraform-statefile"
    key = "server_name/statefile"
    region = "us-east-1"
  }
}  
