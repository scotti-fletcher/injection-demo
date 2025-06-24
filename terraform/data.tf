data "aws_vpc" "wizlabs" {
  filter {
    name   = "tag:Name"
    values = ["Wizlabs-VPC"]
  }
}

# Get ALL subnets in the VPC
data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.wizlabs.id]
  }
}

# Get details about each subnet so we can find public ones
data "aws_subnet" "details" {
  for_each = toset(data.aws_subnets.all.ids)
  id       = each.key
}

# Filter to get only public subnet IDs
locals {
  public_subnet_ids = [
    for s in data.aws_subnet.details : s.id
    if s.map_public_ip_on_launch == true
  ]
}