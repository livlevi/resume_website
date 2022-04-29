terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.10.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.1.0"
}

resource "aws_s3_bucket" "s3website" {
    bucket = "livlevi5.com"
   
    tags = {
        Name = "My bucket"
        Environment = "Dev"
    }
}

resource "aws_s3_bucket_acl" "s3website_acl" {
    bucket = "livlevi5.com"
    acl = "public-read"
}
resource "aws_s3_bucket_website_configuration" "s3website" {
    bucket = "livlevi5.com"

    index_document {
      suffix = "index.html"
    }

    error_document {
      key = "error.html"
    }
}

resource "aws_dynamodb_table" "ddb_table_01" {
  name = "siteLastRecordValue"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "last_rec_id"
  range_key = "last_rec"

  attribute {
    name = "last_rec_id"
    type = "N"
  }

  attribute {
    name = "last_rec"
    type = "N"
  }

  tags = {
    Name = "ddb-tbl-01"
    Environment = "dev"
  }
}

resource "aws_dynamodb_table" "ddb_table_02" {
  name = "siteVisitCounter"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "visit_id"
  range_key = "visit_counter"

  attribute {
    name = "visit_id"
    type = "N"
  }

  attribute {
    name = "visit_counter"
    type = "N"
  }

  tags = {
    Name = "ddb-tbl-02"
    Environment = "dev"
  }
}

output "bucket_name" { 
    value = aws_s3_bucket.s3website.id

}

output "bucket_endpoint" { 
    value = aws_s3_bucket.s3website.website_endpoint
}

output "bucket_domain" { 
    value = aws_s3_bucket.s3website.website_domain
}
