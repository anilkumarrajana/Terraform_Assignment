############################
# EC2 Assume Role Policy
############################

data "aws_iam_policy_document" "ec2_assume_role" {

  statement {

    actions = [
      "sts:AssumeRole"
    ]

    principals {

      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]

    }

  }

}

############################
# IAM Role
############################

resource "aws_iam_role" "ec2_role" {

  name = "travelmemory-ec2-role"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

}

############################
# Attach SSM Managed Policy
############################

resource "aws_iam_role_policy_attachment" "ssm" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}

############################
# Instance Profile
############################

resource "aws_iam_instance_profile" "ec2_profile" {

  name = "travelmemory-instance-profile"

  role = aws_iam_role.ec2_role.name

}