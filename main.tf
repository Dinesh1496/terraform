provider "aws" {
    region = "us-east-1"
    access_key = "AKIASFIXDEFPZOKGNLCS"
    secret_key = "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"
}

module "ec2_instance"  {
    source = "./modules_ec2-instance"

    ami_value= "ami-01af4173f6cee270a"
    instance_type_value =  "t2.micro"
    subnet_id_value = "subnet-074304bca19efa59f"
    key_name_value = "cloudwatch-key"
}