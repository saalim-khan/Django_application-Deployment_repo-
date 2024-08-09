provider "aws" {
  region = "us-east-1"
}

terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # version = "~> 4.15.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

}
}
