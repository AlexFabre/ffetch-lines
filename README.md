# ffetch-lines
A little bash script to extract specific lines from a file

## Usage 

All available options can be listed with option -h

~~~sh
./ffetch-lines.sh -h                                                                            
==> ffetch-lines.sh 0.1.0
A little bash script to extract specific
lines from a file
Usage:
ffetch-lines.sh <file> <line1> [<line2> ...] -o <output-file> [options]
-h <help>
-v <script version>
~~~

Getting lines 2, 6 and from 9 to 63 out of `file.c` :

~~~sh
./ffetch-lines.sh dir/subdir/file.c 2 6 9-63 output.txt
57 lines written to output.txt
~~~

## Code quality

~~~txt
ShellCheck - shell script analysis tool
version: 0.9.0
license: GNU General Public License, version 3
website: https://www.shellcheck.net
~~~

## TODO List

* The script uses bash arrays and other specific syntax. It would be nice to make the script POSIX shell compatible. 