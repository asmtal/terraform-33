output "bucket_traces_arn" {
  value = aws_s3_bucket.traces.arn
}

output "bucket_catpost_arn" {
  value = aws_s3_bucket.catpost.arn
}
