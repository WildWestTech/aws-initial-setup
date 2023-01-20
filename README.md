# aws-initial-setup
- In this repo, we'll run through some notes for setting up an AWS account for the first time.  
- We'll start in the console:
  - back our root account with MFA
  - federate our account by adding organizations
  - enable and configure sso
  - create users, groups, and leverage a pre-defined permission set
  - navigate away from using the root account
- Next, you'll need to install a few tools for working programmatically with AWS (AWS CLI & Terraform)
- Once your tools are installed and configured, we'll perform a one-time configuration for terraform's backend statefile.  Terraform is a programming language used for developing infrastructure as code.  It's similar to tools like cloudformation and python's boto3.  However, because these files contain the state of our infrastructure, they can contain some sensitive information that we don't want exposed in source control.  Additionally, we'd like to lock these files, so multiple developers aren't making changes to the file at once.  Additionally, we'd like these files to be centrally located.  For these reasons, we'll create a few simple resources in AWS to help us achieve this process.
- The way this repo has been setup, we have environment-specific directories.  So when executing your code, you'll want to navigate to the main.tf file in dev and run your terraform init & terraform apply commands from there.  Similarly, when you want to execute your code for prod, you'll want to navigate to the prod directory.  I think you get the gist.

## AWS Account Setup
- This is largely GUI/console based
- https://github.com/WildWestTech/aws-infra/blob/main/AccountSetup.md

## Install AWS CLI
- We'll need the AWS command line interface tool for interacting with AWS resources
- https://aws.amazon.com/cli/

## Install Terraform
- Once we have an AWS account setup and we have AWS CLI installed, we can start developing our infrastructure as code, via terraform
- https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
