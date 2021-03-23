
module "ssh_security_group_public" {
  source      = "terraform-aws-modules/security-group/aws//modules/ssh"
  name        = "ssh-sg"
  description = "SSH"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}


module "ssh_security_group_private" {
  source      = "terraform-aws-modules/security-group/aws//modules/ssh"
  name        = "app-sg"
  description = "SSH"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["10.0.101.0/24"]
}

