#!/usr/bin/env bash
# Copyright Authors of Cilium
# SPDX-License-Identifier: Apache-2.0

set -eu
set -o pipefail

# $1 - directory
echo "# Aggregating Teams from $1/*.yaml"
cd $1
for file in *.yaml; do
     f="${file%.*}"
     echo "$f:"
     sed 's/^/  /' $file
done
