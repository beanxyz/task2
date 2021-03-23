data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}



data "aws_subnet_ids" "all" {
  vpc_id = module.vpc.vpc_id
}


resource "aws_key_pair" "master-key" {

  key_name   = "Demo"
  public_key = file("~/.ssh/id_rsa.pub")

}



module "ec2_public" {
  source = "terraform-aws-modules/ec2-instance/aws"

  instance_count = 1

  name                        = "jumpbox"
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = tolist(data.aws_subnet_ids.all.ids)[0]
  vpc_security_group_ids      = [module.ssh_security_group_public.this_security_group_id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.master-key.key_name

  tags = {
    "Env" = "Public"

  }
}


module "ec2_private" {
  source = "terraform-aws-modules/ec2-instance/aws"

  instance_count = 1

  name                        = "app"
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  subnet_id                   = tolist(data.aws_subnet_ids.all.ids)[1]
  vpc_security_group_ids      = [module.ssh_security_group_private.this_security_group_id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.master-key.key_name


  tags = {
    "Env" = "Public"

  }
}

