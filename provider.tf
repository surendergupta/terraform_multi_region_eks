provider "aws" {
  region = "ap-south-1"
  alias  = "region1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "region2"
}
