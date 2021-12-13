provider "aws" {
    region = "eu-central-1"
}


resource "aws_instance" "webserver"{
    ami = "ami-0245697ee3e07e755" 
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.sg_webserver.id]
    user_data = <<EOF
            #! /bin/bash
            sudo apt-get update
		    sudo apt-get install -y apache2
		    sudo systemctl start apache2
		    sudo systemctl enable apache2
		    echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
	    EOF

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
        Name = "SG for Server"
    }
}

output "public_ip" {
    value = aws_instance.webserver.public_ip
}