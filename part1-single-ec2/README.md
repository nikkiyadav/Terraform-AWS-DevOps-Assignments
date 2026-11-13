\# Part 1: Deploy Flask Backend and Express Frontend on a Single AWS EC2 Instance Using Terraform



\## 1. Objective



The objective of this assignment is to provision an AWS EC2 instance using Terraform, deploy a Flask backend and an Express frontend on the same instance, and verify that users can register students through the web application.



\## 2. Architecture



The application uses a two-tier architecture:



\- \*\*Frontend:\*\* Node.js with Express, running on port 3000.

\- \*\*Backend:\*\* Python with Flask, served using Gunicorn on port 5000.

\- \*\*Infrastructure:\*\* One Ubuntu 24.04 EC2 instance.

\- \*\*Provisioning:\*\* Terraform.

\- \*\*Automation:\*\* EC2 User Data Bash script.

\- \*\*Networking:\*\* AWS VPC and Security Group.



\### Application request flow



1\. The user opens the application using the EC2 public IP and port 3000.

2\. Express serves the registration form.

3\. When a user submits the form, Express forwards the request to Flask.

4\. Flask validates and processes the student details.

5\. Express returns the backend response to the browser.

6\. The frontend displays the registration result and registered students.



The Flask backend listens on `127.0.0.1:5000`, so it is accessible internally from the EC2 instance rather than directly from the public internet.



\## 3. Technologies used



| Technology | Purpose |

|---|---|

| Terraform | Infrastructure as Code |

| AWS EC2 | Virtual machine hosting the applications |

| Ubuntu 24.04 LTS | Operating system |

| AWS Security Group | Network access control |

| Bash / User Data | Automated application setup |

| Python and Flask | Backend application |

| Gunicorn | Flask WSGI application server |

| Node.js and Express | Frontend server and API proxy |

| Git | Downloading application source code |

| systemd | Managing application services |



\## 4. Project structure



```text

part1-single-ec2/

│

├── provider.tf

├── variables.tf

├── main.tf

├── outputs.tf

├── user\_data.sh

├── .terraform.lock.hcl

│

└── app/

&#x20;   ├── backend/

&#x20;   │   ├── app.py

&#x20;   │   └── requirements.txt

&#x20;   │

&#x20;   └── frontend/

&#x20;       ├── server.js

&#x20;       ├── package.json

&#x20;       ├── package-lock.json

&#x20;       └── public/

&#x20;           └── index.html

```



Terraform provisions infrastructure using the `.tf` files. The User Data script downloads the application from the configured GitHub repository and installs and starts both application services.



\## 5. AWS and Terraform configuration



\### Step 1: Configure AWS authentication



AWS CLI and Terraform must be installed on the local machine.



Authenticate using the configured AWS SSO profile:



```powershell

aws sso login --profile nikki-devops

$env:AWS\_PROFILE = "nikki-devops"

```



\### Step 2: Configure the Terraform provider



The `provider.tf` file specifies the Terraform version requirement, AWS provider and AWS region.



The deployment region is:



```text

eu-north-1

```



\### Step 3: Define input variables



The `variables.tf` file defines:



| Variable | Default value |

|---|---|

| aws\_region | eu-north-1 |

| instance\_type | t3.medium |

| project\_name | terraform-student-app |



These variables make the configuration easier to maintain and reuse.



\### Step 4: Configure infrastructure



The `main.tf` file contains the following resources and data sources:



\- Finds the latest matching Ubuntu 24.04 LTS AMI.

\- Identifies the default VPC.

\- Retrieves subnets belonging to that VPC.

\- Creates an application security group.

\- Creates an EC2 instance.

\- Associates the security group, SSH key pair and public IP.

\- Executes the `user\_data.sh` script during instance initialization.



\### Step 5: Configure security group rules



The security group allows:



| Protocol | Port | Source | Purpose |

|---|---:|---|---|

| TCP | 3000 | 0.0.0.0/0 | Public Express frontend access |

| TCP | 22 | Configured administrator IP (/32) | SSH administration |

| All | All outbound | 0.0.0.0/0 | Outbound connectivity |



Port 5000 is not opened publicly because Express communicates with Flask internally.



\### Step 6: Configure Terraform outputs



The `outputs.tf` file displays:



\- EC2 instance ID

\- Public IPv4 address

\- Public DNS name

\- Application URL



\## 6. Automated application deployment



The `user\_data.sh` script automates application setup when the EC2 instance initializes.



The script performs these operations:



1\. Configures Bash to stop if a command fails.

2\. Writes installation logs to `/var/log/student-app-setup.log`.

3\. Updates Ubuntu package repositories.

4\. Installs Git, Python, Python virtual environment tools, Node.js and npm.

5\. Clones the application source from GitHub.

6\. Creates a Python virtual environment.

7\. Installs Flask, Flask-CORS and Gunicorn.

8\. Installs Express dependencies using `npm ci --omit=dev`.

9\. Creates the Flask systemd service.

10\. Creates the Express systemd service.

11\. Enables and starts both services.



\### Flask service



Gunicorn runs the Flask backend using:



```bash

gunicorn --workers 2 --bind 127.0.0.1:5000 app:app

```



\### Express service



The Express frontend runs using Node.js:



```bash

node /opt/student-registration/frontend/server.js

```



Both services are configured to restart automatically if they fail.



\## 7. Terraform deployment procedure



Navigate to the Part 1 project directory:



```powershell

cd part1-single-ec2

```



Initialize Terraform and download the required provider:



```powershell

terraform init

```



Format Terraform configuration files:



```powershell

terraform fmt

```



Validate the configuration:



```powershell

terraform validate

```



Review the infrastructure changes:



```powershell

terraform plan

```



Create the AWS infrastructure:



```powershell

terraform apply

```



Review the proposed changes and confirm with `yes`.



After successful deployment, Terraform displays the EC2 instance details and application URL.



\## 8. Application verification



\### Verify Flask backend



Connect to the EC2 instance using SSH:



```powershell

ssh -i "$HOME\\Downloads\\Tutedude\_key\_pair\_AWS.pem" ubuntu@EC2\_PUBLIC\_IP

```



Check the Flask service:



```bash

sudo systemctl status flask-backend --no-pager

```



Test the Flask endpoint:



```bash

curl http://127.0.0.1:5000/

```



Expected response:



```json

{

&#x20; "message": "Flask Backend is running!",

&#x20; "status": "success"

}

```



\### Verify Express frontend



Check the Express service:



```bash

sudo systemctl status express-frontend --no-pager

```



Test the Express health endpoint:



```bash

curl http://127.0.0.1:3000/health

```



Expected response:



```json

{

&#x20; "message": "Express frontend is running!",

&#x20; "status": "success"

}

```



\### Verify backend API through Express



Retrieve registered students:



```bash

curl http://127.0.0.1:3000/api/students

```



Register a test student:



```bash

curl -X POST http://127.0.0.1:3000/api/students \\

\-H "Content-Type: application/json" \\

\-d '{"name":"DevOps Test","email":"devops.test@example.com"}'

```



Retrieve the student list again:



```bash

curl http://127.0.0.1:3000/api/students

```



The response confirms that Express successfully forwards requests to Flask and returns the registered student details.



\## 9. Browser testing



Open the application using:



```text

http://EC2\_PUBLIC\_IP:3000

```



Verify the following:



\- Registration form is displayed.

\- User can enter student name and email.

\- Form submission succeeds.

\- Success message is displayed.

\- Registered students are displayed on the page.



\## 10. Troubleshooting performed



During initial deployment, the EC2 User Data script did not execute because there was a blank line before the Bash shebang:



```bash

\#!/bin/bash

```



The cloud-init log reported an execution format error.



The issue was diagnosed and resolved by executing the generated script explicitly through Bash on the EC2 instance:



```bash

sudo bash /var/lib/cloud/instance/scripts/part-001

```



The local `user\_data.sh` file was also corrected so that the shebang is its first line. Both application services subsequently started successfully.



\## 11. Evidence collected



The following screenshots were captured as deployment evidence in the `Part1\_Evidence` folder:



1\. Terraform apply output.

2\. EC2 instance details.

3\. Security group inbound rules.

4\. Flask service status.

5\. Express service status.

6\. Application health-check outputs.

7\. Student registration form and success message.

8\. Registered students list.



\## 12. Result



Successfully provisioned an AWS EC2 instance using Terraform and deployed a Flask backend and Express frontend on the same instance.



Both application services were verified as running. The Express frontend successfully communicated with the Flask backend, and student registration was tested through the browser and API endpoints.



\*\*Note:\*\* Student information is stored in an in-memory Python list for this assignment demonstration. It is not persistent database storage and is cleared when the Flask process restarts.



\## 13. Infrastructure cleanup



After collecting the required evidence and completing the assignment, AWS resources should be removed to avoid unnecessary ongoing charges.



From the Terraform project directory, review the destruction plan:



```powershell

terraform plan -destroy

```



When ready, destroy the resources managed by this Terraform configuration:



```powershell

terraform destroy

```



Review the plan and confirm with `yes`.



Verify that Terraform no longer manages any resources:



```powershell

terraform state list

```



The state listing should be empty after successful cleanup.
