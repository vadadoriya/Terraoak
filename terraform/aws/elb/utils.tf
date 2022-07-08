data "aws_caller_identity" "current" {}
resource "aws_s3_bucket" "foo_lb_logs" {
  bucket_prefix = "foo-lb-logs"
  acl           = "private"
  force_destroy = true
  tags = {
    Name = "My bucket"
  }
}

resource "aws_s3_bucket_policy" "foo_lb_logs" {
  bucket = aws_s3_bucket.foo_lb_logs.id
  policy = data.aws_iam_policy_document.foo_lb_logs.json
}

data "aws_iam_policy_document" "foo_lb_logs" {
  statement {
    sid = ""
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::033677994240:root"]
    }
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.foo_lb_logs.id}/*",
    ]
  }
  statement {
    sid = ""
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.foo_lb_logs.id}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.foo_lb_logs.id}",
    ]
  }
}

resource "aws_vpc" "foo_lb" {
  cidr_block = "10.20.0.0/16"

  tags = {
    Name = "foo_lb"
  }
}

resource "aws_security_group" "bar" {
  name        = "bar"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.foo_lb.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["10.20.3.0/24"]
    ipv6_cidr_blocks = []
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "bar"
  }
}

resource "aws_subnet" "application" {
  vpc_id            = aws_vpc.foo_lb.id
  cidr_block        = "10.20.3.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "tf-example"
  }
}


resource "aws_subnet" "backup" {
  vpc_id            = aws_vpc.foo_lb.id
  cidr_block        = "10.20.5.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_network_interface" "bar" {
  subnet_id   = aws_subnet.application.id
  private_ips = ["10.20.3.102"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "bar" {
  ami           = "ami-00399ec92321828f5" # us-west-2
  instance_type = "t2.micro"
  network_interface {
    network_interface_id = aws_network_interface.bar.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.foo_lb.id

  tags = {
    Name = "foo"
  }
}

resource "aws_eip" "foo" {
  vpc                       = true
  associate_with_private_ip = "10.20.3.101"
}

resource "aws_eip" "bar" {
  vpc                       = true
  associate_with_private_ip = "10.20.3.16"
}