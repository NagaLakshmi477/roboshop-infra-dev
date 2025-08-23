resource "aws_instance" "bastion" {
  ami = local.ami_id
  vpc_security_group_ids = local.bastion_sg_id
  # now we need to give subnets if we cannot provide subnets then it will ceate in the default vpc and default subnet
  # but we need roboshop vpc and roboshop subnet(public)
  instance_type = "t3.micro"
  tags = {
    Name = "hello-bastion"
  }
}