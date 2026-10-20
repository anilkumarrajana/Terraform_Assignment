####################################
# Latest Ubuntu 24.04 LTS AMI
####################################

data "aws_ami" "ubuntu" {

  most_recent = true

  owners = ["099720109477"]

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

####################################
# Public EC2 - Web Server
####################################

resource "aws_instance" "web_server" {

  ami = data.aws_ami.ubuntu.id

  instance_type = var.instance_type

  subnet_id = aws_subnet.public_subnet.id

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  key_name = var.key_name

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "TravelMemory-WebServer"
  }

}

####################################
# Private EC2 - MongoDB
####################################

resource "aws_instance" "mongodb_server" {

  ami = data.aws_ami.ubuntu.id

  instance_type = var.instance_type

  subnet_id = aws_subnet.private_subnet.id

  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.mongodb_sg.id
  ]

  key_name = var.key_name

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "TravelMemory-MongoDB"
  }

}