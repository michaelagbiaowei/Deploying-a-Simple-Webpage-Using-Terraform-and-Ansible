#  instance 1

resource "aws_instance" "server1" {
  ami             = "ami-00874d747dde814fa"
  instance_type   = "t2.micro"
  key_name        = "circle"
  security_groups = [aws_security_group.server-security-grp-rule.id]
  subnet_id       = aws_subnet.server-public-subnet1.id
  availability_zone = "us-east-1a"

  tags = {
    Name   = "server1"
    source = "terraform"
  }
}

# instance 2

 resource "aws_instance" "server2" {
  ami             = "ami-00874d747dde814fa"
  instance_type   = "t2.micro"
  key_name        = "circle"
  security_groups = [aws_security_group.server-security-grp-rule.id]
  subnet_id       = aws_subnet.server-public-subnet2.id
  availability_zone = "us-east-1b"
  

  tags = {
    Name   = "server2"
    source = "terraform"
  }
}


# instance 3

resource "aws_instance" "server3" {
  ami             = "ami-00874d747dde814fa"
  instance_type   = "t2.micro"
  key_name        = "circle"
  security_groups = [aws_security_group.server-security-grp-rule.id]
  subnet_id       = aws_subnet.server-public-subnet1.id
  availability_zone = "us-east-1a"

  

  tags = {
    Name   = "server3"
    source = "terraform"
  }
}

