
# Define your resources, such as EC2 instances, S3 buckets, etc.
resource "aws_instance" "sudha-terraform" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = "sudha_key"
  count = 2
  security_groups = ["launch-wizard-7"]

  tags = {
    Environment = "dev"
    Name = "sudha-terraform_${count.index + 1}"
  }
}
