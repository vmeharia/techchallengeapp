## Deploy techchallengeapp on Azure platform using terraform
Hi, all the code for this solution can be found ***[here][git-repo-url]***
## Usage

Below are steps for followed to deploy the application

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
note : it will prompt to key in postgres server password, please use a complex 8 to 10 charater long password with atleast one special charcter

terraform apply --auto-approve
note : it will prompt to key in postgres server password, please use a complex 8 to 10 charater long password with atleast one special charcter

Output : Public IP to access the page
```
## Destroy the solution
To destroy the solution to save the cost use below.

```sh
terraform destory --auto-approve
note : it will prompt to key in postgres server password, please use a complex 8 to 10 charater long password with atleast one special charcter
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

## Explanation
First of all i really love deploying this solution it was challenging and i really learned lot of new things while building this solution and i thank servian team for giving this opportunity.
I started with building basic infra components like rg, vnet and AKS and the later added postgres server and database.
While building postgres it was not allowing to build in many regions as i am using MSDN Subscription after a bit of research i was able to deploy in "eastus" Reference ***[here][msdn-restric]***. Once i have all the components ready i did a manual deployment using kubectl to check whether application is working with my solution, in manual deployment i use yaml file with both (updatedb -s & serve) as argument and it worked fine. but when i tried to mitigate the same with kubernetes deployment it seeded the data meaning (updatedb -s) completed but (serve) was not working. After researching for few hours i found about kubernetes jobs which can be use to run any job and pod will be in completed state after job is completed. I use kubernetes job to seed the data to postgres database, and kubernetes deployment with args (serve) for application deployment and process all user requests. Then i use kubernetes service to expose the deployment to internet and get the public IP to acess the applicaiton page.

I have included comment as and where neccessary and also try to use variable in most of the places.
For making the code secure and password less, when terraform is intiated it will prompt for a postgres server password and internally it will call in various location and never revel the password.
I tried to make the code as simple as possible and didn't overengineered the solution.
For resiliency and high availability i have enabled autoscalling on the pods where application are run with a metric of CPU more than 70%. On postgres as i am using Azure Database for PostgreSQL it high availability inbuild (ref: ***[here][postgres-azure-url]***). We can also try using Azure Database for PostgreSQL Flexible Server which gives more option for high availability but as it is in preview i haven't used in my solution.

I have attached graph.svg with a graphical representation of the solution.

## Technical Challenge
The only challenge i faced while building this solution is i used to only build infra using the terraform for example in my current projects i have used terraform infra as code to build to build around 46 resources in less than 15 mins, but with this solution i was suppose to do the deployment too which we used to do manually using kubectl, helm etc. Now after deployment of this solution i am confident to intergrate kubernetes deployment in terraform code for other project.

[git-repo-url]: https://github.com/vmeharia/techchallengeapp
[postgres-azure-url]: https://docs.microsoft.com/en-us/azure/postgresql/concepts-high-availability
[msdn-restrict]: https://social.msdn.microsoft.com/Forums/azure/en-US/e3e7ab8b-a00c-4204-9e9d-7dd7be315516/error-this-subscription-is-restricted-from-provisioning-postgresql-servers-in-this-region-when?forum=AzureDatabaseforPostgreSQL