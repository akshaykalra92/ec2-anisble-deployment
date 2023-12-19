# Infrastructure Provisioning and Apache Installation with Terraform and Ansible

**Overview**

This repository provides an example setup for provisioning infrastructure using Terraform and installing Apache on the provisioned infrastructure using Ansible. The example is designed for AWS, and it creates an EC2 instance running Apache.

**Prerequisites**

Terraform

Ansible

AWS CLI configured with appropriate credentials

**Usage**

1) Clone the Repository:
      git clone https://github.com/akshaykalra92/ec2-anisble-deployment.git
      cd terraform-ansible-apache

2) Update Terraform Variables:

      Update the main.tf file with your AWS region, AMI ID, instance type, and other parameters.

3) Run Terraform:
   
     terraform init
     terraform apply

4) Run Ansible Playbook:

    Terraform will automatically trigger Ansible to install Apache on the provisioned EC2 instance. No manual intervention is required.


**Clean Up**

To destroy the created infrastructure:

terraform destroy


**Customization**

Feel free to customize the Terraform configuration and Ansible playbook to match your specific requirements. Update variable values, security groups, key pairs, etc., as needed.

**Self note for future** 

Compute.tf has dos2unix problem. Run utility before running ansible in linux box.

+ ansible-apache to run application using ansible

![img.png](img.png)

![img_1.png](img_1.png)


terraform.auto.tfvars
//AWS
region = "us-east-1"
vpc_cidr             = "10.20.20.0/16"
public_subnets_cidr  = ["10.20.20.0/28"]
access_key="AKIAZXXXX"
secret_key="SgDZMXXXXXXX/0"
