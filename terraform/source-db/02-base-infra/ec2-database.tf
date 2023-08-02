
# Allow all outbound connections
resource "aws_security_group" "database" {
  vpc_id      = module.vpc.vpc_id
  name        = "database"
  description = "Security group for db instance"
}

resource "aws_security_group_rule" "database-egresss" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.database.id
}

resource "aws_security_group_rule" "database-ingress" {
  type              = "ingress"
  to_port           = 3306
  from_port         = 3306
  protocol          = "tcp"
  cidr_blocks       = ["${var.vpc_cidr}"]
  security_group_id = aws_security_group.database.id
}

resource "aws_iam_role" "database-instance-iam-role" {
  name               = "database-instance-role"
  description        = "The assume role for the bastion EC2"
  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
    }
    }
EOF
}

// create an ec2 instance role
resource "aws_iam_instance_profile" "database-iam-profile" {
  name = "ec2_database_profile"
  role = aws_iam_role.database-instance-iam-role.name
}

resource "aws_iam_role_policy_attachment" "database-resources-ssm-policy" {
  role       = aws_iam_role.database-instance-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

module "ec2_instances_db" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"
  count   = 1

  name = "lab-aws-dms-database"

  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.database.id]
  subnet_id              = module.vpc.private_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.database-iam-profile.name

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Scope       = "private"
  }

  user_data_base64 = filebase64("${path.module}/provision-source-database.sh")
}
