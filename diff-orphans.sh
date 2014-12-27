#!/bin/bash

# setup Bash environment
set -euf -o pipefail

DIR_LEFT=$(readlink -f "$1")
DIR_RIGHT=$(readlink -f "$2")
SCRIPT_NAME=$(basename $0)

LIST_LEFT=/tmp/$SCRIPT_NAME.$$.$RANDOM.list
LIST_RIGHT=/tmp/$SCRIPT_NAME.$$.$RANDOM.list

find $DIR_LEFT | sort > $LIST_LEFT
find $DIR_RIGHT | sort > $LIST_RIGHT

sed -i "s|^$DIR_LEFT[/]*||g" $LIST_LEFT
sed -i "s|^$DIR_RIGHT[/]*||g" $LIST_RIGHT

diff $LIST_LEFT $LIST_RIGHT

rm -f $LIST_LEFT
rm -f $LIST_RIGHT

echo "Complete"
