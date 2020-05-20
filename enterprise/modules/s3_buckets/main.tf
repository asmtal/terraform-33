resource "aws_s3_bucket" "traces" {
  bucket_prefix = var.bucket_prefix
  acl           = "private"
}

resource "aws_s3_bucket" "catpost" {
  bucket_prefix = var.bucket_prefix
  acl           = "private"

  lifecycle_rule {
    enabled = true

    expiration {
      days = var.expiration_days
    }
  }
}

resource "aws_s3_bucket_policy" "catpost_bucket_policy" {
  bucket = aws_s3_bucket.catpost.id
  policy = data.aws_iam_policy_document.catpost_bucket_policy.json
}

data "aws_iam_policy_document" "catpost_bucket_policy" {
  statement {
    actions = [
      "s3:*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:sourceVpce"
      values   = [aws_vpc_endpoint.catpost.id]
    }

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    resources = [
      "${aws_s3_bucket.catpost.arn}/*"
    ]
  }
}

resource "aws_vpc_endpoint" "catpost" {
  vpc_id          = var.vpc_id
  service_name    = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = var.catpost_vpc_endpoint_route_table_ids
  policy          = data.aws_iam_policy_document.catpost_vpc_endpoint.json
}

data "aws_iam_policy_document" "catpost_vpc_endpoint" {
  statement {
    actions = [
      "*"
    ]

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    resources = [
      "*"
    ]
  }
}
