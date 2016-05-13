#!/bin/bash
#
# checks for remote lock, runs terraform apply


# make sure we have a TF_STATE_BUCKET env var populated
if [ -z "$TF_STATE_BUCKET" ]; then
  echo "TF_STATE_BUCKET environment variable has not been set, bailing out"
  exit 1
fi


# Initialize some vars we'll want later
current_dir="$(pwd)"
stackname="${current_dir##*/}"
lockfilename=`whoami`.lock


# Check for existing lock
aws s3 ls s3://$TF_STATE_BUCKET/$stackname/ | grep lock

if [ $? != 0 ]; then
  # wait 5 seconds then check a second time before writing a lock
  # this helps prevent a race condition where two people try to grab
  # a lock at the same time
  echo "[OK]: No lock file found, waiting 5 seconds before double check"
  sleep 5
  aws s3 ls s3://$TF_STATE_BUCKET/$stackname/ | grep lock

  # no lock found, proceed with locking for our user and running "terraform plan"
  if [ $? != 0 ]; then
    echo "[OK]: Locking now!"
    touch ./${lockfilename}
    aws s3 cp ./$lockfilename s3://$TF_STATE_BUCKET/$stackname/$lockfilename 2>/dev/null
    if [ $? != 0 ]; then
      echo "[ERROR]: Failed to place lockfile in S3"
      rm ./$lockfilename
      exit 1
    else
      rm ./$lockfilename
    fi
 
    echo "[OK]: Getting current terraform state"

    # Get the current state
    terraform remote pull

    # Run terraform plan
    terraform plan

    # Upload new terraform state
    terraform remote push

  fi
else
  echo "[Error]: Existing lock file found, please wait before proceeding, try again later"
fi
