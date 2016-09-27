#!/bin/bash

# DIFF ORPHANS
#
# Bash script to efficiently identify orphan files in large trees.
# Useful for sanity-checking after copying large trees.
# This script should be capable of running in OS X or in Linux.
#
# Version: 1.1.0
# Author: Codice Ovvio
# URL: https://github.com/codiceovvio/diff-orphans
# License: GPLv2+
# (C) 2016 Codice Ovvio <codiceovvio@gmail.com>
#
#
# This is a fork of diff-orphans v1.0.3 by J.Elchison
# Original script (C) 2015 Jonathan Elchison <JElchison@gmail.com>
# it can be found at: https://github.com/JElchison/diff-orphans
#
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

# ------------------------------------------
# prints script usage to stderr
# ------------------------------------------
print_usage() {
    echo "Usage: $(basename $0) <leftTree> <rightTree>" >&2
}


# ------------------------------------------
# test dependencies
# ------------------------------------------
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


# ------------------------------------------
# validate arguments
# ------------------------------------------
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


# ------------------------------------------
# setup script variables
# ------------------------------------------

NAME_LEFT=$(basename "$1")
NAME_RIGHT=$(basename "$2")

FULL_LIST="$HOME/orphans-tree-full.txt"

# ------------------------------------------
# perform diff of trees
# ------------------------------------------

echo "[+] Performing diff of trees..." >&2

echo "Tree comparison report:"
echo "-----------------------"
diff --unchanged-group-format="" --old-group-format="
Only in folder \"${NAME_LEFT}\"
%<---" --new-group-format="
Only in folder \"${NAME_RIGHT}\"
%>---
"   <(find "$DIR_LEFT" | sort | sed "s|^$DIR_LEFT[/]*||g") \
    <(find "$DIR_RIGHT" | sort | sed "s|^$DIR_RIGHT[/]*||g") > "$FULL_LIST" \
    && echo "[*] No orphans found"


# ------------------------------------------
# report status
# ------------------------------------------

echo "[*] Success" >&2
echo "    You can check the log file generated at" \""$FULL_LIST"\" >&2
