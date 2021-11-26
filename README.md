### Techchallengeapp
# Deploy techchallengeapp on Azure platform using terraform

## Usage

Below are steps for followed to deploy the application

### Clone this repo
```sh
https://github.com/vmeharia/techchallengeapp.git
```
### Login to Azure
Please ensure to login to azure :
#### Azure CLI
```sh
az login
```
#### Azure Powershell module
```sh
Connect-AzAccount
```
### Initalise, Plan and Apply the terraform configuration
```sh
terraform init

terraform plan
note : it will prompt to key in postgres server password, please use a complex 8 to 10 charater long password with atleast one special charcter

terraform apply --auto-approve
note : it will prompt to key in postgres server password, please use a complex 8 to 10 charater long password with atleast one special charcter

Output : Public IP to access the page
```
## Technology Used for the deployment
The technologies used for deployment are:
1) Microsoft Azure
2) Hashicorp Terraform
3) Kubernetes
4) Docker

## Approach
I have used below approach to complete the solution.
1) Terraform as infra as code to deploy all the components.
2) Postgres server and database to be used as backend to store data.
3) An Azure Kubernetes service to host the application inside a pod.
4) A Kubernetes job to seed the data.
5) A Kubernetest deployment to deploy the application.