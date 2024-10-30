# this is a generic template controlled by ENV variables.
packer {
  required_plugins {
    ibmcloud = {
      version = ">=v3.2.5"
      source  = "github.com/IBM/ibmcloud"
    }
    ansible = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "ibm_api_key" {
  type    = string
  default = "${env("IBM_API_KEY")}"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

variable "ansible_inventory_file" {
  type    = string
  default = "${env("ANSIBLE_INVENTORY_FILE")}"
}

variable "subnet_id" {
  type    = string
  default = "${env("IBM_CLOUD_VPC_SUBNET_ID")}"
}

variable "rg_id" {
  type    = string
  default = "${env("IBM_CLOUD_RESOURCE_GROUP_ID")}"
}

variable "base_img" {
  type    = string
  default = "${env("IBM_CLOUD_VPC_BASE_IMAGE")}"
}

variable "profile" {
  type    = string
  default = "${env("IBM_CLOUD_VPC_VSI_PROFILE")}"
}

variable "buildsrc" {
  type    = string
  default = "${env("IBM_CLOUD_VPC_PACKER_BUILD_SRC")}"
}

variable "playbook" {
  type    = string
  default = "${env("ANSIBLE_PLAYBOOK")}"
}

variable "prefix" {
  type    = string
  default = "${env("IMAGE_PREFIX")}"
}

variable "connection" {
  type    = string
  default = "${env("SSH_CONNECTION")}"
}

source "ibmcloud-vpc" "ubuntu" {
  api_key = "${var.ibm_api_key}"
  region  = "eu-de"

  subnet_id         = "${var.subnet_id}"
  resource_group_id = "${var.rg_id}"
  security_group_id = ""

  vsi_base_image_name = "${var.base_img}"
  vsi_profile         = "${var.profile}"
  vsi_interface       = "${var.connection}"
  vsi_user_data_file  = ""
  image_name          = "${var.prefix}-${local.timestamp}"

  communicator = "ssh"
  ssh_username = "root"
  ssh_port     = 22
  ssh_timeout  = "15m"
  ssh_read_write_timeout = "5m" # Allow reboots  
  timeout = "60m"
}

build {
  sources = [
    "${var.buildsrc}"
  ]

  provisioner "ansible" {
    playbook_file = "${var.playbook}"
    ansible_env_vars = [
      "ANSIBLE_STDOUT_CALLBACK=debug",
      "ANSIBLE_HOST_KEY_CHECKING=False",
      ]
    extra_arguments = [ "--scp-extra-args", "'-O'" ]
  }
}