#!/bin/bash
#
# verifies a remote lock, runs terraform apply, removes lock

# make sure we have a TF_STATE_BUCKET env var populated
if [ -z "$TF_STATE_BUCKET" ]; then
  echo "TF_STATE_BUCKET environment variable has not been set, bailing out"
  exit 1
fi

current_dir="$(pwd)"
stackname="${current_dir##*/}"
lockfilename=`whoami`.lock


# Check for existing lock
aws s3 ls s3://$TF_STATE_BUCKET/$stackname/$lockfilename | grep $(whoami)

if [ $? == 0 ]; then
  echo "[OK]: Found YOUR lockfile!, Proceeding with apply"
  sleep 1

  #Run terraform apply
  terraform apply

  #Upload new terraform state
  terraform remote push

  echo "[OK]: Apply complete!, Removing lock"
  aws -q s3 rm s3://$TF_STATE_BUCKET/$stackname/$lockfilename 2>/dev/null
else
  echo "[Error]: No lock from your user found, please run a plan first"
fi
