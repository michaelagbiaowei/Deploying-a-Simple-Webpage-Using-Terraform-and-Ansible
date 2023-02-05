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















