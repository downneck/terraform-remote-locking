#!/bin/bash
#
# walks through all the subdirectories of the main repo dir and creates
# links back to common files necessary for a terraform stack to operate

# make sure we have a TF_STATE_BUCKET env var populated
if [ -z "$TF_STATE_BUCKET" ]; then
  echo "TF_STATE_BUCKET environment variable has not been set, bailing out"
  exit 1
fi


# do the needful
for i in $(ls -d */) ; do 
  cd $i

  # make the links
  ln -s ../clearlocks.bash
  ln -s ../apply.bash
  ln -s ../plan.bash
  ln -s ../provider.tf
  ln -s ../terraform.tfvars
  ln -s ../variables.tf

  # set up remote state
  current_dir="$(pwd)"
  prefix="${current_dir##*/}"
  terraform remote config -backend=s3 -backend-config="bucket=$TF_STATE_BUCKET" -backend-config="key=${prefix}/terraform.tfstate"
  cd ../
done
