# Name of the package
NAME = libpve-apiclient-perl

# Version (pinned upstream commit)
VERSION = 3.4.3

# Revision number
RELEASE = 1

# URL of the project
URL = https://github.com/proxmox/pve-apiclient

# short summary of what the package provides
SUMMARY = Proxmox VE API client library (Perl)

# Long version of the summary
DESCRIPTION = Proxmox VE API client helper library used by the PVE Perl API stack.

# License of the upstream project
LICENSE = GPL-2+

# NIST Vulnerability Database CPE pattern
NVD_CPE_PATTERN = cpe:2.3:a:proxmox:pve:*:*:*:*:*:*:*

###############################################################################
# Source: pinned GitHub commit tarball
###############################################################################

URL_SRC = https://codeload.github.com/proxmox/pve-apiclient/tar.gz/c202fe1b9dcdd68b7f1701118d1294f8db69c010

include buildenv/Makefile.common

$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST $(DIRECTORIES)
	@$(WGS) -u $(URL_SRC) -O pve-apiclient-3.4.3.tar.gz
	@tar -xf $(CACHE_DIR)/pve-apiclient-3.4.3.tar.gz -C $(SOURCE_DIR) --strip-components=1
	# patch wrapper Makefile: pin git SHA, drop lintian
	@sed -i 's|$$(shell git[ ]rev-parse[^)]*)|c202fe1b9dcdd68b7f1701118d1294f8db69c010|g' $(SOURCE_DIR)/Makefile
	@sed -i '/^[[:space:]]*lintian /d' $(SOURCE_DIR)/Makefile
	@$(SOURCE_TAR_CMD)
