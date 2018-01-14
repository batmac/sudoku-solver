#! /bin/bash

set -x
[ -f last-test-ok ] && rm last-test-ok

if [ "$TEST_PLATFORM" == "raspbian" ] ; then
	set -e
	echo '$TEST_PLATFORM' "$TEST_PLATFORM"
	if ! type apt-get ; then
		echo "apt-get not found"
		exit 97
	fi
	cd "`dirname $0`/qemu-raspbian"
	pwd
	time make sync FROM="`git rev-parse --show-toplevel`" TO="/tmp/" RSYNC_OPTIONS="--exclude=.git --exclude=raspbian -v"
	time make DIR=r
	sudo chroot r /bin/sh -c 'cd tmp/*; pwd; make clean'
	sudo chroot r /bin/sh -c 'cd tmp/*;make test'
	if [ -f r/tmp/*/last-test-ok ] ;then
		echo "raspbian test succeeded"
		rm -f r/tmp/*/last-test-ok
	else
		exit 98
	fi

	exit 99

fi
	
./sudoku test/false.txt ; r=$?; if [ $r != 255 ]; then echo ERROR $r; exit $r; fi
./sudoku test/false2.txt; r=$?; if [ $r != 4 ]; then echo ERROR $r; exit $r; fi
./sudoku test/valid.txt;  r=$?; if [ $r != 0 ]; then echo ERROR $r; exit $r; fi
echo
echo OK
touch last-test-ok
exit 0
