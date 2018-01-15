#! /bin/bash

set -x
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

[ -f test/last-test-ok ] && rm test/last-test-ok

if [ "$TEST_PLATFORM" == "qemu-raspbian" ] ; then
	set -e
	echo "TEST_PLATFORM => $TEST_PLATFORM"
	unset TEST_PLATFORM
	cd "`dirname $0`/qemu-raspbian"
	pwd
	time make sync DIR=chroot FROM="`git rev-parse --show-toplevel`" TO="/tmp/" RSYNC_OPTIONS="--exclude=.git --exclude=qemu-raspbian -v"
	time make DIR=chroot CC=$CC
	sudo chroot chroot /bin/sh -c 'cd tmp/*; pwd; make clean'
	sudo chroot chroot /bin/sh -c 'cd tmp/*;make test'
	if [ -f chroot/tmp/*/test/last-test-ok ] ;then
		echo "qemu-raspbian test succeeded"
		rm -f chroot/tmp/*/test/last-test-ok
		exit 0
	else
		exit 98
	fi
	exit 99
fi
	
time make
./sudoku test/false.txt ; r=$?; if [ $r != 255 ]; then echo ERROR $r; exit -1; fi
./sudoku test/false2.txt; r=$?; if [ $r != 4 ]; then echo ERROR $r; exit -1; fi
./sudoku test/valid.txt;  r=$?; if [ $r != 0 ]; then echo ERROR $r; exit -1; fi
echo
echo OK
touch test/last-test-ok
date
exit 0
