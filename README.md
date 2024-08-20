# Example for Packer with IBM Cloud VPC for custom Images
This is an example repo to have consistent custom Image on IBM Cloud VPC for NVIDIA CUDA Drivers and other components using Packer and Ansible.

## Prerequisites
* IBM Cloud API Key with supported permissions
* IBM Cloud VPC with at least one subnet
* Linux Developer machine with Packer, Ansible and packer ansible plugin installed

## How to to use
Review the [Packer template](templates/build.vpc.ubuntu.pkr.hcl) and the [Ansible Playbook](provisioner/ubuntu-playbook.yml). The Ansible playbook is called from Packer and will install several components and drivers including reboots. When finished Packer will create a custom IBM Cloud VPC Image.

1. clone repo and create create a .env file
```bash
git clone https://github.com/rmey/ibm-vpc-packer.git
cd ibm-vpc-packer
cp dot-env-template.txt .env
```
2. adopt the values in the .env file
```bash
export IBM_API_KEY=""
# ID of the IBM Cloud Resource Group to be used
export IBM_CLOUD_RESOURCE_GROUP_ID=""
# Subnet ID of an existing IBM Cloud VPC used to create
export IBM_CLOUD_VPC_SUBNET_ID=""
# base image to be used
export IBM_CLOUD_VPC_BASE_IMAGE="ibm-ubuntu-22-04-4-minimal-amd64-3"
# IBM Cloud VSI profile
export IBM_CLOUD_VPC_VSI_PROFILE="gx2-8x64x1v100"
```
3. source .env file and init the packer environment
```bash
source .env
packer init -upgrade templates/build.vpc.ubuntu.pkr.hcl
```
4. validate the packer template
```bash
packer validate templates/build.vpc.ubuntu.pkr.hcl
```
5. build the packer template, this will take about 30 minutes and will create a custom IBM Cloud VPC image with > 16 GB in size. 
```bash
packer build templates/build.vpc.ubuntu.pkr.hcl
```

## References
* https://www.ibm.com/blog/use-ibm-packer-plugin-to-create-custom-images-on-ibm-cloud-vpc-infrastructure/
* https://github.com/IBM/packer-plugin-ibmcloud
* https://www.ibm.com/blog/build-hardened-and-pre-configured-vpc-custom-images-with-packer/
* https://developer.hashicorp.com/packer/integrations/hashicorp/ansible



