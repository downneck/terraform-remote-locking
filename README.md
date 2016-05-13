# Terraform Remote Locking

to prevent corruption of our remote tfstate, we use an s3 bucket to hold remote locks. each subdirectory of this directory holds a separate terraform stack with its own remote tfstate. bucket to hold state and locks can be defined using the TF_STATE_BUCKET environment variable (ex. TF_STATE_BUCKET="my-s3-bucket-name").

* requires the AWS CLI to be installed and available in your PATH
* to make a new stack, just create the empty directory and then run makelinks.bash. NOTE: DO NOT COPY EXISTING DIRECTORIES
