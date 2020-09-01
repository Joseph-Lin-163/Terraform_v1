variable "region" {
  default = "us-west-2"
}

variable "amis" {
    default = {
    "us-east-1" = "ami-b374d5a5"
    "us-west-2" = "ami-04590e7389a6e577c"
  }
}
