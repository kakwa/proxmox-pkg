# Name of the package
NAME = qemu-server

# Version (pinned upstream commit)
VERSION = 9.2.22

# Revision number
RELEASE = 1

# URL of the project
URL = https://github.com/proxmox/qemu-server

# short summary of what the package provides
SUMMARY = Proxmox VE QEMU/KVM server management

# Long version of the summary
DESCRIPTION = QEMU/KVM virtual machine management stack for Proxmox VE.

# License of the upstream project
LICENSE = GPL-2+

# NIST Vulnerability Database CPE pattern
NVD_CPE_PATTERN = cpe:2.3:a:proxmox:pve:*:*:*:*:*:*:*

###############################################################################
# Source: pinned GitHub commit tarball
###############################################################################

URL_SRC = https://codeload.github.com/proxmox/qemu-server/tar.gz/58474c07c0e7dddcb5bb3daa4753e35723fdfebe

include buildenv/Makefile.common

# The root Makefile is a repoman release wrapper: its "all" target
# (all: $(DEB)) is a no-op under dpkg-buildpackage and it has no
# install target, so a plain dh build would ship empty packages.
# Proxmox's own build stages the *contents* of src/ as the package
# root (see the wrapper's $(BUILDDIR) rule) so that dh runs the real
# build/install Makefile. Reproduce that layout here, and drop the
# upstream debian/ directory (the monorepo's debian/ is supplied by
# the in-chroot overlay).
$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST $(DIRECTORIES)
	@$(WGS) -u $(URL_SRC) -O qemu-server-9.2.22.tar.gz
	@rm -rf $(SOURCE_DIR).tmp
	@mkdir -p $(SOURCE_DIR).tmp
	@tar -xf $(CACHE_DIR)/qemu-server-9.2.22.tar.gz -C $(SOURCE_DIR).tmp --strip-components=1
	@rm -rf $(SOURCE_DIR)
	@mkdir -p $(SOURCE_DIR)
	@cp -a $(SOURCE_DIR).tmp/src/. $(SOURCE_DIR)/
	@rm -rf $(SOURCE_DIR).tmp
	@$(SOURCE_TAR_CMD)
