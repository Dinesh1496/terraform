provider "aws" {
    region = "us-west-1"
    profile = "default"
}
  
provider "vault" {
    address = "http://13.52.247.233:8200"
    skip_child_token =  true

    auth_login {
        path = "auth/approle/login"
        
        parameters = {
            role_id = "c2005b4c-1ef8-2474-de59-c7bc04085a9b"
            secret_id = "99e9b3ed-737d-7238-dc5a-811c9c1dd81c"
            
        }
    }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "test-secret"
}

resource "aws_instance" "example" {
    ami = "ami-0da424eb883458071"
    instance_type = "t2.micro"
    tags = {
        Name = "test-instance"
        secret = data.vault_kv_secret_v2.example.data["aws"]
    }
  
}

