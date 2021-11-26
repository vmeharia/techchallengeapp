variable "resource_group_name" {
    default = "test-rg"
    description = "resource group name to hold all the resources"
}
variable "location" {
    default = "eastus"
    description = "The region for all the resources"
}
variable "virtual_network_name" {
    default = "test-vnet"
    description = "virtual network for connectivity"
}
variable "vnet_prefix" {
    default = "10.2.0.0/16"
    description = "Virtual network address CIDR"
}
variable "subnet_names" {
    default = "test-vnet-aks-snet"
    description = "Virtual network subnet"
}
variable "subnet_prefix" {
    default = "10.2.0.0/19"
    description = "Subnet CIDR address"
}
variable "vm_size" {
    default = "Standard_D2_v2"
    description = "VM size for Azure Kubernetes Service (AKS) node pool"
}
variable "cluster_name" {
    default = "test-aks"
    description = "Cluster name for Azure Kubernetes Service (AKS)"
}
variable "node_resource_group" {
    default = "test-k8s-rg"
    description = "Resource group to all hold Azure Kubernetes Service (AKS) components"
}
variable "service_ip" {
    default = "10.2.32.10"
    description = "Service IP for Azure Kubernetes Service (AKS)"
}
variable "docker_cidr" {
    default = "172.17.0.1/16"
    description = "Docker CIDR block"
}
variable "service_cidr" {
    default = "10.2.32.0/22"
    description = "Service CIDR address"
}
variable "dns_prefix_name" {
    default = "test"
    description = "DNS prefix of hostname for Azure Kubernetes Service (AKS)"
}
variable "pgserver_username" {
    default = "psqladmin"
    description = "Postgres server username"
}
variable "pgserver_password" {
    description = "Please enter Postgres server password(for example : H@Sh1CoR3!)"
    sensitive = true
}

variable "pgserver_name" {
  default = "test-pgserver"
  description = "Name of postgres server"
}
variable "pgdb_name" {
  default = "test-pgdb"
  description = "Name of postgres database"
}

variable "port" {
  default = "80"
  description = "variable used for port 80 in multiple places"
}