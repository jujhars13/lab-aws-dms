
///////////////////// instances

# Allow all outbound connections
resource "aws_security_group" "bastion" {
  vpc_id      = module.vpc.vpc_id
  name        = "${var.prefix}-bastion"
  description = "Security group for bastion"
  tags        = var.project_tags
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
  name               = "${var.prefix}-ec2-bastion"
  description        = "The assume role for the bastion EC2"
  tags               = var.project_tags
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
  name = "${var.prefix}-bastion-ec2-iam_instance_profile"
  role = aws_iam_role.bastion-instance-iam-role.name
  tags = var.project_tags
}

resource "aws_iam_role_policy_attachment" "bastion-resources-ssm-policy" {
  role       = aws_iam_role.bastion-instance-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

module "ec2_instances" {
  name = "${var.prefix}-bastion"

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"
  count   = 1

  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.ec2_instance_type
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.bastion-iam-profile.name

  tags = var.project_tags

  user_data_base64 = filebase64("${path.module}/provision-bastion.sh")
}
