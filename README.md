# Terraform Create AWS VPC
Terraform script to create AWS VPC
 
# Deployment Instructions
Export aws credentials to the working environment
 ```
export AWS_ACCESS_KEY_ID="{}" &&  export AWS_SECRET_ACCESS_KEY="{}" && export AWS_REGION="eu-west-2"
```
Replace the variables in the command to suite your environment.
```
terraform init
terraform plan
terraform apply 
terraform output
```
You can modify these common variables (Others are available on the variables.tf file):
- aws_region
- vpc_name
- vpc_ip_base
- vpc_mask
- vpc_increment (for the subnet creation)
- subnet_mask
- availability_zones
- public_ports
- private_ports
- secure_ports

To destroy the instances (Given that the instance doesn't have termination protection enabled)
```
terraform destroy
```
