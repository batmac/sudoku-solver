SUDO=sudo
DIR=r
SCRIPT_SETUP=create-chroot.sh
CMD=uname -a
FROM=/etc/debian_version
TO=/tmp
RSYNC_OPTIONS=-v
PKGS=gcc,libc6-dev,make

$(DIR)/chroot-done: $(SCRIPT_SETUP)
	$(SUDO) ./$< \
		-b \
		-a armhf \
	       	-s stretch \
	       	-m 'http://mirrordirector.raspbian.org/raspbian/' \
		-l 'deb http://mirrordirector.raspbian.org/raspbian/ stretch main contrib non-free rpi' \
		-i $(PKGS) $(DIR)
enter: $(DIR)/chroot-done
	-$(SUDO) chroot $(DIR)
exec: $(DIR)/chroot-done
	-$(SUDO) chroot $(DIR) $(CMD)
sync:
	mkdir -p $(DIR)
	rsync -aH $(RSYNC_OPTIONS) $(FROM) $(DIR)/$(TO)
mount:
	$(SUDO) mount --bind /sys $(DIR)/sys
	$(SUDO) mount --bind /dev $(DIR)/dev
	$(SUDO) mount --bind /proc $(DIR)/proc
umount: 
	$(SUDO) umount -l $(DIR)/sys
	$(SUDO) umount -l $(DIR)/dev
	$(SUDO) umount -l $(DIR)/proc
clean:
	$(SUDO) $(RM) -rf $(DIR)

.PHONY: enter exec mount umount clean
