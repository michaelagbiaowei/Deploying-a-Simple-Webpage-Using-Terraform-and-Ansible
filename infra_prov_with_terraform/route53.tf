resource "aws_route53_zone" "domain-name" {
    name = "maiempire.online"
    
    tags = {
      Name = "maiempire.online"
    }
}

resource "aws_route53_record" "record" {
    zone_id = aws_route53_zone.domain-name.zone_id
    name = "terraform-test.maiempire.online"
    type = "CNAME"
    ttl = 300
    records = ["${aws_lb.server-load-balancer.dns_name}"]
}
