provider "aws" {
    region = "ap-south-1"  # Set your desired AWS region
}

resource "aws_instance" "example" {
    ami           = "ami-01af4173f6cee270a"  # Specify an appropriate AMI ID
    instance_type = "t2.micro"
    subnet_id = "subnet-074304bca19efa59f"
    key_name = "cloudwatch-key"
}
