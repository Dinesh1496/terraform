provider aws     {
    region = "ap-south-1"
}

variable "ami"{
    description = "ami-ubuntu"
}

variable "instance_type"{
    description = "type"
}

module "ec2" {
  source = "./module/ec2_instancee"
  ami = var.ami
  instance_type = var.instance_type
}