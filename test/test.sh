#! /bin/bash

set -x

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

[ -f last-test-ok ] && rm last-test-ok

if [ "$TEST_PLATFORM" == "qemu-raspbian" ] ; then
	set -e
	echo "TEST_PLATFORM => $TEST_PLATFORM"
	unset TEST_PLATFORM
	if ! type apt-get ; then
		echo "apt-get not found"
		exit 97
	fi
	cd "`dirname $0`/qemu-raspbian"
	pwd
	time make sync DIR=r FROM="`git rev-parse --show-toplevel`" TO="/tmp/" RSYNC_OPTIONS="--exclude=.git --exclude=qemu-raspbian -v"
	time make DIR=r
	sudo chroot r /bin/sh -c 'cd tmp/*; pwd; make clean'
	sudo chroot r /bin/sh -c 'cd tmp/*;make test'
	if [ -f r/tmp/*/last-test-ok ] ;then
		echo "qemu-raspbian test succeeded"
		rm -f r/tmp/*/last-test-ok
		exit 0
	else
		exit 98
	fi
	exit 99
fi
	
make
./sudoku test/false.txt ; r=$?; if [ $r != 255 ]; then echo ERROR $r; exit $r; fi
./sudoku test/false2.txt; r=$?; if [ $r != 4 ]; then echo ERROR $r; exit $r; fi
./sudoku test/valid.txt;  r=$?; if [ $r != 0 ]; then echo ERROR $r; exit $r; fi
echo
echo OK
touch last-test-ok
exit 0
