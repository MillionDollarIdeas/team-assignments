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
#yq -V
#yq --help
#yq m *.yaml
# Merge all the team files
#yq eval-all '. as $item ireduce ({}; . * $item )' ladder/teams/*.yaml

aggregate_yaml=$(echo -e "teams:")
for file in *.yaml; do
     >&2 echo ">> Processing: $file"
     f="${file%.*}"
     cd "$CDIR"; cd "$2"
     cd "$CDIR"; cd "$1"
     >&2 echo "> Aggregating Teams from $1/*.yaml"
     aggregate_yaml+=$'\n'$(echo -e "  $f:") 
     aggregate_yaml+=$'\n'$(sed 's/^/    /' "$file")
     #Add one blank line after each team just to make sure it exists"
     aggregate_yaml+=$'\n' 
done
temp_agg_file=$(mktemp)
echo "$aggregate_yaml" > $temp_agg_file 

temp_user_merge_file=$(mktemp)
temp_user_file=$(mktemp)
temp_merge_file=$(mktemp)
cd "$CDIR"; cd "$2"
for userfile in *.yaml; do
        echo  'teams:' > $temp_user_file
        >&2 echo ">> Checking Special User File: $userfile"
	user="${userfile%.*}"
        teams=`yq '.teams | keys | .[] ' $userfile`
	for team in $teams; do
                echo  "  $team:" >> $temp_user_file
	        result=`yq ".teams.$team.member" $userfile`
	        if [ "$result" = "true" ]; then
                  >&2 echo "user $user is a member of $team"
		  echo  "    members:" >> $temp_user_file
		  echo  "      - $user" >> $temp_user_file
	        fi  
                result=`yq ".teams.$team.mentor" $userfile`
	        if [ "$result" = "true" ]; then
                  >&2 echo "user $user is a mentor of $team"
		  echo  "    mentors:" >> $temp_user_file
		  echo  "      - $user" >> $temp_user_file
	        fi  
	done
	yq eval-all '. as $item ireduce ({}; . *+ $item )' $temp_user_file $temp_merge_file > $temp_user_merge_file
	cat $temp_user_merge_file > $temp_merge_file
	echo "" > $temp_user_merge_file
	#cat $temp_merge_file
done

yq eval-all '. as $item ireduce ({}; . *+ $item )' $temp_agg_file $temp_merge_file 

