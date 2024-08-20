# Example for Packer with IBM Cloud VPC for custom Images
This is an example repo to have consistent custom Image on IBM Cloud VPC for NVIDIA CUDA Drivers and other components using Packer and Ansible.

## Prerequisites
* IBM Cloud API Key with supported permissions
* IBM Cloud VPC with at least on subnet
* Linux Developer machine with Packer, Ansible and packer ansible plugin installed

## How to to use
```bash
# installs the IBM Cloud packer plugin
packer init -upgrade templates/build.vpc.ubuntu.pkr.hcl
```
```bash
# validate the packer template
packer validate templates/build.vpc.ubuntu.pkr.hcl
```
```bash
# build the packer template
packer build templates/build.vpc.ubuntu.pkr.hcl
```
## References
* https://www.ibm.com/blog/use-ibm-packer-plugin-to-create-custom-images-on-ibm-cloud-vpc-infrastructure/
* https://github.com/IBM/packer-plugin-ibmcloud
* https://www.ibm.com/blog/build-hardened-and-pre-configured-vpc-custom-images-with-packer/
* https://developer.hashicorp.com/packer/integrations/hashicorp/ansible



