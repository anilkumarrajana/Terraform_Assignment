# 🚀 TravelMemory Deployment using Terraform & Ansible on AWS

<p align="center">

![Terraform](https://img.shields.io/badge/Terraform-v1.14+-623CE4?logo=terraform)
![Ansible](https://img.shields.io/badge/Ansible-2.16+-EE0000?logo=ansible)
![AWS](https://img.shields.io/badge/AWS-EC2%20%7C%20VPC%20%7C%20IAM-FF9900?logo=amazonaws)
![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-E95420?logo=ubuntu)
![MongoDB](https://img.shields.io/badge/MongoDB-8.0-47A248?logo=mongodb)
![NodeJS](https://img.shields.io/badge/Node.js-v20-339933?logo=node.js)
![PM2](https://img.shields.io/badge/PM2-Process%20Manager-2B037A)
![License](https://img.shields.io/badge/License-MIT-blue)

</p>

---

# 📖 Project Overview

This project demonstrates a complete Infrastructure as Code (IaC) and Configuration Management workflow using **Terraform** and **Ansible** to deploy the **TravelMemory** application on **Amazon Web Services (AWS)**.

The infrastructure is provisioned using Terraform, while Ansible automates the configuration of both the application server and the MongoDB database server.

The deployment provisions:

- Amazon VPC
- Public Subnet
- Private Subnet
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- IAM Role & Instance Profile
- EC2 Web Server
- EC2 MongoDB Server
- Node.js 20
- MongoDB 8.0
- PM2 Process Manager
- TravelMemory Backend Application

The repository also includes detailed documentation for each deployment stage under the `docs/` directory, making it easier to understand and reproduce each phase of the implementation.

---


# 🎯 Objectives

- Provision AWS infrastructure using Terraform
- Configure servers using Ansible
- Deploy TravelMemory backend
- Configure MongoDB in a private subnet
- Manage the application using PM2
- Verify successful deployment

---

# 📑 Table of Contents

- [Project Overview](#-project-overview)
- [Architecture](#-architecture)
- [Repository Structure](#-repository-structure)
- [Project Documentation](#-project-documentation)
- [Terraform Deployment](#-terraform-deployment)
- [AWS Infrastructure](#-aws-infrastructure)
- [Ansible Configuration](#-ansible-configuration)
- [Application Verification](#-application-verification)
- [Challenges Faced](#-challenges-faced)
- [Future Enhancements](#-future-enhancements)
- [Author](#-author)

---

# 🏗 Architecture

```text
                          Internet
                              │
                     Internet Gateway
                              │
                    Public Route Table
                              │
                 Public Subnet (10.0.1.0/24)
                              │
               TravelMemory Web Server (Ubuntu)
                ├── Node.js 20
                ├── PM2
                └── TravelMemory Backend
                              │
                     Private Route Table
                              │
                 Private Subnet (10.0.2.0/24)
                              │
                  MongoDB Server (Ubuntu)
                         MongoDB 8.0
```
![Architecture](screenshots/architecture-diagram.png)
---

# 📂 Repository Structure

Repository Structure:

![Repository Structure](screenshots/tree.png)

```text
travelmemory-terraform-ansible/
├── README.md
├── Ansile_README.md
├── Terraform_README.md
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── network.tf
│   ├── security.tf
│   ├── iam.tf
│   ├── ec2.tf
│   ├── outputs.tf
│   └── main.tf
│
├── ansible/
│   ├── inventory
│   ├── ansible.cfg
│   ├── playbook.yml
│   ├── group_vars/
│   └── roles/
│       ├── common/
│       ├── nodejs/
│       ├── mongodb/
│       └── application/
│
├── screenshots/

```
---
# 📚 Project Documentation

Detailed documentation for each component is available in the `docs` directory.

| Documentation | Description |
|---------------|-------------|
| [Terraform Deployment](Terraform_README.md) | Infrastructure provisioning using Terraform |
| [Ansible Deployment](Ansile_README.md) | Configuration management, roles, inventory, playbooks |


---

# ⚙️ Prerequisites

The following software was installed before deployment.

| Software | Version |
|----------|----------|
| Terraform | v1.14.x |
| Ansible | 2.16.x |
| AWS CLI | v2 |
| Ubuntu | 24.04 |
| Node.js | v20 |
| MongoDB | 8.0 |
| PM2 | Latest |
| Git | Latest |

---

# ☁ AWS Region

```
ap-south-1 (Mumbai)
```

---

# 📦 Application Repository

https://github.com/UnpredictablePrashant/TravelMemory

---

# 🏗 Infrastructure Repository

https://github.com/anilkumarrajana/Terraform_Assignment.git

---

---

