# diff-orphans

This is a Bash script that efficiently identifies orphan files in large trees.  _( An orphan file is a file that exists in one tree but not another. )_
The script is useful for sanity-checking after copying large trees, without diff'ing the file contents of the entire tree.  This script should be capable of running in OS X or in Linux.

This method operates by creating sorted file listings for each of the trees, and then using the standard ```diff``` tool on the file listings.  While this method does not detect differences in file contents, it does identify any missing files in either tree.


## Environment
* Any OS having a Bash environment
* The following tools must be installed, executable, and in the PATH:
    * readlink
    * basename
    * find
    * sort
    * sed
    * diff
    * rm


## Installation
Simply copy diff-orphans.sh to a directory of your choosing.  Don't forget to make it executable:

    chmod +x diff-orphans.sh


## Usage
```
./diff-orphans.sh <leftTree> <rightTree>
```
the script logs its results to a file named _"orphans-tree-full.txt"_ in your `$HOME` folder

## Example usage
The following example shows that the "right" directory has an (extra) orphan file named "file5":
```
user@computer:~$ ./diff-orphans.sh left/ right/
[+] Testing dependencies...
[+] Validating arguments...
[+] Performing diff of trees...
2d1
< file5
[*] Success
```

The following example shows identical "left" and "right" directories (no orphans):
```
user@computer:~$ ./diff-orphans.sh left/ right/
[+] Testing dependencies...
[+] Validating arguments...
[+] Performing diff of trees...
[*] No orphans found
[*] Success
```
