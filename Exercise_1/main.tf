# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  region = "us-east-1"
  shared_credentials_files = ["C:/Users/Michael.Volkmann2/.aws/credentials"] 
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity_T2" {
    count = 4
    ami = "ami-09d3b3274b6c5d4aa"
    instance_type = "t2.micro"
    subnet_id = "subnet-06bb83d003870a674"
    
    tags = {
        Name = "Udacity T2"
    }

}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "Udacity_M4" {
  count = 0
  ami = "ami-09d3b3274b6c5d4aa"
  instance_type = "m4.large"
  subnet_id = "subnet-06bb83d003870a674"

  tags = {
    Name = "Udacity M4"
  }
}
