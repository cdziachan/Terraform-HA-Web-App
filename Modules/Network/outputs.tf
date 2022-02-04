output "vpc_id" {
  value = aws_vpc.prod.id
}

output "availability_zones" {
  value = data.aws_availability_zones.available[*].names
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "web_sg_id" {
  value = aws_security_group.web_sg.id
}
