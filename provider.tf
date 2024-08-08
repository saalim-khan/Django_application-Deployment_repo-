provider "aws" {
  region     = "us-east-1"

}
####creating VPC####################

resource "aws_vpc" "my-vpc" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "new-vpc-mumbai"
  }
}

##########Creating Internet GateWay################
resource "aws_internet_gateway" "my-IGW" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "new-IGW-mumbai"
  }
}

########Creating Subnet##############################
resource "aws_subnet" "my-subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "new-subnet-mumbai"
  }
}
##############Creating Route Table##################
resource "aws_route_table" "my-route-table" {
  vpc_id = aws_vpc.my-vpc.id

  route {
   # cidr_block = "10.0.1.0/24"
    #gateway_id = aws_internet_gateway.my-IGW.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = null
  }

  tags = {
    Name = "new-route-table-mumbai"
  }
}

################# Route ####################### use this when we dont mention route table ##########
resource "aws_route" "r" {
  route_table_id            = aws_route_table.my-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my-IGW.id   
  depends_on = [ aws_route_table.my-route-table ]
}


#############  Security Group ###############################
resource "aws_security_group" "my-SG" {
  name        = "allow all traffic"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my-vpc.id
  tags = {
    Name = "SG-mumbai-all-traffic"
  }
}

 
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.my-SG.id
  cidr_ipv4         = aws_vpc.my-vpc.cidr_block
  from_port         = 0
  ip_protocol       = "all traffic"
  to_port           = 0
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.my-SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

 


############### route table association #################

resource "aws_route_table_association" "association-rt" {
  subnet_id      = aws_subnet.my-subnet.id
  route_table_id = aws_route_table.my-route-table.id
}

#####################creating EC2 instance      ###############
resource "aws_instance" "my-ec2" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.my-subnet.id 
  
  # user_data = <<-EOF
  #                   #!/bin/bash
  #                   sudo apt-get update -y
  #                   sudo apt-get install ca-certificates curl gnupg
  #                   sudo install -m 0755 -d /etc/apt/keyrings
  #                   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  #                   sudo chmod a+r /etc/apt/keyrings/docker.gpg
  #                   echo \
  #                   "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  #                   "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  #                   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  #                   sudo apt-get update -y
  #                   docker pull <aws-account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>
  #                   sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  #                 EOF  
  tags = {
    Name = "ec2-in-mumbai"
  }
}

data "aws_ecr_image" "" {
  repository_name = "notes_app"
  image_tag       = "latest596562ffbf887c8ff93925e2dae3ef8edf13caa9"
  
}











  # ingress = [ {
  #     description      = "all traffic"
  #     from_port        = 0
  #     to_port          = 0
  #     protocol         = "-1"   #-1 is use for all traffic
  #     cidr_blocks      = ["0.0.0.0/0"]
  #     ipv6_cidr_blocks = null
  # }
  #  ]

  # egress = [
  #   {
  #     description      = "all traffic"
  #     from_port        = 0
  #     to_port          = 0
  #     protocol         = "-1"   #-1 is use for all traffic
  #     cidr_blocks      = ["0.0.0.0/0"]
  #     ipv6_cidr_blocks = null
  #   }
  # ] 








