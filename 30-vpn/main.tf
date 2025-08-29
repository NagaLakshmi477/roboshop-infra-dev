# consider you don't have key in aws 
# resource "aws_key_pair" "openvpn" {
#   key_name = "openvpn"
#   public_key = fie("") #path
# }

resource "aws_instance" "vpn" {
    ami = local.ami_id
    instance_type = "t3.micro"
    key_name = "ramesh"
    vpc_security_group_ids = [local.vpn_sg_id]
    subnet_id = local.public_subnet_id
    user_data = file("openvpn.sh")
  tags = merge(
    local.common_tags,{
        Name = "${var.project}-${var.environment}-vpn"
    }
  )
}