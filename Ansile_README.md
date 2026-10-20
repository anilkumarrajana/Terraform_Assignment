# 🤖 Ansible Configuration & Deployment

After provisioning the AWS infrastructure with Terraform, **Ansible** was used to configure both EC2 instances and deploy the TravelMemory backend application.

The automation included:

- Operating System Updates
- Package Installation
- Node.js Installation
- PM2 Installation
- MongoDB Installation
- Application Deployment
- Environment Configuration
- Backend Service Startup

---

# 📂 Ansible Project Structure

```text
ansible/
├── ansible.cfg
├── inventory
├── playbook.yml
├── group_vars/
│   └── all.yml
├── host_vars/
└── roles/
    ├── common/
    │   └── tasks/
    │       └── main.yml
    ├── nodejs/
    │   └── tasks/
    │       └── main.yml
    ├── mongodb/
    │   └── tasks/
    │       └── main.yml
    └── application/
        └── tasks/
            └── main.yml
```

---

# 📋 Inventory Configuration

The inventory file defines the managed hosts.

Example:

```ini
[web]
web ansible_host=<WebServer-Public-IP>

[db]
mongodb ansible_host=<MongoDB-Private-IP>

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/travelmemory-key.pem
```

The MongoDB server is accessed securely using **SSH ProxyJump** through the Web Server.

---

# ⚙️ Group Variables

Global variables were defined inside:

```
group_vars/all.yml
```

Example configuration:

```yaml
node_version: "20"

mongodb_version: "8.0"

app_repo: "https://github.com/UnpredictablePrashant/TravelMemory.git"

app_directory: "/opt/travelmemory"

mongo_port: 27017
```

This keeps the playbook reusable and easy to maintain.

![Ansible Group All](/screenshots/ansible-group-all.png)

---

# ▶️ Main Playbook

The deployment is orchestrated using:

```
playbook.yml
```

The playbook executes the following roles in sequence:

```text
Configure Web Server

    ↓

Common Role

    ↓

NodeJS Role

    ↓

Application Role

    ↓

Configure MongoDB Server

    ↓

MongoDB Role
```

---

# 🛠 Common Role

The **Common Role** prepares the servers by:

- Updating package repositories
- Upgrading installed packages
- Installing common utilities

Tasks performed

```text
✔ apt update

✔ apt upgrade

✔ git

✔ curl

✔ unzip

✔ python3-pip
```

---

# 🟢 Node.js Role

The Node.js role performs:

- Add NodeSource Repository
- Install Node.js 20
- Install npm
- Install PM2 globally

Verification

```bash
node -v
```

Expected

```
v20.x.x
```

---

# 🍃 MongoDB Role

The MongoDB role performs:

- Import MongoDB GPG Key
- Add MongoDB Repository
- Install MongoDB 8.0
- Enable Service
- Start Service
- Verify Service Status

Verification

```bash
systemctl is-active mongod
```

Expected

```
active
```

---

# 🚀 Application Role

The Application role automates deployment of the TravelMemory backend.

Tasks performed

✔ Clone GitHub Repository

✔ Install Backend Dependencies

✔ Install Frontend Dependencies

✔ Generate Backend .env

✔ Configure MongoDB Connection

✔ Start Backend using PM2

✔ Save PM2 Configuration

---

## Generated Environment File

The following environment variables are configured automatically.

```env
PORT=3001

MONGO_URI=mongodb://10.0.2.82:27017/travelmemory
```

---

# 🔄 Verify Connectivity

Before executing the playbook, connectivity to all managed hosts is verified.

Command

```bash
ansible all -m ping
```

Screenshot

![Ansible Ping](/screenshots/ansible-ping-all.png)

Expected Result

```
web

pong

mongodb

pong
```

---

# ▶️ Execute Playbook

Deployment Command

```bash
ansible-playbook playbook.yml
```

---

## Playbook Execution

### Configure Web Server

Screenshot

![Playbook](/screenshots/ansible-playbook-1.png)

The Web Server configuration includes:

- Common Packages
- Node.js
- PM2
- TravelMemory Deployment

---

### Application Deployment

Screenshot

![Playbook](/screenshots/ansible-playbook-2.png)

Tasks executed

- Clone Repository
- npm install
- Create .env
- PM2 Start
- PM2 Save

---

### MongoDB Deployment

Screenshot

![Playbook](/screenshots/ansible-playbook-3.png)

Tasks executed

- Install MongoDB
- Enable Service
- Start Service
- Verify Service

---

# 📦 PM2 Process Manager

The backend application is managed using PM2.

Command

```bash
pm2 list
```

Screenshot

![PM2](/screenshots/pm2-list.png)

Expected

```
travelmemory-backend

online
```

PM2 Benefits

- Automatic restart
- Crash recovery
- Process monitoring
- Persistent process list

---

# 🔍 Deployment Verification

The following validations were performed.

Verify backend

```bash
curl http://localhost:3001/hello
```

Verify PM2

```bash
pm2 list
```

Verify MongoDB

```bash
sudo systemctl status mongod
```

---

# 📊 Deployment Summary

| Component | Status |
|------------|--------|
| Common Role | ✅ Success |
| NodeJS Role | ✅ Success |
| MongoDB Role | ✅ Success |
| Application Role | ✅ Success |
| Backend Deployment | ✅ Success |
| PM2 Configuration | ✅ Success |
| MongoDB Service | ✅ Running |
| Application Verification | ✅ Completed |

---

# 🏆 Ansible Automation Highlights

✔ Modular role-based design

✔ Reusable inventory

✔ Centralized variables

✔ Automated dependency installation

✔ Automated backend deployment

✔ Automated MongoDB configuration

✔ PM2 process management

✔ Infrastructure ready for repeatable deployments

---