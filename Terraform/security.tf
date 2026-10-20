############################
# Web Server Security Group
############################

resource "aws_security_group" "web_sg" {

  name        = "travelmemory-web-sg"
  description = "Security Group for Web Server"
  vpc_id      = aws_vpc.travelmemory_vpc.id

  ingress {
    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      var.my_ip
    ]
  }

  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    description = "HTTPS"

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    description = "Node Application"

    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }

  tags = {

    Name = "TravelMemory-Web-SG"

  }

}

############################
# MongoDB Security Group
############################

resource "aws_security_group" "mongodb_sg" {

  name        = "travelmemory-mongodb-sg"
  description = "MongoDB Security Group"

  vpc_id = aws_vpc.travelmemory_vpc.id

  ingress {

    description = "MongoDB"

    from_port = 27017
    to_port   = 27017

    protocol = "tcp"

    security_groups = [
      aws_security_group.web_sg.id
    ]

  }

  ingress {

    description = "SSH from Web Server"

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    security_groups = [
      aws_security_group.web_sg.id
    ]

  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }

  tags = {

    Name = "TravelMemory-MongoDB-SG"

  }

}