# Deploying TravelMemory (MERN Stack) on AWS with Terraform + Ansible

This repo provisions AWS infrastructure with **Terraform** and configures/deploys the
[TravelMemory](https://github.com/UnpredictablePrashant/TravelMemory) MERN application
with **Ansible**.

## Architecture

```
                         Internet
                             │
                     ┌───────▼────────┐
                     │ Internet Gateway│
                     └───────┬────────┘
                             │
                    VPC (10.0.0.0/16)
        ┌────────────────────┴─────────────────────┐
        │                                           │
┌───────▼────────────┐                    ┌─────────▼──────────┐
│ Public Subnet       │                    │ Private Subnet      │
│ 10.0.1.0/24          │                    │ 10.0.2.0/24          │
│                       │                    │                       │
│ ┌───────────────────┐ │   port 27017 only  │ ┌───────────────────┐ │
│ │ Web EC2 instance    │─┼────(web SG)───────┼─▶│ DB EC2 instance     │ │
│ │ - Nginx (port 80)   │ │                    │ │ - MongoDB           │ │
│ │ - React build        │ │                    │ │ - auth enabled       │ │
│ │ - Express API :3000  │ │                    │ │ - app-only user      │ │
│ └───────────────────┘ │                    │ └───────────────────┘ │
└─────────┬─────────────┘                    └──────────┬────────────┘
          │ SSH (my IP only)                              │
          │                                    ┌───────────▼──────────┐
          │                                    │      NAT Gateway       │
          ▼                                    │ (outbound apt/npm only)│
     My laptop                                 └────────────────────────┘
```

**How the pieces interact:**
- The **web EC2 instance** sits in the public subnet, has a public IP, and is the
  only box reachable from the internet (SSH restricted to my IP; HTTP/3000 open).
- The **db EC2 instance** sits in the private subnet with no public IP. It can only
  be reached on port 27017 from the web server's security group, and it reaches the
  internet outbound (for `apt` package installs) through the NAT Gateway.
- Ansible configures the web server to run the **Express backend** with `pm2` on
  port 3000, and serves the **React frontend's production build** via **Nginx** on
  port 80. Nginx also reverse-proxies `/api/` to the backend.
- The backend connects to MongoDB using the DB server's **private IP**, so database
  traffic never leaves the VPC.

## Prerequisites

- An AWS account with an IAM user that has EC2/VPC/IAM permissions
- AWS CLI installed and configured (`aws configure`)
- Terraform >= 1.5
- Ansible >= 2.15, plus the `community.mongodb` collection
- An existing EC2 key pair (create one in the AWS console or via `aws ec2 create-key-pair`)
- Your local public IP (`curl -s ifconfig.me`)

## Part 1 — Provision infrastructure with Terraform

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars: set key_pair_name and my_ip

terraform init
terraform plan
terraform apply
```

This creates:
- A VPC with one public and one private subnet
- An Internet Gateway (public subnet) and NAT Gateway (private subnet's outbound access)
- Route tables wiring each subnet to the right gateway
- A web-tier security group (SSH from my IP, HTTP 80, app port 3000) and a
  db-tier security group (SSH + Mongo 27017, both restricted to the web SG)
- An IAM role + instance profile (SSM + CloudWatch access) attached to both instances
- Two EC2 instances: `web` (public subnet) and `db` (private subnet)

At the end, note the outputs:

```bash
terraform output
# web_server_public_ip = "x.x.x.x"
# db_server_private_ip = "10.0.2.x"
```

## Part 2 — Configure and deploy with Ansible

```bash
cd ../ansible
ansible-galaxy collection install -r requirements.yml

cp inventory.ini.example inventory.ini
# fill in <WEB_PUBLIC_IP> and <DB_PRIVATE_IP> using the terraform output above

cp group_vars/vault.yml.example group_vars/vault.yml
# fill in real Mongo credentials, then encrypt:
ansible-vault encrypt group_vars/vault.yml
```

Copy your `.pem` key to `~/.ssh/mern-assignment-key.pem` and `chmod 400` it, then
verify connectivity:

```bash
ansible all -i inventory.ini -m ping --ask-vault-pass
```

Run the full playbook:

```bash
ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass
```

This will, in order:
1. **Database role** — installs MongoDB 7.0, binds it to listen inside the VPC,
   enables authentication, creates an admin user and an app-scoped user/database,
   and locks down `ufw` so only the web server's subnet can reach port 27017.
2. **Web role** — installs Node.js 20 + pm2, clones TravelMemory, installs backend
   and frontend dependencies, writes the backend `.env` with the Mongo connection
   string (pointing at the DB server's private IP), builds the React frontend,
   configures Nginx to serve it and proxy `/api/`, starts the backend under pm2
   (with a systemd unit so it survives reboot), and hardens SSH (`PermitRootLogin no`,
   `PasswordAuthentication no`) plus firewall rules.

## Verifying the deployment

```bash
curl http://<web_server_public_ip>/           # React app should load
curl http://<web_server_public_ip>:3000/      # Express API should respond
```

Open `http://<web_server_public_ip>/` in a browser to see the working TravelMemory app.

## Security hardening implemented

- SSH to the web server restricted to the operator's IP only; DB server has no
  public IP at all and is reachable only via the web server's security group.
- MongoDB authentication enabled; app uses a least-privilege user scoped to one database.
- `ufw` enabled on both hosts with a default-deny policy.
- Root SSH login and password authentication disabled on the web server.
- Secrets (DB credentials) kept out of Git via `ansible-vault` and `.gitignore`.

## Repo layout

```
terraform/     # AWS infrastructure (VPC, subnets, gateways, EC2, SGs, IAM)
ansible/       # Configuration management and app deployment
  roles/database/   # MongoDB install + hardening
  roles/webserver/  # Node.js, TravelMemory app, Nginx, pm2, SSH hardening
```

## Tearing down

```bash
cd terraform
terraform destroy
```