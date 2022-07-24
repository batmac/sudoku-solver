#! /bin/bash

set -x
whoami
echo
date
echo
printenv
echo
uname -a
echo
lsb_release -a
echo
cat /proc/cpuinfo
echo
free -m
echo
sysctl hw
echo
#sudo dmesg
echo
df -h
echo

time make
time ./sudoku test/false.txt ; r=$?; if [ $r != 255 ]; then echo ERROR $r; exit 255; fi
time ./sudoku test/false2.txt; r=$?; if [ $r != 4 ]; then echo ERROR $r; exit 255; fi
time ./sudoku test/easy.txt;   r=$?; if [ $r != 0 ]; then echo ERROR $r; exit 255; fi
time ./sudoku test/valid.txt;  r=$?; if [ $r != 0 ]; then echo ERROR $r; exit 255; fi
time ./sudoku test/empty.txt;  r=$?; if [ $r != 0 ]; then echo ERROR $r; exit 255; fi
time ./sudoku test/slow.txt;   r=$?; if [ $r != 0 ]; then echo ERROR $r; exit 255; fi
echo
echo OK
touch test/last-test-ok
date
exit 0
