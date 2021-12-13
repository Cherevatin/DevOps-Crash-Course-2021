provider "aws" {
    region = "eu-central-1"
}


resource "aws_instance" "webserver"{
    key_name = "ssh_key"
    ami = "ami-0245697ee3e07e755" 
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.sg_webserver.id]

  tags = {
      Name = "Server"
  }
}


resource "aws_security_group" "sg_webserver"{
    name = "Security"
    description = "SG for Server"

    ingress = [
        {
            description      = "TLS from VPC"
            from_port        = 80
            to_port          = 80
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
            ipv6_cidr_blocks = ["::/0"]
            prefix_list_ids  = []
            security_groups  = []
            self = false 
        }
    ]

    egress {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self = false
    }

    tags = {
        Name = "SG for Debian web server"
    }
}

output "public_ip" {
    value = aws_instance.webserver.public_ip
}