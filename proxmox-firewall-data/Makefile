# Name of the package
NAME = proxmox-firewall-data

# Version (pinned upstream commit)
VERSION = 0.1

# Revision number
RELEASE = 1

# URL of the project
URL = https://github.com/proxmox/proxmox-firewall

# short summary of what the package provides
SUMMARY = Proxmox VE firewall data files

# Long version of the summary
DESCRIPTION = Shared firewall rule data and generated macro files for Proxmox VE.

# License of the upstream project
LICENSE = GPL-2+

# NIST Vulnerability Database CPE pattern
NVD_CPE_PATTERN = cpe:2.3:a:proxmox:pve:*:*:*:*:*:*:*

###############################################################################
# Source: pinned GitHub commit tarball
###############################################################################

URL_SRC = https://codeload.github.com/proxmox/proxmox-firewall/tar.gz/06203bb9c57512822d076fa75da2cbe4f8e0a4bf

include buildenv/Makefile.common

# The source is the proxmox-firewall Cargo workspace; this package is
# the proxmox-firewall-data subdirectory of that workspace (it has its
# own build Makefile and debian/ directory). The previous staging used
# --strip-components=2, which flattened the workspace root and the
# subdirectory on top of each other. Stage the contents of the
# subdirectory as the package root, and drop its upstream debian/
# (the monorepo's debian/ is supplied by the in-chroot overlay).
$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST $(DIRECTORIES)
	@$(WGS) -u $(URL_SRC) -O proxmox-firewall-data-0.1.tar.gz
	@rm -rf $(SOURCE_DIR).tmp
	@mkdir -p $(SOURCE_DIR).tmp
	@tar -xf $(CACHE_DIR)/proxmox-firewall-data-0.1.tar.gz -C $(SOURCE_DIR).tmp --strip-components=1
	@rm -rf $(SOURCE_DIR)
	@mkdir -p $(SOURCE_DIR)
	@cp -a $(SOURCE_DIR).tmp/proxmox-firewall-data/. $(SOURCE_DIR)/
	@rm -rf $(SOURCE_DIR)/debian
	# The upstream nested build directory (see the $(BUILDDIR) rule) contains
	# no Makefile, so dh skips the make-based build/install steps and relies
	# on the .install file. Drop the release wrapper Makefile to match.
	@rm -f $(SOURCE_DIR)/Makefile
	@rm -rf $(SOURCE_DIR).tmp
	@$(SOURCE_TAR_CMD)
