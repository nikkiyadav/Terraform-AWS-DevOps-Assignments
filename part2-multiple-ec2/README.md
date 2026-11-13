



\# Terraform Assignment – Part 2: Multiple EC2 Deployment



\## 1. Project Overview



This project demonstrates how to use \*\*Terraform and AWS\*\* to provision two separate EC2 instances and deploy a full-stack student registration application.



The application is divided into two components:



\- \*\*Frontend:\*\* Node.js with Express, deployed on one EC2 instance.

\- \*\*Backend:\*\* Python with Flask, deployed on a separate EC2 instance.



Terraform automates the creation of the AWS infrastructure, networking, security groups and EC2 instances. User-data scripts install the required software and start the applications automatically.



\## 2. Architecture



```text

&#x20;                 Internet

&#x20;                    |

&#x20;             Internet Gateway

&#x20;                    |

&#x20;              Public Subnet

&#x20;                10.0.1.0/24

&#x20;                    |

&#x20;         -------------------------

&#x20;         |                       |

&#x20;   Express EC2                Flask EC2

&#x20;   Frontend                   Backend

&#x20;   Port 3000                  Port 5000

&#x20;         |                       |

&#x20;         -------- Private IP ----

&#x20;             API communication

```



\*\*AWS networking:\*\*

\- VPC CIDR: `10.0.0.0/16`

\- Public subnet CIDR: `10.0.1.0/24`

\- Region: `eu-north-1`

\- EC2 instance type: `t3.small`

\- Operating system: Ubuntu 24.04 LTS



Express communicates with Flask using the Flask EC2 instance's private IP address.



\## 3. Project Structure



| File / Folder | Description |

|---|---|

| `provider.tf` | Configures the AWS provider, region and profile. |

| `variables.tf` | Defines reusable Terraform variables such as instance type and SSH allowed CIDR. |

| `network.tf` | Creates the VPC, public subnet, Internet Gateway and route table. |

| `security\_groups.tf` | Defines separate security groups and firewall rules for both EC2 instances. |

| `ec2.tf` | Finds the Ubuntu AMI and provisions the Flask and Express EC2 instances. |

| `outputs.tf` | Displays instance IDs, public/private IP addresses and application URLs. |

| `flask\_user\_data.sh` | Installs Python dependencies and configures the Flask backend with Gunicorn. |

| `express\_user\_data.sh` | Installs Node.js dependencies and configures the Express frontend. |



\## 4. AWS Infrastructure Created



Terraform provisions the following resources:



1\. Custom AWS VPC.

2\. Public subnet.

3\. Internet Gateway.

4\. Route table.

5\. Internet route.

6\. Route table association.

7\. Flask security group.

8\. Express security group.

9\. Flask EC2 instance.

10\. Express EC2 instance.



\## 5. Security Group Configuration



| Component | Port | Access |

|---|---:|---|

| Express frontend | TCP 3000 | Public internet |

| Flask backend | TCP 5000 | Public internet |

| SSH access | TCP 22 | Restricted to the configured SSH IP address |



Both application ports are publicly accessible for this assignment. In a production architecture, the Flask backend would normally be restricted to traffic from the Express security group or placed in a private subnet.



\## 6. Application Deployment



\### Flask Backend



The `flask\_user\_data.sh` script automates:



\- Installing Git and Python.

\- Downloading the application source code.

\- Creating a Python virtual environment.

\- Installing Python requirements.

\- Configuring Gunicorn.

\- Creating and starting the Flask systemd service.



\### Express Frontend



The `express\_user\_data.sh` script automates:



\- Installing Git, Node.js and npm.

\- Downloading the application source code.

\- Installing Node.js dependencies.

\- Configuring the Flask backend URL using its private IP.

\- Creating and starting the Express systemd service.



\## 7. Terraform Commands



Run the following commands from the `part2-multiple-ec2` directory.



Initialize Terraform:



```powershell

terraform init

```



Format Terraform files:



```powershell

terraform fmt

```



Validate the configuration:



```powershell

terraform validate

```



Generate an execution plan:



```powershell

terraform plan -out=tfplan

```



Apply the execution plan:



```powershell

terraform apply "tfplan"

```



Display Terraform outputs:



```powershell

terraform output

```



\## 8. Application Testing



The following tests were performed successfully.



| Test | Expected Result | Status |

|---|---|---|

| Flask backend root endpoint | Backend running message | Passed |

| Express health endpoint | Frontend running message | Passed |

| Express to Flask GET request | HTTP 200 response | Passed |

| Student registration POST request | Student registration successful | Passed |

| Retrieve registered student | Previously registered student returned | Passed |



Example endpoints:



```text

Flask Backend:

http://<FLASK\_PUBLIC\_IP>:5000/



Express Frontend:

http://<EXPRESS\_PUBLIC\_IP>:3000/



Express Health Check:

http://<EXPRESS\_PUBLIC\_IP>:3000/health



Express API:

http://<EXPRESS\_PUBLIC\_IP>:3000/api/students

```



The actual public IP addresses can be obtained using:



```powershell

terraform output

```



\## 9. Important Troubleshooting



During testing, the Flask application was initially configured with two Gunicorn workers.



The student registration application stores records in an in-memory Python list. Each Gunicorn worker has separate memory, so a record created by one worker might not be visible to another worker.



For this assignment demonstration, Gunicorn was changed to use one worker:



```text

\--workers 1

```



The Flask service was restarted and the POST and GET API tests then worked successfully.



\*\*Note:\*\* This is a demonstration workaround. In a production application, student records should be stored in a persistent database rather than an in-memory list.



\## 10. Validation Results



The following Terraform validation commands completed successfully:



```powershell

terraform fmt -check

terraform validate

```



Terraform deployment result:



```text

Apply complete!

Resources: 10 added, 0 changed, 0 destroyed.

```



\## 11. Learning Outcomes



Through this assignment, I practised:



\- Infrastructure as Code using Terraform.

\- AWS provider configuration.

\- Creating a custom VPC and public subnet.

\- Configuring Internet Gateway and route tables.

\- Creating and configuring AWS security groups.

\- Provisioning multiple EC2 instances.

\- Automating application deployment using user-data scripts.

\- Deploying Flask and Express applications on separate servers.

\- Configuring private IP communication between EC2 instances.

\- Testing REST API communication between frontend and backend.

\- Troubleshooting application services on AWS EC2.



\## 12. Repository



GitHub repository:



\[Terraform-AWS-DevOps-Assignments](https://github.com/nikkiyadav/Terraform-AWS-DevOps-Assignments)



Project folder:



`part2-multiple-ec2`





