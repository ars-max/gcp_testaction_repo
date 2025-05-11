# Project name
project_name = "ncau-data-newsquery-dev"

vpc_routing_mode = "GLOBAL"

# Primary region
region_a = "us-central1"

# CIDR block
# Example allocation: CIDR /20 with width_delta 4 will allocate /24 for each subnet.
cidr_block                       = "172.23.92.0/24"
public_subnet_width_delta        = 4
private_subnetwork_width_delta   = 4
protected_subnetwork_width_delta = 4
cidr_subnetwork_spacing          = 0


# Secondary CIDR block
# This CIDR block is for services such as GKE which needs it's own internal dynamic subnet for containers.
# Firewall is configured in such a way that it allows communication between this subnet and back to private.
secondary_cidr_block                       = "10.23.92.0/24"
secondary_public_subnet_width_delta        = 4
secondary_private_subnetwork_width_delta   = 4
secondary_protected_subnetwork_width_delta = 4
secondary_cidr_subnetwork_spacing          = 0

# Mandatory Labels
label_environment = "dev"

peering_zone_name          = "newslimited-local"
peering_dns_name           = "news.newslimited.local"
dns_peering_shared_project = "nau-ent-prod-shared"
dns_peering_shared_network = "nau-ent-prod-shared-vpc"
