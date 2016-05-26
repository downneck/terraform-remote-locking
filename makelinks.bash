#!/bin/bash
set -ue
#
# makelinks.bash, Copyright 2016 David Kovach and William Broach
#
# walks through all the subdirectories of the main repo dir and creates
# links back to common files necessary for a terraform stack to operate
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


# do the needful
for i in $(ls -d */) ; do 
  cd $i

  # make the links
  ln -s ../clearlocks.bash ||true
  ln -s ../apply.bash ||true
  ln -s ../plan.bash ||true
  ln -s ../provider.tf ||true
  ln -s ../terraform.tfvars ||true
  ln -s ../variables.tf ||true

  # set up remote state
  current_dir="$(pwd)"
  prefix="${current_dir##*/}"
  terraform remote config -backend=s3 -backend-config="bucket=$TF_STATE_BUCKET" -backend-config="key=${prefix}/terraform.tfstate"
  cd ../
done
