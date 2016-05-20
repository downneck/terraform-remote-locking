#!/bin/bash
#
# plan.bash, Copyright 2016 David Kovach and William Broach
#
# checks for remote lock, runs terraform apply
#
# This is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this.  If not, see <http://www.gnu.org/licenses/>.


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
