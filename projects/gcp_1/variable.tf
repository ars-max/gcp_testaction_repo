# Project Name
variable "project_name" {
  description = "The name of the project to create VPC in"
  type        = string
}

# VPC Routing Mode, GLOBAL or REGIONAL (default)
variable "vpc_routing_mode" {
  description = "The routing mode of the VPC, GLOBAL or REGIONAL (default)"
  type        = string
  default     = "REGIONAL"
}

# Region A
variable "region_a" {
  description = "The A region for subnetworks in the network"
  type        = string
}

# Region: B
variable "region_b" {
  description = "The B region for subnetworks in the network"
  type        = string
  default     = null
}

# Second VPC variable
variable "second_vpc" {
  description = "Whether to create a VPC in a second region"
  type        = bool
  default     = false
}

# Custom VPC name variable:
variable "vpc_name" {
  description = "Name of VPC if not the same as project name"
  type        = string
  default     = ""
}

# Primary CIDR Block
variable "cidr_block" {
  description = "The IP address range of the VPC in CIDR notation"
  type        = string
}

# Public Subnetwork Netmask
variable "public_subnet_width_delta" {
  description = "The difference between your network and subnetwork netmask"
  type        = number
}

# Private Subnetwork Netmask
variable "private_subnetwork_width_delta" {
  description = "The difference between your network and subnetwork netmask"
  type        = number
}

# Protected Subnetwork Netmask
variable "protected_subnetwork_width_delta" {
  description = "The difference between your network and subnetwork netmask"
  type        = number
}

# Primary Subnetwork Spacing
variable "cidr_subnetwork_spacing" {
  description = "How many subnetwork-mask sized spaces to leave between each subnetwork type"
  type        = number
}


# Secondary Network CIDR Block
variable "secondary_cidr_block" {
  description = "The IP address range of the VPC's secondary address range in CIDR notation"
  type        = string
}

# Secondary Public Subnetwork Netmask
variable "secondary_public_subnet_width_delta" {
  description = "The difference between your network and subnetwork netmask"
  type        = number
}

# Secondary Private Subnetwork Netmask
variable "secondary_private_subnetwork_width_delta" {
  description = "The difference between your network and subnetwork netmask"
  type        = number
}

# Secondary Protected Subnetwork Netmask
variable "secondary_protected_subnetwork_width_delta" {
  description = "The difference between your network and subnetwork netmask"
  type        = number
}

# Secondary Network Spacing
variable "secondary_cidr_subnetwork_spacing" {
  description = "How many subnetwork-mask sized spaces to leave between each subnetwork type's secondary ranges"
  type        = number
}


# Flow logs
variable "log_config" {
  description = "The logging options for the subnetwork flow logs"
  type = object({
    aggregation_interval = string
    flow_sampling        = number
    metadata             = string
  })

  default = {
    aggregation_interval = "INTERVAL_30_SEC"
    flow_sampling        = 1
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Subnetwork restrictions
variable "allowed_public_restricted_subnetworks" {
  description = "The public networks that is allowed access to the public_restricted subnetwork of the network"
  default     = []
  type        = list(string)
}

# VPC Name local
locals {
  l_vpc_name = var.vpc_name == "" ? var.project_name : var.vpc_name
}


# router_a_BGP

variable "router_a_asn" {
  description = "ASN for router A BGP"
  default     = null
  type        = number
}

variable "router_a_advertise_mode" {
  description = "Advertise Mode for Router A BGP"
  default     = null
  type        = string
}

variable "router_a_advertised_groups" {
  description = "Advertised Groups for Router A BGP"
  default     = []
  type        = list(string)
}

variable "label_environment" {
  type        = string
  description = "Project Environment Label"
  default     = ""
}

## DNS Peering
variable "peering_zone_name" {
  type        = string
  description = "Name of the peering zone"
  default     = ""
}
variable "peering_dns_name" {
  type        = string
  description = "dns record for the peering zone - no trailing period"
  default     = ""
}

variable "dns_peering_shared_project" {
  type        = string
  description = "name of the shared project for DNS peering"
  default     = ""
}

variable "dns_peering_shared_network" {
  type        = string
  description = "name of the network in the shared project for DNS peering"
  default     = ""
}

variable "category" {
  type        = string
  description = "not referenced"
  validation {
    condition     = contains(["prod", "pre-prod", "non-prod", "sandbox"], lower(var.category))
    error_message = "Allowed values for input_parameter are \"prod\", \"pre-prod\", \"non-prod\", or \"sandbox\"."
  }
}
