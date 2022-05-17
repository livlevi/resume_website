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



# create database to hold last record

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

resource "aws_dynamodb_table_item" "dd_table_01_items" {
  table_name = aws_dynamodb_table.ddb_table_01.name
  hash_key   = aws_dynamodb_table.ddb_table_01.hash_key
  range_key = aws_dynamodb_table.ddb_table_01.range_key

  item = <<ITEM
{
  "last_rec_id": {"N": "0"},
  "last_rec": {"N": "0"}

}
ITEM
}

  # "last_rec": {"N": "0"} */

# create db to store visit count

resource "aws_dynamodb_table_item" "dd_table_02_items" {
  table_name = aws_dynamodb_table.ddb_table_02.name
  hash_key   = aws_dynamodb_table.ddb_table_02.hash_key
  range_key = aws_dynamodb_table.ddb_table_02.range_key

  item = <<ITEM
{
  "visit_id": {"N": "0"},
  "visit_counter": {"N": "0"}
}
ITEM
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



# create lambda execution role


# create lambda function that retrieves the last visit count
# add the code to the lambda function
# create lambda that updates the visit count
# create API gateway with two resources and two methods
# create get method with lambda proxy authentication
# create post method with lambda proxy authentication
# retrieve API link (this needs to be passed to the static web files, one options might be to # create cname / alias in route53 and assign the API links to it)
# create lambda function to send email
# create lambda function to send sms
# create step function
# create API gateway with one resource and one method to send information to step function
# create s3 buckets

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
# configure s3 for web access
# configure cloudfront distribution
# create route53 records

output "bucket_name" { 
    value = aws_s3_bucket.s3website.id

}

output "bucket_endpoint" { 
    value = aws_s3_bucket.s3website.website_endpoint
}

output "bucket_domain" { 
    value = aws_s3_bucket.s3website.website_domain
}