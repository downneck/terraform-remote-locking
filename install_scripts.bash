#!/bin/bash
#
# install_scripts.bash, Copyright 2016 David Kovach and William Broach
#
# when given a directory, copies the bash scripts in this repo to
# that directory and makes sure they're executable 
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


# make sure we're given reasonable input
if [ -z "$1" ]; then
  echo "USAGE: ./install_scripts.bash /path/to/terraform/config/repo"
  exit 1
elif [ ! -d "$1" ]; then 
  echo "$1 is not a directory."
  echo ""
  echo "USAGE: ./install_scripts.bash /path/to/terraform/config/repo"
  exit 1
elif [ ! -w "$1" ]; then
  echo "$1 is not writable"
  echo ""
  echo "USAGE: ./install_scripts.bash /path/to/terraform/config/repo"
  exit 1
else
  tfrepo=$1
fi

# advisory 
if [ -z "$TF_STATE_BUCKET" ]; then
  echo "TF_STATE_BUCKET environment variable has not been set!"
  echo "make sure you set it before using this software"
fi

cp ./{plan.bash,apply.bash,makelinks.bash,clearlocks.bash} ${tfrepo}
chmod 750 ${tfrepo}/{plan.bash,apply.bash,makelinks.bash,clearlocks.bash}
