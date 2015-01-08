#!/bin/bash

# diff-orphans.sh
#
# Bash script to efficiently identify orphaned files in large trees.  Useful for sanity-checking after copying large trees.  This script should be capable of running in OS X or in Linux.
#
# Version 1.0.2
#
# Copyright (C) 2015 Jonathan Elchison <JElchison@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


# setup Bash environment
set -euf -o pipefail

#######################################
# Prints script usage to stderr
# Arguments:
#   None
# Returns:
#   None
#######################################
print_usage() {
    echo "Usage:  $0 <leftTree> <rightTree>" >&2
}


###############################################################################
# test dependencies
###############################################################################

echo "[+] Testing dependencies..." >&2
if [[ ! -x $(which readlink) ]] ||
   [[ ! -x $(which basename) ]] ||
   [[ ! -x $(which find) ]] ||
   [[ ! -x $(which sort) ]] ||
   [[ ! -x $(which sed) ]] ||
   [[ ! -x $(which diff) ]] ||
   [[ ! -x $(which rm) ]]; then
    echo "[-] Dependencies unmet.  Please verify that the following are installed, executable, and in the PATH:  readlink, basename, find, sort, sed, diff, rm" >&2
    exit 1
fi


###############################################################################
# validate arguments
###############################################################################

echo "[+] Validating arguments..." >&2

# require exactly 2 arguments
if [[ $# -ne 2 ]]; then
    print_usage
    exit 1
fi

# setup variables for arguments
DIR_LEFT=$(readlink -f "$1")
DIR_RIGHT=$(readlink -f "$2")

# ensure arguments are valid directories
if [[ ! -e $DIR_LEFT ]]; then
    echo "[-] '$DIR_LEFT' does not exist" >&2
    print_usage
    exit 1
fi
if [[ ! -e $DIR_RIGHT ]]; then
    echo "[-] '$DIR_RIGHT' does not exist" >&2
    print_usage
    exit 1
fi


###############################################################################
# setup paths
###############################################################################

echo "[+] Setting up paths..." >&2

SCRIPT_NAME=$(basename $0)
LIST_LEFT=/tmp/$SCRIPT_NAME.$$.$RANDOM.list
LIST_RIGHT=/tmp/$SCRIPT_NAME.$$.$RANDOM.list


###############################################################################
# create trees
###############################################################################

echo "[+] Creating tree for left directory..." >&2
# `true` is so that a failure here doesn't cause entire script to exit prematurely
find "$DIR_LEFT" | sort > $LIST_LEFT || true

echo "[+] Creating tree for right directory..." >&2
# `true` is so that a failure here doesn't cause entire script to exit prematurely
find "$DIR_RIGHT" | sort > $LIST_RIGHT || true

echo "[+] Pruning trees..." >&2
sed -i "s|^$DIR_LEFT[/]*||g" $LIST_LEFT
sed -i "s|^$DIR_RIGHT[/]*||g" $LIST_RIGHT


###############################################################################
# perform diff of trees
###############################################################################

echo "[+] Performing diff of trees..." >&2
# `true` is so that a failure here doesn't cause entire script to exit prematurely
diff $LIST_LEFT $LIST_RIGHT && echo "[*] No orphans found"


###############################################################################
# cleanup
###############################################################################

echo "[+] Cleaning up..." >&2
rm -f $LIST_LEFT
rm -f $LIST_RIGHT


###############################################################################
# report status
###############################################################################

echo "[*] Success" >&2

