# Terraform Remote Locking

### General Info

These scripts will help prevent corruption of a remote tfstate and allow for smoother team-wide interaction by using an s3 bucket to hold/check remote locks in addition to tfstate.

This software presumes that you're setting up your terraform config directory with a similar structure (represented in the Example Repo Directory Structure section below). Each subdirectory of the main config directory holds a separate terraform stack with its own remote tfstate. The links in each subdirectory (created using makelinks.bash) allow for sharing of variables across all stacks.


### Installation and Configuration

* install and configure the AWS CLI as well as Terraform
* create an S3 bucket to hold the state and lock files, ensure you (and the rest of your team) have write access to the bucket
* set up your terraform config directory. we have provided a reference structure here and strongly recommend the use of git to track your infrastructure changes
* set your TF_STATE_BUCKET to point at the S3 bucket (ex. TF_STATE_BUCKET="my-s3-bucket-name")
* run the install_scripts.bash script, giving it your terraform config directory
* run makelinks.bash from inside your terraform config directory


### Usage

NOTE: to make a new stack, create the empty directory under your main terraform directory (ie. the one with makelinks.bash in it) and then run makelinks.bash. DO NOT COPY EXISTING DIRECTORIES as this will copy the tfstate and cause havoc.

Applying terraform changes
* cd into the target stack's directory
* update default.tf with your changes
* run ./plan.bash (do not run "terraform plan" directly)
* run ./apply.bash (assuming plan.bash succeeds) (do not run "terraform apply" directly)

if your plan fails for any reason or if you decide not to apply the plan, you can use clearlocks.bash to remove your user's lock from that stack. removing an entire stack with "terraform destroy" remains unchanged.


### Example Repo Directory Structure

    ├── apply.bash
    ├── clearlocks.bash
    ├── makelinks.bash
    ├── plan.bash
    ├── provider.tf
    ├── terraform.tfvars
    ├── variables.tf
    ├── service.us-east-1
    │   ├── apply.bash -> ../apply.bash
    │   ├── clearlocks.bash -> ../clearlocks.bash
    │   ├── default.tf
    │   ├── plan.bash -> ../plan.bash
    │   ├── provider.tf -> ../provider.tf
    │   ├── terraform.tfvars -> ../terraform.tfvars
    │   └── variables.tf -> ../variables.tf
    ├── frontend.us-east-1
    │   ├── apply.bash -> ../apply.bash
    │   ├── clearlocks.bash -> ../clearlocks.bash
    │   ├── default.tf
    │   ├── plan.bash -> ../plan.bash
    │   ├── provider.tf -> ../provider.tf
    │   ├── terraform.tfvars -> ../terraform.tfvars
    │   └── variables.tf -> ../variables.tf

