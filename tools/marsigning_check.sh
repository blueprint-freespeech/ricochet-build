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
# 1) Let SIGNMAR point to your signmar binary
# 2) Let LD_LIBRARY_PATH point to the mar-tools directory
# 3) Let NSS_DB_DIR point to the directory containing the database with the
#    signing certificate to check against.
#
#    To create the database to use for signature checking import the
#    release*.der certificate of your choice found in
#    toolkit/mozapps/update/updater by issuing the following commands:
#
#    mkdir nssdb
#    certutil -d nssdb -N --empty-password
#    certutil -A -n "marsigner" -t,, -d nssdb -i /path/to/.der
#
# 4) Change into the directory containing the MAR files and the
#    sha256sums-unsigned-build.txt/sha256sums-unsigned-build.incrementals.txt.
# 5) Run /path/to/marsigning_check.sh

if [ -z "$SIGNMAR" ]
then
  echo "The path to your signmar binary is missing!"
  exit 1
fi

if [ -z "$LD_LIBRARY_PATH" ]
then
  echo "The library search path to your mar-tools directory is missing!"
  exit 1
fi

if [ -z "$NSS_DB_DIR" ]
then
  echo "The path to your nssdb directory is missing!"
  exit 1
fi

unsigned_mars=0
badsigned_mars=0
not_reproduced_mars=0
# XXX: Stripping the signature of signed macOS MAR files is currently not
# expected to be reproducible, see: #20254.
not_reproduced_mars_expected=0

mkdir tmp

for f in *.mar; do
  case $f in
    *.incremental.mar) sha256_txt=$(grep "$f" \
      sha256sums-unsigned-build.incrementals.txt);;
    *) sha256_txt=$(grep "$f" sha256sums-unsigned-build.txt);;
  esac

  # Test 1: Is the MAR file correctly signed?
  echo "Verifying the MAR signature of $f..."
  if ! $SIGNMAR -d "$NSS_DB_DIR" -n marsigner -v "$f"
  then
    # Something went wrong. Let's figure out what.
    if [ "$sha256_txt" = "$(sha256sum "$f")" ]
    then
      echo "$f has still the SHA-256 sum of the unsigned MAR file!"
      unsigned_mars=$((unsigned_mars + 1))
    else
      echo "$f is either signed with the wrong key or the signature is" \
           "corrupted!"
      badsigned_mars=$((badsigned_mars +1))
    fi
  fi

  # Test 2: Do we get the old SHA-256 sum after stripping the MAR signature? We
  # want to have a test for that to be sure we've the signed MAR files in front
  # of us which we actually want to ship to our users.
  if [ "$unsigned_mars" = "0" ] && [ "$badsigned_mars" = "0" ]
  then
    # At least we seem to have succeeded in signing the MAR file. Let's see if
    # it is the expected one.
    echo "Checking the SHA-256 sum of the stripped $f..."
    ${SIGNMAR} -r "$f" tmp/"$f"
    cd tmp || exit 1
    if ! [ "$sha256_txt" = "$(sha256sum "$f")" ]
    then
      not_reproduced_mars=$((not_reproduced_mars + 1))
      case "$f" in
        *osx64*)
          not_reproduced_mars_expected=$((not_reproduced_mars_expected + 1))
          ;;
        *) echo "$f does not have the SHA-256 sum of the unsigned MAR file!"
          ;;
      esac
    fi
    rm "$f"
    cd ..
  fi
  echo ""
done

rm -rf tmp/

if ! [ "$unsigned_mars" = "0" ] || ! [ "$badsigned_mars" = "0" ]
then
  echo "We got:"
  if ! [ "$unsigned_mars" = "0" ]
  then
    echo "$unsigned_mars unsigned MAR file(s)"
  fi
  if ! [ "$badsigned_mars" = "0" ]
  then
    echo "$badsigned_mars badly signed MAR file(s)"
  fi
  echo "exiting..."
  exit 1
fi

if ! [ "$not_reproduced_mars" = "0" ]
then
  echo "We got $not_reproduced_mars non-matching, signed MAR files."
  if [ "$not_reproduced_mars" -eq "$not_reproduced_mars_expected" ]
  then
    echo "This is currently expected as we got the same amount of" \
         "non-matching macOS MAR files."
    echo "The signatures and non-macOS MAR files are fine."
    exit 0
  else
    echo "This is currently unexpected as we only got" \
         "$not_reproduced_mars_expected non-matching macOS MAR files," \
         "exiting..."
    exit 1
  fi
else
  echo "The signatures and MAR files are fine."
  exit 0
fi
