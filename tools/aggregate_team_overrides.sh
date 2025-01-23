#!/usr/bin/env bash
# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

##
# This script is used to generate an aggregate team membership
# file based on a directory of yaml files of the 
# form team-name.yaml
# This tool is used as part of team-management automation
##

set -eu
set -o pipefail

# $1 - teams directory
if [ $# -ne 2 ]; then
  echo "Usage: $0 <TEAMS_DIRECTORY>"
  exit 1
fi

>&2 echo "> Aggregating Teams from $1/*.yaml"
CDIR=`pwd`
cd "$1"
echo "teams:" 
for file in *.yaml; do
     >&2 echo ">> Processing: $file"
     f="${file%.*}"
     cd "$CDIR"; cd "$2"
     for user in *.yaml; do
        >&2 echo ">> Checking Special User File: $user"
        yq ".teams.$f" $user
     done
     cd "$CDIR"; cd "$1"
     >&2 echo "> Aggregating Teams from $1/*.yaml"
     echo "  $f:" 
     sed 's/^/    /' "$file"
     #Add one blank line after each team just to make sure it exists"
     echo "" 
done

