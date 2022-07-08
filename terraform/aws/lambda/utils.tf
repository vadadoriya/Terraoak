resource "aws_security_group" "foo_lambda" {
  name        = "foo_lambda"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.foo_lambda.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.foo_lambda.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "foo_lambda"
  }
}

resource "aws_vpc" "foo_lambda" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "foo_lambda" {
  vpc_id     = aws_vpc.foo_lambda.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "foo_lambda"
  }
}
