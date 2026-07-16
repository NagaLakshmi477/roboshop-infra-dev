variable "frontend_sg_name" {
  default = "frontend"
}

variable "frontend_sg_discription" {
  default = "This is frontend sg discription"
}

variable "frontend_sg_tags" {
  type = map(string)
  default = {}
}

variable "project" {
  default = "Roboshop"
}

variable "environment" {
  default = "dev"
}

