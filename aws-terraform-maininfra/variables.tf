# variables.tf

variable "environment" {
  description = "Environment tag value"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "access_key" {
    description = "access key to moon"
    type = string
}

variable "secret_key" {
  description = "secret key to moon"
  type = string
}

variable "local_ip" {
  description = "local ip"
  type = string
}
