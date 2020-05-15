#!/bin/sh

# Copyright (c) 2020, The Tor Project, Inc.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#
#     * Neither the names of the copyright owners nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Usage:
# 1) Point to a log file with all the dependency download attempts (for its
#    generation see: projects/common/how-to-create-gradle-dependencies-list.txt)
# 2) Double-check that you get the same SHA-256 sums when downloaded from a
#    different network location. E.g. by using `torsocks` with this script after
#    having made a copy of `gradle-dependencies-list.txt` from 1) and comparing
#    the two .txt files.

log="$1"

# Step 1: Extract all the download attempts out of the log file, ignore the ones
# for maven-metadata.xml files. We don't need those.
cat $log | grep "Performing HTTP" | grep -o "https://.*" | \
  grep -v "maven-metadata.xml" | sort | uniq > dl-attempts

# Step 2: Fetch all the dependencies and calculate the SHA-256 sum
while read line
do
  wget -U "" $line
  fn=$(basename "$line")
  sha256=`sha256sum $fn | cut -d ' ' -f 1`
  echo "$sha256 | $line" >> deps
  rm $fn
done < dl-attempts

# Step 3: Add the header at the beginning of the final dependency file.
echo "# On how to update dependencies see projects/common/how-to-create-gradle\
-dependencies-list.txt" > gradle-dependencies-list.txt
echo "# Don't forget to update var/gradle_dependencies_version when modifying \
this file" >> gradle-dependencies-list.txt
echo "sha256sum | url" >> gradle-dependencies-list.txt

# Step 4: Keep only successfully downloaded artifacts, remove duplicates, and
# sort based on download URL.
grep ^[a-f0-9] deps | rev | sort -t/ -u -k1,4 | rev | \
  sort -k 3 >> gradle-dependencies-list.txt

# Step 5: Clean up
rm dl-attempts
rm deps

exit 0
