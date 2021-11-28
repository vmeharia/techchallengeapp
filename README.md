## Deploy techchallengeapp on Azure platform using terraform
Hi, all the code for this solution can be found ***[here][git-repo-url]***
## Usage

Below are steps to be followed for deploying the application

### Clone this repo
```sh
git clone https://github.com/vmeharia/techchallengeapp.git
```
### Login to Azure
Please ensure to login to azure :
#### Azure CLI
```sh
az login

note : If you have multiple subscription on your account, you can either set subscription id using ( az account set -s "subscription name") or uncomment subscription_id in main.tf and add the subscription id(subcription id can be found using az account list -o table) command.
```
#### Azure Powershell module
```sh
Connect-AzAccount
```
### Initalise, Plan and Apply the terraform configuration
```sh
terraform init

terraform plan
note : it will prompt to key in postgres server password, please use a complex 8 to 10 character long password with atleast one special character

terraform apply --auto-approve
note : it will prompt to key in postgres server password, please use a complex 8 to 10 character long password with atleast one special character

Output : Public IP to access the page
```
## Destroy the solution
For destroying the solution and to save the cost use below.

```sh
terraform destroy --auto-approve
note : it will prompt to key in postgres server password, please use a complex 8 to 10 character long password with atleast one special character
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
5) A Kubernetes deployment to deploy the application.
6) A Kubernetes service to expose the deployment to internet.
7) A Kubernetes horizontal pod autoscaler for autoscalling of pods based on CPU.

## Explanation
*I started with building basic infra components like rg, vnet and AKS and later added postgres server and database.

*While building postgres it was not allowing to build in many regions as I am using MSDN Subscription, after a bit of research I was able to deploy in "EAST US" region ***[here][msdn-restrict]***.

*Once I had all the components ready I did a manual deployment using kubectl to check whether application is working with my solution or not. In manual deployment I use yaml file with both 'updatedb -s & serve' as argument and it worked fine. But when I tried to mitigate the same with kubernetes deployment, it seeded the data i.e. 'updatedb -s' completed but 'serve' was not working. 

*After researching for few hours, I found about kubernetes jobs which can be used to run any job. I used kubernetes job to seed the data to postgres database, and kubernetes deployment with args 'serve' for application deployment and process all user requests. 

*Then I used kubernetes service to expose the deployment to internet and get the public IP to acess the application page.

*I have included comment as and where neccessary and also tried to use variable in most of the places.
 For making the code secure and password less, when terraform is intiated it will prompt for a postgres server password and internally it will call in various location and never reveal the password.

*I tried to make the code as simple as possible and didn't overengineered the solution.
 For resiliency and high availability I have enabled autoscaling on the pods where application is running with a metric of CPU more than 70%. On postgres side as I am using Azure Database for PostgreSQL, high availability is already inbuilt (ref: ***[here][postgres-azure-url]***). We can also try using Azure Database for PostgreSQL Flexible Server which gives more option for high availability, but as it is in public preview I haven't used in my solution.

*I have attached graph.svg with a graphical representation of the solution.

## Technical Challenge
The only challenge I faced while building this solution was, I used to build infra using terraform for example in my current projects I have used terraform infra as code to build around 46 resources in less than 15 mins, but with this solution I was supposed to do the deployment too which we used to do manually using kubectl, helm etc. Now after deployment of this solution I am confident to intergrate kubernetes deployment in terraform code from end to end.

[git-repo-url]: https://github.com/vmeharia/techchallengeapp
[postgres-azure-url]: https://docs.microsoft.com/en-us/azure/postgresql/concepts-high-availability
[msdn-restrict]: https://social.msdn.microsoft.com/Forums/azure/en-US/e3e7ab8b-a00c-4204-9e9d-7dd7be315516/error-this-subscription-is-restricted-from-provisioning-postgresql-servers-in-this-region-when?forum=AzureDatabaseforPostgreSQL