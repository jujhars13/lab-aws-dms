
///////////////////// instances

# Allow all outbound connections
resource "aws_security_group" "bastion" {
  vpc_id      = module.vpc.vpc_id
  name        = "bastion"
  description = "Security group for bastion"
}

resource "aws_security_group_rule" "bastion-egresss" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion.id
}

resource "aws_iam_role" "bastion-instance-iam-role" {
  name               = "bastion-instance-role"
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
resource "aws_iam_instance_profile" "bastion-iam-profile" {
  name = "ec2_profile"
  role = aws_iam_role.bastion-instance-iam-role.name
}

resource "aws_iam_role_policy_attachment" "bastion-resources-ssm-policy" {
  role       = aws_iam_role.bastion-instance-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"
  count   = 1

  name = "lab-aws-dms-bastion-host"

  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.ec2_instance_type
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.bastion-iam-profile.name

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  user_data_base64 = filebase64("${path.module}/provision-source-bastion.sh")
}