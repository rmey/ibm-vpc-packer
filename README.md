# Example for Packer with IBM Cloud VPC for custom Images
This is an example repo to have consistent custom Image on IBM Cloud VPC for NVIDIA CUDA Drivers and other components on latest Ubuntu using Packer and Ansible.

## Prerequisites
* IBM Cloud API Key with supported permissions
* IBM Cloud VPC with at least one subnet
* Linux/Mac machine or Docker Container with Hashicorp Packer and Ansible installed

## How to to use
Review the generic [Packer template](templates/build.vpc.generic.pkr.hcl) and the [Ansible Playbook](playbooks/ubuntu-cuda-12.6.yaml). The Ansible playbook is called from Packer via a variable name and will install several components and drivers including reboots. When finished Packer will create a custom IBM Cloud VPC Image, in the concrete exampple Ubuntu 24.04. LTS with latest NVIDIA CUDA support and NVIDIA Container Toolkit and Docker.

1. clone repo and create create a .env file
```bash
git clone https://github.com/rmey/ibm-vpc-packer.git
cd ibm-vpc-packer
cp dot-env-template.txt .env
```
2. adopt the values in the .env file for the generic Packer template
```bash
# YOUR IBM CLOUD VPC API KEY
export IBM_API_KEY="XXXXXXXXXX"
# ID of the IBM Cloud Resource Group to be used
export IBM_CLOUD_RESOURCE_GROUP_ID=""
# Subnet ID of an existing IBM Cloud VPC used by packer to create the temporary VSI during build phase
export IBM_CLOUD_VPC_SUBNET_ID=""
# base image to be used
export IBM_CLOUD_VPC_BASE_IMAGE="ibm-ubuntu-24-04-6-minimal-amd64-1"
# IBM Cloud VSI profile
export IBM_CLOUD_VPC_VSI_PROFILE="gx2-8x64x1v100"
# specific packer build source for IBM Cloud VPC OS specific build see https://github.com/IBM/packer-plugin-ibmcloud/tree/master/examples
export IBM_CLOUD_VPC_PACKER_BUILD_SRC="source.ibmcloud-vpc.ubuntu"
# Path to ansible playbook
export ANSIBLE_PLAYBOOK="provisioner/ubuntu-cuda-12.6.yaml"
# IMAGE_PREFIX before timestamp for custom image to be created 
export IMAGE_PREFIX="ubuntu-cuda"
# export private or public network SSH connection
export SSH_CONNECTION="public" 
```
3. source .env file and init the packer environment
```bash
source .env
packer init -upgrade templates/build.vpc.generic.pkr.hcl
```
4. validate the packer template
```bash
packer validate templates/build.vpc.generic.pkr.hcl
```
5. build the packer template, this will take about 30 minutes and will create a custom IBM Cloud VPC image with > 16 GB in size. 
```bash
packer build templates/build.vpc.generic.pkr.hcl
```

## References
* https://www.ibm.com/blog/use-ibm-packer-plugin-to-create-custom-images-on-ibm-cloud-vpc-infrastructure/
* https://github.com/IBM/packer-plugin-ibmcloud
* https://www.ibm.com/blog/build-hardened-and-pre-configured-vpc-custom-images-with-packer/
* https://developer.hashicorp.com/packer/integrations/hashicorp/ansible



