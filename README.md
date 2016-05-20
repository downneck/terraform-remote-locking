# Terraform Remote Locking

### General Info

To prevent corruption of our remote tfstate, we've created some scripts and a directory structure that allows us to use an s3 bucket to hold/check remote locks.

Each subdirectory of this directory holds a separate terraform stack with its own remote tfstate. The s3 bucket to hold state and locks can be defined using the TF_STATE_BUCKET environment variable (ex. TF_STATE_BUCKET="my-s3-bucket-name").

* requires the AWS CLI to be installed and available in your PATH
* requires terraform to be installed and available in your PATH
* to make a new stack, just create the empty directory and then run makelinks.bash. NOTE: DO NOT COPY EXISTING DIRECTORIES
* install_scripts.bash takes a directory and copies the bash scripts necessary for operation to it

### Installation and Configuration

* install and configure the AWS CLI as well as Terraform
* create an S3 bucket to hold the state and lock files, ensure you have write access
* set up your terraform config directory. we have provided a reference structure here and strongly recommend the use of git to track your infrastructure changes
* set your TF_STATE_BUCKET to point at the S3 bucket
* run the install_scripts.bash script, giving it your terraform config directory
* run makelinks.bash from inside your terraform config directory

### Example Repo Directory Structure

    ├── apply.bash
    ├── clearlocks.bash
    ├── makelinks.bash
    ├── plan.bash
    ├── provider.tf
    ├── terraform.tfstate
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

