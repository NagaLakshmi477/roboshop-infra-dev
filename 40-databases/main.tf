resource "aws_instance" "mongodb" {
  ami = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.mongodb_sg_id]
  subnet_id =local.database_subnet_id
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-mongodb"
    }
  )
}

# now instance is created we need integrate with ansible
# using remote exec we will connect and trigger the ansible

resource "terraform_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb
  ]
provisioner "file" {
  source = "bootstrap.sh"
  destination = "/tmp/bootstrap.sh" 
}
# here connection is done 
connection {
  type = "ssh"
  user = "ec2-user"
  password = "DevOps321"
  host = aws_instance.mongodb.private_ip
}
# now we need to execute the scrpit
provisioner "remote-exec" {
  inline = [ 
    "chmod +x /tmp/bootstrap.sh",
    "sudo sh /tmp/bootstrap.sh mongodb"
   ]
}

}



resource "aws_instance" "redis" {
  ami = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.redis_sg_id]
  subnet_id =local.database_subnet_id
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-redis"
    }
  )
}

# now instance is created we need integrate with ansible
# using remote exec we will connect and trigger the ansible

resource "terraform_data" "redis" {
  triggers_replace = [
    aws_instance.redis
  ]
provisioner "file" {
  source = "bootstrap.sh"
  destination = "/tmp/bootstrap.sh" 
}
# here connection is done 
connection {
  type = "ssh"
  user = "ec2-user"
  password = "DevOps321"
  host = aws_instance.redis.private_ip
}
# now we need to execute the scrpit
provisioner "remote-exec" {
  inline = [ 
    "chmod +x /tmp/bootstrap.sh",
    "sudo sh /tmp/bootstrap.sh redis"
   ]
}

}


resource "aws_instance" "rabbitmq" {
  ami = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.rabbitmq_sg_id]
  subnet_id =local.database_subnet_id
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-rabbitmq"
    }
  )
}

# now instance is created we need integrate with ansible
# using remote exec we will connect and trigger the ansible

resource "terraform_data" "rabbitmq" {
  triggers_replace = [
    aws_instance.rabbitmq
  ]
provisioner "file" {
  source = "bootstrap.sh"
  destination = "/tmp/bootstrap.sh" 
}
# here connection is done 
connection {
  type = "ssh"
  user = "ec2-user"
  password = "DevOps321"
  host = aws_instance.rabbitmq.private_ip
}
# now we need to execute the scrpit
provisioner "remote-exec" {
  inline = [ 
    "chmod +x /tmp/bootstrap.sh",
    "sudo sh /tmp/bootstrap.sh rabbitmq"
   ]
}

}


resource "aws_instance" "mysql" {
  ami = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id =local.database_subnet_id
  iam_instance_profile = "Ec2RoleToFetchSSMParams"
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-mysql"
    }
  )
}

# now instance is created we need integrate with ansible
# using remote exec we will connect and trigger the ansible

resource "terraform_data" "mysql" {
  triggers_replace = [
    aws_instance.mysql
  ]
provisioner "file" {
  source = "bootstrap.sh"
  destination = "/tmp/bootstrap.sh" 
}
# here connection is done 
connection {
  type = "ssh"
  user = "ec2-user"
  password = "DevOps321"
  host = aws_instance.mysql.private_ip
}
# now we need to execute the scrpit
provisioner "remote-exec" {
  inline = [ 
    "chmod +x /tmp/bootstrap.sh",
    "sudo sh /tmp/bootstrap.sh mysql"
   ]
}

}