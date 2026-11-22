# Name of the package
NAME = libpve-common-perl

# Version (pinned upstream commit)
VERSION = 9.2.13

# Revision number
RELEASE = 1

# URL of the project
URL = https://github.com/proxmox/pve-common

# short summary of what the package provides
SUMMARY = Proxmox VE common Perl library

# Long version of the summary
DESCRIPTION = Common base library shared by all Proxmox VE Perl components.

# License of the upstream project
LICENSE = GPL-2+

# NIST Vulnerability Database CPE pattern
NVD_CPE_PATTERN = cpe:2.3:a:proxmox:pve:*:*:*:*:*:*:*

###############################################################################
# Source: pinned GitHub commit tarball
###############################################################################

URL_SRC = https://codeload.github.com/proxmox/pve-common/tar.gz/3f266a9772961cd7fadc9d8ae0bcdefe16909195

include buildenv/Makefile.common

$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST $(DIRECTORIES)
	@$(WGS) -u $(URL_SRC) -O pve-common-9.2.13.tar.gz
	@tar -xf $(CACHE_DIR)/pve-common-9.2.13.tar.gz -C $(SOURCE_DIR) --strip-components=1
	# patch wrapper Makefile: pin git SHA, drop lintian
	@sed -i 's|$$(shell git[ ]rev-parse[^)]*)|3f266a9772961cd7fadc9d8ae0bcdefe16909195|g' $(SOURCE_DIR)/Makefile
	@sed -i '/^[[:space:]]*lintian /d' $(SOURCE_DIR)/Makefile
	@$(SOURCE_TAR_CMD)
