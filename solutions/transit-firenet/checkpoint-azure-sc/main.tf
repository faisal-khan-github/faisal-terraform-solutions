
provider “aviatrix” {
  username      = var.username
  password      = var.password
  controller_ip = var.controller_ip
  version = “~> 2.13"
}
resource “random_integer” “subnet” {
  min = 1
  max = 250
}
# Create Aviatrix Transit Firenet vnet
resource “aviatrix_vpc” “transit_firenet” {
  cloud_type           = var.cloud_type
  account_name         = var.azure_account_name
  region               = var.region
  name                 = “AZSC2-Transit”
  cidr                 = “172.16.50.0/23"
  #cidr                 = cidrsubnet(“10.0.0.0/8”, 8, random_integer.subnet.result)
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = true
  #s
}
#############
# Create Aviatrix Transit spoke vnets
resource “aviatrix_vpc” “avx_spoke_vpc” {
  count                = var.vpc_count
  cloud_type           = var.cloud_type
  account_name         = var.azure_account_name
  region               = var.region
  #name                 = “Spoke-VNET-${count.index + 1}”
  name                 = “AZSC2-Spoke${count.index + 1}”
  #cidr                 = cidrsubnet(“172.16.11.0/20", 4, random_integer.subnet.result + count.index)
  cidr                 = cidrsubnet(“172.16.11.0/20”, 4, 1 + count.index)
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
}
# Create Aviatrix Transit firenet gateway
resource “aviatrix_transit_gateway” “transit_firenet_gw” {
  cloud_type                    = var.cloud_type
  vpc_reg                       = var.region
  vpc_id                        = aviatrix_vpc.transit_firenet.vpc_id
  account_name                  = aviatrix_vpc.transit_firenet.account_name
  gw_name                       = var.avx_transit_gw
  ha_gw_size                    = var.avx_gw_size
  gw_size                       = var.avx_gw_size
  subnet                        = var.hpe ? cidrsubnet(aviatrix_vpc.transit_firenet.cidr, 10, 4) : aviatrix_vpc.transit_firenet.subnets[2].cidr
  ha_subnet                     = var.hpe ? cidrsubnet(aviatrix_vpc.transit_firenet.cidr, 10, 8) : aviatrix_vpc.transit_firenet.subnets[3].cidr
  enable_active_mesh            = true
  enable_transit_firenet        = true
  connected_transit             = true
  depends_on = [aviatrix_vpc.transit_firenet]
}
# Create Aviatrix spoke gateways and attach to transit firenet gateway
resource “aviatrix_spoke_gateway” “avtx_spoke_gw” {
  count              = var.vpc_count
  cloud_type         = var.cloud_type
  account_name       = var.azure_account_name
  #gw_name            = “Spoke-GW-${count.index}”
  gw_name            = “AZSC2-Spoke${count.index + 1}-AGW”
  vpc_id             = aviatrix_vpc.avx_spoke_vpc[count.index].vpc_id
  vpc_reg            = var.region
  gw_size            = var.avx_gw_size
  subnet             = aviatrix_vpc.avx_spoke_vpc[count.index].subnets[0][“cidr”]
  transit_gw         = var.avx_transit_gw
  enable_active_mesh = true
  depends_on = [aviatrix_transit_gateway.transit_firenet_gw]
}
# Create an Aviatrix Firewall Instance 1
resource “aviatrix_firewall_instance” “firewall_instance_1" {
  vpc_id                        = aviatrix_vpc.transit_firenet.vpc_id
  firenet_gw_name               = aviatrix_transit_gateway.transit_firenet_gw.gw_name
  #firewall_name                 = “avx-checkpoint-fw1”
  firewall_name                 = “AZSC2-CP-1"
  firewall_image                = var.fw_image
  firewall_size                 = var.firewall_size
  firewall_image_version        = var.fw_image_version
  management_subnet             = aviatrix_vpc.transit_firenet.subnets[2].cidr
  egress_subnet                 = aviatrix_vpc.transit_firenet.subnets[0].cidr
  username                      = “admin”
  password                      = var.fw_password
  depends_on = [aviatrix_spoke_gateway.avtx_spoke_gw]
}
/*
resource “aviatrix_firewall_instance” “firewall_instance_1” {
    firewall_name = “AZNV-CP-1"
    firewall_size = “Standard_D3_v2”
    vpc_id = “AVX6-East-Transit-FireNet:rg-av-AVX6-East-Transit-FireNet-177147"
    firewall_image = “Check Point CloudGuard IaaS Single Gateway R80.40 - Bring Your Own License”
    egress_subnet = “10.1.0.0/28"
    firenet_gw_name = “AVX6-Transit-GW”
    iam_role = null
    bootstrap_bucket_name = null
    management_subnet = “10.1.0.0/28"
}
*/
# Create an Aviatrix Firewall Instance 2
resource “aviatrix_firewall_instance” “firewall_instance_2" {
  vpc_id                        = aviatrix_vpc.transit_firenet.vpc_id
  firenet_gw_name               = “${aviatrix_transit_gateway.transit_firenet_gw.gw_name}-hagw”
  #firewall_name                 = “avx-checkpoint-fw2"
  firewall_name                 = “AZSC2-CP-2”
  firewall_image                = var.fw_image
  firewall_size                 = var.firewall_size
  firewall_image_version        = var.fw_image_version
  management_subnet             = aviatrix_vpc.transit_firenet.subnets[3].cidr
  egress_subnet                 = aviatrix_vpc.transit_firenet.subnets[1].cidr
  username                      = “admin”
  password                      = var.fw_password
  depends_on = [aviatrix_spoke_gateway.avtx_spoke_gw]
}
# Create Aviatrix Transit Firewall instance associations
resource “aviatrix_firenet” “firewall_net” {
  vpc_id             = aviatrix_vpc.transit_firenet.vpc_id
  inspection_enabled = true
  egress_enabled     = true
  firewall_instance_association {
    firenet_gw_name      = aviatrix_transit_gateway.transit_firenet_gw.gw_name
    vendor_type          = “Generic”
    instance_id          = aviatrix_firewall_instance.firewall_instance_1.instance_id
    firewall_name        = aviatrix_firewall_instance.firewall_instance_1.firewall_name
    attached             = true
    lan_interface        = aviatrix_firewall_instance.firewall_instance_1.lan_interface
    management_interface = aviatrix_firewall_instance.firewall_instance_1.management_interface
    egress_interface     = aviatrix_firewall_instance.firewall_instance_1.egress_interface
  }
  firewall_instance_association {
    firenet_gw_name      = “${aviatrix_transit_gateway.transit_firenet_gw.gw_name}-hagw”
    vendor_type          = “Generic”
    instance_id          = aviatrix_firewall_instance.firewall_instance_2.instance_id
    firewall_name        = aviatrix_firewall_instance.firewall_instance_2.firewall_name
    attached             = true
    lan_interface        = aviatrix_firewall_instance.firewall_instance_2.lan_interface
    management_interface = aviatrix_firewall_instance.firewall_instance_2.management_interface
    egress_interface     = aviatrix_firewall_instance.firewall_instance_2.egress_interface
  }
  depends_on             = [aviatrix_firewall_instance.firewall_instance_1, aviatrix_firewall_instance.firewall_instance_2]
}
# Create an Aviatrix Transit FireNet Policy
resource “aviatrix_transit_firenet_policy” “transit_firenet_policy1” {
  transit_firenet_gateway_name = aviatrix_transit_gateway.transit_firenet_gw.gw_name
  #inspected_resource_name      = “SPOKE:Spoke-GW-0"
  inspected_resource_name      = “SPOKE:AZSC2-Spoke1-AGW”
  depends_on = [aviatrix_firenet.firewall_net]
}
resource “aviatrix_transit_firenet_policy” “transit_firenet_policy2” {
  transit_firenet_gateway_name = aviatrix_transit_gateway.transit_firenet_gw.gw_name
  #inspected_resource_name      = “SPOKE:Spoke-GW-1"
  inspected_resource_name      = “SPOKE:AZSC2-Spoke2-AGW”
  depends_on = [aviatrix_firenet.firewall_net]
}