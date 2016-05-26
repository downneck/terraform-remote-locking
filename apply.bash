#!/bin/bash

#
# apply.bash, Copyright 2016 David Kovach and William Broach
#
# verifies a remote lock, runs terraform apply, removes lock
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
