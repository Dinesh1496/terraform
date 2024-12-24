provider "aws" {
    region = "ap-south-1"  # Set your desired AWS region
}

variable "cidr" {
    default = "10.0.0.0/16"
}

resource "aws_key_pair" "example" {
    key_name   = "terraform-demo-dk"
    public_key = file("/home/aws/.ssh/ssh-rsa.pub")
  
}

resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
    tags = {
        Name = "terraform-demo-vpc"
    }
}

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "terraform-demo-subnet"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
        Name = "terraform-demo-igw"
    }
}

resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "terraform-demo-RT"
    }
}

resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "websg" {
    name = "web-sg"
    vpc_id = aws_vpc.myvpc.id
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "web-sg"
    }
}

resource "aws_instance" "server" {
    ami = "ami-0dee22c13ea7a9a67"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.subnet1.id
    key_name = aws_key_pair.example.key_name
    vpc_security_group_ids = [aws_security_group.websg.id]
    tags = {
        Name = "instance01"
    }

    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file("/home/aws/.ssh/ssh-rsa")
        host = self.public_ip
    }

    provisioner "file" {
        source = "/home/aws/tf/terraform-practice/day5/app.py"
        destination = "/home/ubuntu/app.py"
    }

    provisioner "remote-exec" {
        inline = [
            "echo 'Hello from the remote instance'",
            "sudo apt-get update",
            "sudo apt-get install -y python3-pip",
            "cd /home/ubuntu",
            "sudo pip3 install flask",
            "sudo python3 app.py &",
        ]
        
    }
}
  


