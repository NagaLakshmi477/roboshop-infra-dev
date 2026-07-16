resource "aws_instance" "name" {
  ami = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = local.bastion_sg_id
  #subnet_id = 
}