#! /usr/bin/env sh

./sudoku test/false.txt ; r=$?; if [ $r != 255 ]; then echo ERROR $r; exit $r; fi
./sudoku test/false2.txt; r=$?; if [ $r != 4 ]; then echo ERROR $r; exit $r; fi
./sudoku test/valid.txt;  r=$?; if [ $r != 0 ]; then echo ERROR $r; exit $r; fi
echo
echo OK
exit 0
