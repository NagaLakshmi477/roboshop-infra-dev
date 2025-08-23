variable "frontend_sg_name" {
  default = "frontend"
}

variable "frontend_sg_description" {
  default = "created sg for frontend"
}

variable "environment" {
  default = "dev"
}

variable "project" {
  default = "roboshop"
}

variable "sg_tags" {
  default = {}
}


variable "bastion_sg_name" {
  default = "bastion"
}

variable "bastion_sg_description" {
  default = "created sg for bastion"
}