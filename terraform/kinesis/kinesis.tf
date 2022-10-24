resource "aws_kinesis_stream" "foo_stream" {
  name                      = "foo-kinesis-stream"
  shard_count               = 1
  enforce_consumer_deletion = false
  encryption_type           = ""
  kms_key_id                = aws_kms_key.foo_kinesis.arn # Must be configured
  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  # Must be present
  tags = {
    Environment = "test"
  }
}

resource "aws_kinesis_stream_consumer" "foo_stream_consumer" {
  # All options # Must be configured
  name       = "foo-kinesis-consumer"
  stream_arn = aws_kinesis_stream.foo_stream.arn
}
