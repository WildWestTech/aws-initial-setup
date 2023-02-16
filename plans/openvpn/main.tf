#This block defines where the state file will be stored
#Because we are creating the bucket and dynamodb table, we need to comment this section of code on the first deployment
#Once the bucket and dynamodb table have been created, we need to uncomment this section and redeploy
#Take note of any local state files.  We do not want to publish that information to github.

#terraform init
#terraform apply
#uncomment the terraform block
#terraform init
#follow prompt to copy state file to s3 bucket
#make sure to remove any sensitive terraform state files before pushing to git
#moving forward, we will reference the backend statefile, so there should be no risk of it being exposed publicly in source control

terraform {
    backend "s3" {
        bucket          = "wildwesttech-terraform-backend-state-openvpn"
        key             = "terraform-s3-backend-setup-openvpn/terraform.tfstate"
        region          = "us-east-1"
        dynamodb_table  = "terraform-state-locking"
        encrypt         = true
        profile         = "785888383526_AdministratorAccess"
    }
}


#dev profile and region
provider "aws" {
    profile = "785888383526_AdministratorAccess"
    region  = "us-east-1"
}

#Where we will store our state files
resource "aws_s3_bucket" "terraform_state" {
    bucket = "wildwesttech-terraform-backend-state-openvpn"
    lifecycle {
        prevent_destroy = true
    }
}

#for statefile history
resource "aws_s3_bucket_versioning" "terraform_state" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
      status = "Enabled"
    }
}

#Encrypt the bucket to be safe
#But I think AWS recently started encrypting buckets by defaul
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
    bucket = aws_s3_bucket.terraform_state.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

#Block public access to bucket
resource "aws_s3_bucket_public_access_block" "terraform_state" {
    bucket                  = aws_s3_bucket.terraform_state.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

#Used for locking the state file
#We want to prevent simultaneous writes on the state file
resource "aws_dynamodb_table" "terraform_locks" {
    name            = "terraform-state-locking"
    billing_mode    = "PAY_PER_REQUEST"
    hash_key        = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
}