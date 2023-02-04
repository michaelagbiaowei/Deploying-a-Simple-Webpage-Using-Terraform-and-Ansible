# VPC

resource "aws_vpc" "server_vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
      Name = "server_vpc"
      }
}


# Internet Gateway

  resource "aws_internet_gateway" "server_internet_gateway" {
    vpc_id = aws_vpc.server_vpc.id
    tags ={
        Name = "server_internet_gateway"
    }
  }


  # Public Route Table

  resource "aws_route_table" "server-route-table-public" {
    vpc_id = aws_vpc.server_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.server_internet_gateway.id
    }

    tags = {
        Name = "server-route-table-public"
    }
  }

# Associate public subnet 1 with public route table

resource "aws_route_table_association" "server-public-subnet1-association" {
    subnet_id      = aws_subnet.server-public-subnet1.id
    route_table_id = aws_route_table.server-route-table-public.id
}


# Associate public subnet 2 with public route table

resource "aws_route_table_association" "server-public-subnet2-association" {
    subnet_id      = aws_subnet.server-public-subnet2.id
    route_table_id = aws_route_table.server-route-table-public.id
}




# Public Subnet-1

resource "aws_subnet" "server-public-subnet1" {
    vpc_id                  = aws_vpc.server_vpc.id
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1a"
    tags = {
        Name = "server-public-subnet1"
    }
}

# Public Subnet-2

resource "aws_subnet" "server-public-subnet2" {
    vpc_id                  = aws_vpc.server_vpc.id
    cidr_block              = "10.0.2.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1b"
    tags = {
        Name = "server-public-subnet2"
    }
}

# Network ACL

resource "aws_network_acl" "server-network-acl" {
    vpc_id    = aws_vpc.server_vpc.id
    subnet_ids = [aws_subnet.server-public-subnet1.id, aws_subnet.server-public-subnet2.id]

 ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}



# Security group for the load balanceer

resource "aws_security_group" "server-load_balancer_sg"  {
    name        = "server-load-balancer-sg"
    description = "Security group for the load balancer"
    vpc_id      = aws_vpc.server_vpc.id


 ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Security Group to allow port 22, 80 and 443

resource "aws_security_group" "server-security-grp-rule" {
  name        = "allow_ssh_http_https"
  description = "Allow SSH, HTTP and HTTPS inbound traffic for public instances"
  vpc_id      = aws_vpc.server_vpc.id
  

 ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.server-load_balancer_sg.id]
  }


 ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.server-load_balancer_sg.id]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   
  }

  tags = {
    Name = "server-security-grp-rule"
  }
}


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

 
# To store the IP addresses of the instances

resource "local_file" "Ip_address" {
  filename = "/..."
  content  = <<EOT
${aws_instance.server1.public_ip}
${aws_instance.server2.public_ip}
${aws_instance.server3.public_ip}
  EOT
}


# Application Load Balancer

resource "aws_lb" "server-load-balancer" {
  name               = "server-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.server-load_balancer_sg.id]
  subnets            = [aws_subnet.server-public-subnet1.id, aws_subnet.server-public-subnet2.id]
  #enable_cross_zone_load_balancing = true
  enable_deletion_protection = false
  depends_on                 = [aws_instance.server1, aws_instance.server2, aws_instance.server3]
}



# The target group

resource "aws_lb_target_group" "server-target-group" {
  name     = "server-target-group"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.server_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}


# The listener

resource "aws_lb_listener" "server-listener" {
  load_balancer_arn = aws_lb.server-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server-target-group.arn
  }
}


# The listener rule

resource "aws_lb_listener_rule" "server-listener-rule" {
  listener_arn = aws_lb_listener.server-listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server-target-group.arn
  }

  condition {
    host_header {
      values = ["terraform-test.maiempire.online"]
    }
  }
}




# Attaching the target group to the load balancer

resource "aws_lb_target_group_attachment" "server-target-group-attachment1" {
  target_group_arn = aws_lb_target_group.server-target-group.arn
  target_id        = aws_instance.server1.id
  port             = 80

}
 
resource "aws_lb_target_group_attachment" "server-target-group-attachment2" {
  target_group_arn = aws_lb_target_group.server-target-group.arn
  target_id        = aws_instance.server2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "server-target-group-attachment3" {
  target_group_arn = aws_lb_target_group.server-target-group.arn
  target_id        = aws_instance.server3.id
  port             = 80 
  
  }













































