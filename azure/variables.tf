variable "vpc_cidrs" {
  description = "the cidr to use for the vpc"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "dns_servers" {
  description = "DNS servers for the vpc"
  type        = list(string)
  default     = ["10.0.0.4", "10.0.0.5"]
}

variable "subnet_cidrs" {
  description = "the cidr to use for the vpc"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "tag_business_unit" {
  description = "Business Unit tagging"
  default     = "macrolife"
}

variable "tag_cost_centre" {
  description = "Cost Center tagging"
  default     = "SOW-8739494"
}


variable "tag_environment" {
  description = "Env type like dev,qa,prod"
  type        = string
  default     = "dev"
}
