# techchallengeapp
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