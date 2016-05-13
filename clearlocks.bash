#!/bin/bash
#
# clears any locks for your user to allow you to re-run plan.bash
# to be used sparingly

# make sure we have a TF_STATE_BUCKET env var populated
if [ -z "$TF_STATE_BUCKET" ]; then
  echo "TF_STATE_BUCKET environment variable has not been set, bailing out"
  exit 1
fi


# Initialize some vars we'll need later
current_dir="$(pwd)"
stackname="${current_dir##*/}"
lockfilename=`whoami`.lock


# Check for existing lock
aws s3 ls s3://$TF_STATE_BUCKET/$stackname/$lockfilename | grep $(whoami)

if [ $? == 0 ]; then
  echo "[OK]: Found YOUR lockfile!, REMOVING"
  s3cmd -q del s3://$TF_STATE_BUCKET/$stackname/$lockfilename 2>/dev/null
else
  echo "[Error]: No lock from your user found"
fi
