output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.travelmemory_vpc.id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "Private Subnet ID"
  value       = aws_subnet.private_subnet.id
}

output "web_server_public_ip" {
  description = "Public IP of Web Server"
  value       = aws_instance.web_server.public_ip
}

output "web_server_private_ip" {
  description = "Private IP of Web Server"
  value       = aws_instance.web_server.private_ip
}

output "mongodb_private_ip" {
  description = "Private IP of MongoDB Server"
  value       = aws_instance.mongodb_server.private_ip
}