[7:51:56_AM] [$$ enctrypted $$]
[7:51:55_AM] [$$ enctrypted $$]
[7:51:55_AM] [$$ enctrypted $$]
[7:51:55_AM] [$$ enctrypted $$]
[7:51:55_AM] [$$ enctrypted $$]
[7:51:54_AM] [$$ enctrypted $$]
[7:46:34_AM] [$$ enctrypted $$]
[7:46:32_AM] [$$ enctrypted $$]
[7:46:32_AM] [$$ enctrypted $$]
[7:46:32_AM] [$$ enctrypted $$]
[7:46:32_AM] [$$ enctrypted $$]
[7:46:32_AM] [$$ enctrypted $$]
[7:46:31_AM] [$$ enctrypted $$]
[7:46:31_AM] [$$ enctrypted $$]
[7:46:31_AM] [$$ enctrypted $$]
[7:46:31_AM] [$$ enctrypted $$]
[7:46:31_AM] [$$ enctrypted $$]
[7:46:31_AM] [$$ enctrypted $$]
[7:46:31_AM] [$$ enctrypted $$]
[7:46:30_AM] [$$ enctrypted $$]
[7:46:30_AM] [$$ enctrypted $$]
[7:46:30_AM] [$$ enctrypted $$]
[7:46:30_AM] [$$ enctrypted $$]
[7:46:30_AM] [$$ enctrypted $$]
[7:46:30_AM] [$$ enctrypted $$]
[7:46:29_AM] [$$ enctrypted $$]
[7:46:29_AM] [$$ enctrypted $$]
[7:46:29_AM] [$$ enctrypted $$]
[7:46:29_AM] [$$ enctrypted $$]
[7:46:29_AM] [$$ enctrypted $$]
[7:46:29_AM] [$$ enctrypted $$]
[7:46:29_AM] [$$ enctrypted $$]
[7:46:28_AM] [$$ enctrypted $$]
[7:46:28_AM] [$$ enctrypted $$]
[7:46:28_AM] [$$ enctrypted $$]
[7:46:28_AM] [$$ enctrypted $$]
[7:46:28_AM] [$$ enctrypted $$]
[7:46:28_AM] [$$ enctrypted $$]
[7:46:27_AM] [$$ enctrypted $$]
[7:46:27_AM] [$$ enctrypted $$]
[7:46:27_AM] [$$ enctrypted $$]
[7:46:27_AM] [$$ enctrypted $$]
[7:46:27_AM] [$$ enctrypted $$]
[7:46:27_AM] [$$ enctrypted $$]
[7:46:27_AM] [$$ enctrypted $$]
[7:46:26_AM] [$$ enctrypted $$]
[7:46:26_AM] [$$ enctrypted $$]
[7:46:26_AM] [$$ enctrypted $$]
[7:46:26_AM] [$$ enctrypted $$]
[7:46:26_AM] [$$ enctrypted $$]
[7:46:26_AM] [$$ enctrypted $$]
[7:46:25_AM] [$$ enctrypted $$]
[7:46:25_AM] [$$ enctrypted $$]
[7:46:25_AM] [$$ enctrypted $$]
[7:46:25_AM] [$$ enctrypted $$]
[7:46:24_AM] [$$ enctrypted $$]
[7:46:23_AM] [$$ enctrypted $$]
[7:46:23_AM] [$$ enctrypted $$]
[7:46:22_AM] [$$ enctrypted $$]
[7:46:21_AM] [$$ enctrypted $$]
[7:45:52_AM] [$$ enctrypted $$]
[7:45:26_AM] [$$ enctrypted $$]
[7:45:26_AM] [$$ enctrypted $$]
[7:45:26_AM] [$$ enctrypted $$]
[7:45:26_AM] [$$ enctrypted $$]
[7:45:25_AM] [$$ enctrypted $$]
[7:45:25_AM] [$$ enctrypted $$]
[7:45:25_AM] [$$ enctrypted $$]
[7:45:25_AM] [$$ enctrypted $$]
[7:45:25_AM] [$$ enctrypted $$]
[7:45:25_AM] [$$ enctrypted $$]
[7:45:24_AM] [$$ enctrypted $$]
[7:45:24_AM] [$$ enctrypted $$]
[7:44:53_AM] [$$ enctrypted $$]
variable “vpc_count” {
  default = 2
}
variable “username” {
  type    = string
  default = “”
}
variable “password” {
  type    = string
  default = “”
}
variable “fw_password” {
  type    = string
  default = “”
}
variable “controller_ip” {
  type    = string
  default = “”
}
variable “cloud_type” {
  default = 8
}
variable “hpe” {
  default = false
}
variable “region” {
  default = “South Central US”
}
variable “key_name” {
  default = “avtx-key”
}
variable “azure_account_name” {
  default = “”
}
variable “avx_transit_gw” {
  default = “AZSC-2-Transit-gw”
}
variable avx_gw_size {
  default = “Standard_B2ms”
}
variable firewall_size {
  default = “Standard_D3_v2”
}
variable fw_image_version {
  default = “8040.900294.0593"
}
variable fw_image {
  #default = “Check Point CloudGuard IaaS Next-Gen Firewall w. Threat Prevention & SandBlast BYOL”
  default = “Check Point CloudGuard IaaS Single Gateway R80.40 - Pay As You Go (NGTP)”
}