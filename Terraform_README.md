# ⚙️ Terraform Deployment

Terraform was used to provision the complete AWS infrastructure required for the TravelMemory application.

The infrastructure includes:

- Custom VPC
- Public Subnet
- Private Subnet
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- IAM Role
- IAM Instance Profile
- EC2 Web Server
- EC2 MongoDB Server

---

## 📁 Terraform Directory Structure

```text
terraform/
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── network.tf
├── security.tf
├── iam.tf
├── ec2.tf
├── outputs.tf
└── main.tf
```

---

# Step 1 - Initialize Terraform

Terraform downloads the required provider plugins and initializes the working directory.

Command:

```bash
cd terraform

terraform init
```

Screenshot:

![Terraform Init](/screenshots/terraform-init.png)

Expected Result:

- Terraform backend initialized
- AWS provider downloaded
- `.terraform.lock.hcl` created
- Ready for validation

---

# Step 2 - Validate Configuration

Terraform validates all configuration files before planning infrastructure creation.

Command:

```bash
terraform validate
```

Screenshot:

![Terraform Validate](/screenshots/terraform-validate.png)

Expected Result:

```
Success! The configuration is valid.
```

---

# Step 3 - Format Terraform Code

Terraform formatting ensures consistent code style.

Command

```bash
terraform fmt
```

This formats all `.tf` files automatically.

---

# Step 4 - Review Execution Plan

Terraform generates an execution plan showing the resources that will be created.

Command

```bash
terraform plan
```

Screenshot:

![Terraform Plan](/screenshots/terraform-plan.png)

The plan includes creation of:

- VPC
- Public Subnet
- Private Subnet
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- IAM Role
- EC2 Web Server
- EC2 MongoDB Server

Example:

```
Plan: 15 to add, 0 to change, 0 to destroy.
```

---

# Step 5 - Apply Infrastructure

Terraform provisions the AWS infrastructure.

Command

```bash
terraform apply
```

Type:

```
yes
```

to approve deployment.

Deployment screenshots

Part 1

![Terraform Apply 1](/screenshots/terraform-apply1.png)

Part 2

![Terraform Apply 2](/screenshots/terraform-apply2.png)

Resources Created

- VPC
- Internet Gateway
- Public Route Table
- Private Route Table
- NAT Gateway
- Elastic IP
- Public Subnet
- Private Subnet
- Security Groups
- IAM Role
- IAM Instance Profile
- Web Server EC2
- MongoDB EC2

---

# Step 6 - Verify Terraform State

Verify all resources have been created.

Command

```bash
terraform state list
```

Expected resources include

```
aws_vpc.travelmemory_vpc

aws_subnet.public_subnet

aws_subnet.private_subnet

aws_instance.web_server

aws_instance.mongodb_server

aws_security_group.web_sg

aws_security_group.mongodb_sg
```

![Terraform State List](/screenshots/terraform-state-list.png)

---

# Step 7 - View Terraform Outputs

Display infrastructure outputs.

Command

```bash
terraform output
```

Screenshot

![Terraform Output](/screenshots/terraform-output.png)

Example Outputs

```text
vpc_id

public_subnet_id

private_subnet_id

web_server_public_ip

web_server_private_ip

mongodb_private_ip
```

These outputs are later consumed by Ansible for server configuration.

---

# Terraform Files Explained

| File | Purpose |
|-------|----------|
| provider.tf | AWS Provider configuration |
| variables.tf | Variable declarations |
| terraform.tfvars | Variable values |
| network.tf | VPC, Subnets, Route Tables, NAT Gateway |
| security.tf | Security Groups |
| iam.tf | IAM Role & Instance Profile |
| ec2.tf | EC2 Instances |
| outputs.tf | Infrastructure Outputs |
| main.tf | Common provider configuration |

---

# Infrastructure Summary

Terraform provisions the following AWS resources:

| Resource | Quantity |
|-----------|----------|
| VPC | 1 |
| Public Subnet | 1 |
| Private Subnet | 1 |
| Internet Gateway | 1 |
| NAT Gateway | 1 |
| Elastic IP | 1 |
| Route Tables | 2 |
| Security Groups | 2 |
| IAM Role | 1 |
| IAM Instance Profile | 1 |
| EC2 Web Server | 1 |
| EC2 MongoDB Server | 1 |

---

# Validation Commands

Terraform initialization

```bash
terraform init
```

Validate configuration

```bash
terraform validate
```

Review execution plan

```bash
terraform plan
```

Provision infrastructure

```bash
terraform apply
```

Display outputs

```bash
terraform output
```

List state resources

```bash
terraform state list
```

---

## ✅ Terraform Deployment Status

| Task | Status |
|------|--------|
| Provider Initialized | ✅ |
| Configuration Validated | ✅ |
| Infrastructure Planned | ✅ |
| Infrastructure Provisioned | ✅ |
| Outputs Generated | ✅ |
| State File Created | ✅ |
| EC2 Instances Running | ✅ |
| Ready for Ansible Configuration | ✅ |

---