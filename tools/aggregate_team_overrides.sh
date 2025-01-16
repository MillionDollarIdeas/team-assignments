#!/usr/bin/env bash
# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -eu
set -o pipefail

# $1 - directory
# $2 - output file
if [ -z "$1" ]; then
  echo "Error: Missing first argument - teams directory"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: Missing second argument - output file"
  exit 1
fi

cdir=`pwd`
outputfile=$cdir/$2

if [ -f "$outputfile" ]; then
  echo "Error: File '$outputfile' already exists." 
  exit 1 
fi

echo "# Aggregating Teams from $1/*.yaml"
cd $1
touch $outputfile
for file in *.yaml; do
     f="${file%.*}"
     echo "$f:" >> $outputfile
     sed 's/^/  /' $file >> $outputfile
done
