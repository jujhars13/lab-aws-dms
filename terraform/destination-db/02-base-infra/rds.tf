module "cluster" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name            = "${var.prefix}-destination"
  engine          = "aurora-mysql"
  engine_version  = "8.0"
  master_username = "root"
  instance_class  = "db.t4g.medium"
  instances = {
    1 = {
      publicly_accessible = false
    }
  }

  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = "${var.prefix}-db-subnet-group"
  security_group_rules = {
    ex1_ingress = {
      cidr_blocks = ["10.0.52.0/24"]
    }
    ex1_ingress = {
      source_security_group_id = aws_security_group.bastion.id
    }
  }

  storage_encrypted   = true
  apply_immediately   = true
  skip_final_snapshot = true
  monitoring_interval = 10

  tags                            = var.tags
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  db_cluster_parameter_group_name        = local.name
  db_cluster_parameter_group_family      = "aurora-mysql8.0"
  db_cluster_parameter_group_description = "${local.name} cluster parameter group"
  db_cluster_parameter_group_parameters = [
    {
      name         = "connect_timeout"
      value        = 120
      apply_method = "immediate"
    }
  ]

  create_db_parameter_group      = true
  db_parameter_group_name        = local.name
  db_parameter_group_family      = "aurora-mysql8.0"
  db_parameter_group_description = "${local.name} DB parameter group"
  db_parameter_group_parameters = [
    {
      name         = "connect_timeout"
      value        = 60
      apply_method = "immediate"
    }
  ]
}
