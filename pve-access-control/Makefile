# Name of the package
NAME = libpve-access-control

# Version (pinned upstream commit)
VERSION = 9.2.3

# Revision number
RELEASE = 1

# URL of the project
URL = https://github.com/proxmox/pve-access-control

# short summary of what the package provides
SUMMARY = Proxmox VE access control library (Perl)

# Long version of the summary
DESCRIPTION = Proxmox VE access control and permission handling library.

# License of the upstream project
LICENSE = GPL-2+

# NIST Vulnerability Database CPE pattern
NVD_CPE_PATTERN = cpe:2.3:a:proxmox:pve:*:*:*:*:*:*:*

###############################################################################
# Source: pinned GitHub commit tarball
###############################################################################

URL_SRC = https://codeload.github.com/proxmox/pve-access-control/tar.gz/7596eb2310938e19cb64b61e1d0544f5eaeab264

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
	@$(WGS) -u $(URL_SRC) -O pve-access-control-9.2.3.tar.gz
	@rm -rf $(SOURCE_DIR).tmp
	@mkdir -p $(SOURCE_DIR).tmp
	@tar -xf $(CACHE_DIR)/pve-access-control-9.2.3.tar.gz -C $(SOURCE_DIR).tmp --strip-components=1
	@rm -rf $(SOURCE_DIR)
	@mkdir -p $(SOURCE_DIR)
	@cp -a $(SOURCE_DIR).tmp/src/. $(SOURCE_DIR)/
	@rm -rf $(SOURCE_DIR).tmp
	# Inject build-time stubs for the pve-cluster modules that
	# PVE::AccessControl loads at compile time.  The real modules are
	# unavailable here (libpve-cluster-perl declares libpve-access-control
	# as a build dependency - circular).  The stubs only make the module
	# graph loadable for manpage/completion generation and are not
	# installed into the package.
	@mkdir -p $(SOURCE_DIR)/PVE
	@cp buildstub/PVE/Cluster.pm $(SOURCE_DIR)/PVE/Cluster.pm
	@cp buildstub/PVE/DataCenterConfig.pm $(SOURCE_DIR)/PVE/DataCenterConfig.pm
	@$(SOURCE_TAR_CMD)
