resource "aws_instance" "name" {
  ami = local.ami_id
}