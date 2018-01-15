#! /bin/bash
set -e
set -x

CHROOT_DIR=chrootdir
ARCH=amd64
SUITE=stretch
# empty means debian (official)
MIRROR=
# empty means we don't touch sources.list
SOURCESLIST=
CHROOT_CMD='chroot'
PKGS=

die() { echo "$*" 1>&2 ; exit 1; }
while getopts "ba:s:m:l:c:i:" opt; do
	case $opt in
		b)
			type apt-get || die "apt-get not found."
			apt-get install -q -y debootstrap binfmt-support qemu-user-static
			update-binfmts --display
			;;
		a)
			ARCH=$OPTARG
			;;
		s)
			SUITE=$OPTARG
			;;
		m)
			MIRROR=$OPTARG
			;;
		l)
			SOURCESLIST=$OPTARG
			;;
		c)
			CHROOT_DIR=$OPTARG
			;;
		i)
			PKGS=$OPTARG
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			;;
	esac
done
shift "$((OPTIND-1))"

# sanity checks
[ "$USER" != "root" ] && die 'script must be run as  root.'
[ -z "$1" ] && die "Usage: $0 <dir>"

CHROOT_DIR=$1
[ -n "$PKGS" ] && INCLUDE_PKGS="--include=$PKGS"
qemu-debootstrap --no-check-gpg --variant=minbase $INCLUDE_PKGS --arch="$ARCH" "$SUITE" "$CHROOT_DIR" $MIRROR
if [ -n "$SOURCESLIST" ] ; then
	echo $SOURCESLIST > $CHROOT_DIR/etc/apt/sources.list
fi
rm -rf $CHROOT_DIR/var/cache/apt/archives/*
cat <<EOF >$CHROOT_DIR/usr/sbin/policy-rc.d
#!/bin/sh
echo "rc.d operations disabled"
exit 101
EOF
chmod 0755 $CHROOT_DIR/usr/sbin/policy-rc.d
touch $CHROOT_DIR/chroot-done

#$CHROOT_CMD $CHROOT_DIR apt-get update


